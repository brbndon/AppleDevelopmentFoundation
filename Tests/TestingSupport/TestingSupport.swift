import AppFoundation
import Foundation

/// A deterministic temporary directory helper for package tests only.
public enum TemporaryDirectory {
    public static func make(fileManager: FileManager = .default) throws -> URL {
        let url = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
