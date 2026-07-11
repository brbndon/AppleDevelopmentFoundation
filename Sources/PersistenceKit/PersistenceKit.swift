import Foundation
import SwiftData

/// Builds a model container without imposing a repository or domain model on an app.
public enum PersistenceContainerFactory {
    /// Creates a container for an application-owned schema.
    ///
    /// Set `inMemory` for previews and isolated tests. Production store locations and migration plans
    /// remain application-owned.
    @MainActor public static func make(schema: Schema, inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    /// Creates a container using application-supplied SwiftData configurations.
    ///
    /// Applications own store locations, migration choices, and backup policy. For example,
    /// tests can pass `[ModelConfiguration(isStoredInMemoryOnly: true)]` without selecting a
    /// package-defined production location.
    @MainActor public static func make(schema: Schema, configurations: [ModelConfiguration]) throws -> ModelContainer {
        try ModelContainer(for: schema, configurations: configurations)
    }
}

/// Sanitized categories for store-artifact cleanup failures.
public enum PersistenceArtifact: String, Equatable, Sendable {
    /// The primary SQLite store.
    case mainStore
    /// The SQLite write-ahead log sidecar.
    case writeAheadLog
    /// The SQLite shared-memory sidecar.
    case sharedMemory
}

/// A store-artifact cleanup failure that never includes the store path.
public enum PersistenceResetError: LocalizedError, Equatable, Sendable {
    /// Removing one artifact failed; cleanup of other artifacts was still attempted.
    case removalFailed(PersistenceArtifact)

    /// Multiple artifact removals failed; all failed artifact kinds are reported.
    case multipleRemovalsFailed([PersistenceArtifact])

    /// A sanitized description suitable for user-facing or developer diagnostics.
    public var errorDescription: String? {
        switch self {
        case .removalFailed(.mainStore): "The main store could not be removed."
        case .removalFailed(.writeAheadLog): "The write-ahead log sidecar could not be removed."
        case .removalFailed(.sharedMemory): "The shared-memory sidecar could not be removed."
        case .multipleRemovalsFailed: "Multiple store artifacts could not be removed."
        }
    }
}

/// Deletes application-owned SwiftData store files after their containers are closed.
public enum PersistenceReset {
    /// Removes a store URL and its SQLite sidecars independently when present.
    ///
    /// The caller must close every container using the store before invoking this operation.
    public static func removeStore(at url: URL, fileManager: FileManager = .default) throws {
        let artifacts: [(PersistenceArtifact, URL)] = [
            (.mainStore, url),
            (.writeAheadLog, URL(fileURLWithPath: url.path + "-wal")),
            (.sharedMemory, URL(fileURLWithPath: url.path + "-shm")),
        ]
        var failedArtifacts: [PersistenceArtifact] = []
        for (artifact, artifactURL) in artifacts where artifactExists(at: artifactURL, fileManager: fileManager) {
            do {
                guard !isSymbolicLink(at: artifactURL, fileManager: fileManager) else {
                    throw PersistenceResetError.removalFailed(artifact)
                }
                try fileManager.removeItem(at: artifactURL)
            } catch {
                failedArtifacts.append(artifact)
            }
        }
        if failedArtifacts.count == 1 {
            throw PersistenceResetError.removalFailed(failedArtifacts[0])
        } else if !failedArtifacts.isEmpty {
            throw PersistenceResetError.multipleRemovalsFailed(failedArtifacts)
        }
    }

    private static func artifactExists(at url: URL, fileManager: FileManager) -> Bool {
        fileManager.fileExists(atPath: url.path) || isSymbolicLink(at: url, fileManager: fileManager)
    }

    private static func isSymbolicLink(at url: URL, fileManager: FileManager) -> Bool {
        (try? fileManager.attributesOfItem(atPath: url.path)[.type] as? FileAttributeType) == .typeSymbolicLink
    }
}
