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
}

/// Deletes application-owned SwiftData store files after their containers are closed.
public enum PersistenceReset {
    /// Removes a store URL and its SQLite sidecars when present.
    ///
    /// The caller must close every container using the store before invoking this operation.
    public static func removeStore(at url: URL, fileManager: FileManager = .default) throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
        for suffix in ["-shm", "-wal"] {
            try? fileManager.removeItem(at: URL(fileURLWithPath: url.path + suffix))
        }
    }
}
