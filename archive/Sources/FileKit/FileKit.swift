import Foundation
import UniformTypeIdentifiers

/// Errors emitted by file validation and safe local file operations.
public enum FileKitError: LocalizedError, Equatable, Sendable {
    /// The file's declared type is not permitted by the import policy.
    case unsupportedType

    /// The file is larger than the policy's maximum byte count.
    case fileTooLarge(maximumBytes: Int)

    /// The URL cannot be accessed as a local file.
    case inaccessible

    /// The URL does not identify a regular file.
    case notARegularFile

    /// The policy has an invalid maximum byte count.
    case invalidMaximumBytes

    /// A safe portable filename could not be created.
    case invalidFilename

    /// A destination already exists and overwriting was not explicitly requested.
    case destinationExists

    /// A destination is a symbolic link and is never followed for writing.
    case unsafeDestination

    /// A selected source is a symbolic link and is never followed for importing.
    case unsafeSource

    /// A non-sensitive description suitable for user presentation.
    public var errorDescription: String? {
        switch self {
        case .unsupportedType: "This file type is not supported."
        case .fileTooLarge: "This file is too large."
        case .inaccessible: "The selected file is no longer accessible."
        case .notARegularFile: "The selected item is not a regular file."
        case .invalidMaximumBytes: "The file-size limit is invalid."
        case .invalidFilename: "A safe filename could not be created."
        case .destinationExists: "A file already exists at that destination."
        case .unsafeDestination: "The destination cannot be a symbolic link."
        case .unsafeSource: "The selected file cannot be a symbolic link."
        }
    }
}

/// A policy that validates imported regular files before an application reads their contents.
public struct FileImportPolicy: Sendable {
    /// The accepted Uniform Type Identifiers.
    public let allowedTypes: [UTType]

    /// The largest permitted file size in bytes.
    public let maximumBytes: Int

    /// Creates an import policy. A negative size limit is rejected during validation.
    public init(allowedTypes: [UTType], maximumBytes: Int) {
        self.allowedTypes = allowedTypes
        self.maximumBytes = maximumBytes
    }

    /// Validates a local regular file's declared type and size without reading its data.
    public func validate(_ url: URL) throws {
        guard maximumBytes >= 0 else { throw FileKitError.invalidMaximumBytes }
        guard url.isFileURL else { throw FileKitError.inaccessible }
        guard (try? FileManager.default.destinationOfSymbolicLink(atPath: url.path)) == nil else {
            throw FileKitError.unsafeSource
        }

        let values: URLResourceValues
        do {
            values = try url.resourceValues(forKeys: [.contentTypeKey, .fileSizeKey, .isRegularFileKey])
        } catch {
            throw FileKitError.inaccessible
        }

        guard values.isRegularFile == true else { throw FileKitError.notARegularFile }
        let type = values.contentType ?? UTType(filenameExtension: url.pathExtension)
        guard let type, allowedTypes.contains(where: { type.conforms(to: $0) }) else {
            throw FileKitError.unsupportedType
        }
        guard let size = values.fileSize else { throw FileKitError.inaccessible }
        guard size <= maximumBytes else { throw FileKitError.fileTooLarge(maximumBytes: maximumBytes) }
    }
}

/// Safe portable filename generation for user-provided names.
public enum SafeFilename {
    /// Produces a single portable filename component, sanitizing both the proposal and fallback.
    ///
    /// Unicode is canonically precomposed. Separators, colons, controls, and other forbidden
    /// characters become hyphens; unsafe edge whitespace and periods are trimmed. If either
    /// input becomes empty or is `.`/`..`, the next fallback is sanitized, ending at `Untitled`.
    public static func make(_ proposed: String, fallback: String = "document") throws -> String {
        func sanitize(_ input: String) -> String? {
            let forbidden = CharacterSet(charactersIn: "/\\:").union(.controlCharacters)
            let cleaned = input.precomposedStringWithCanonicalMapping
                .components(separatedBy: forbidden)
                .joined(separator: "-")
                .trimmingCharacters(in: .whitespacesAndNewlines.union(CharacterSet(charactersIn: ".")))
            guard !cleaned.isEmpty, cleaned != ".", cleaned != "..",
                  cleaned.contains(where: { $0 != "-" }) else { return nil }
            return String(cleaned.prefix(120))
        }
        guard let value = sanitize(proposed) ?? sanitize(fallback) ?? sanitize("Untitled") else {
            throw FileKitError.invalidFilename
        }
        return value
    }
}

/// Application Support and temporary file locations.
public enum FileLocations {
    /// Returns the user's Application Support directory, creating it when necessary.
    public static func applicationSupport(fileManager: FileManager = .default) throws -> URL {
        try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }

    /// Returns a sanitized path beneath the system temporary directory without creating a file.
    public static func temporaryFile(named name: String, fileManager: FileManager = .default) throws -> URL {
        fileManager.temporaryDirectory.appendingPathComponent(try SafeFilename.make(name))
    }
}

/// Atomic writing that refuses accidental replacement and symbolic-link destinations by default.
public enum AtomicFileWriter {
    /// Atomically writes `data` to a trusted destination.
    ///
    /// Existing regular files require `overwrite: true`. Symbolic links are always rejected so callers
    /// do not accidentally write outside an application-owned directory.
    public static func write(_ data: Data, to url: URL, overwrite: Bool = false) throws {
        guard url.isFileURL else { throw FileKitError.inaccessible }
        let path = url.path
        guard (try? FileManager.default.destinationOfSymbolicLink(atPath: path)) == nil else {
            throw FileKitError.unsafeDestination
        }
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            guard !isDirectory.boolValue else { throw FileKitError.notARegularFile }
            guard overwrite else { throw FileKitError.destinationExists }
        }
        try data.write(to: url, options: [.atomic])
    }
}

/// Executes `body` while security-scoped access is active and balances access when it throws.
public func withSecurityScopedAccess<Result>(_ url: URL, _ body: () throws -> Result) throws -> Result {
    guard url.startAccessingSecurityScopedResource() else { throw FileKitError.inaccessible }
    defer { url.stopAccessingSecurityScopedResource() }
    return try body()
}

/// Executes an asynchronous body while security-scoped access remains active across suspension points.
///
/// The caller still owns picker acquisition, sandbox entitlements, bookmark persistence where
/// applicable, and the lifetime of the externally acquired URL. The scope is balanced exactly once
/// after success, failure, or cancellation. If access cannot be started, it throws
/// ``FileKitError/inaccessible`` without invoking `body`. SwiftPM tests cannot prove signed-app
/// sandbox behavior.
public func withSecurityScopedAccess<Result>(_ url: URL, _ body: () async throws -> Result) async throws -> Result {
    guard url.startAccessingSecurityScopedResource() else { throw FileKitError.inaccessible }
    defer { url.stopAccessingSecurityScopedResource() }
    return try await body()
}
