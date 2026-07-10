import AppFoundation
import Foundation
import SwiftData

/// Builds a model container without imposing a repository or domain model on an app.
public enum PersistenceContainerFactory {
    /// Use an in-memory container for previews and tests; production schemas and migration plans remain app-owned.
    @MainActor public static func make(schema: Schema, inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}

public enum PersistenceReset {
    /// Deletes only the store URL supplied by the application after closing its container.
    public static func removeStore(at url: URL, fileManager: FileManager = .default) throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
        for suffix in ["-shm", "-wal"] { try? fileManager.removeItem(at: URL(fileURLWithPath: url.path + suffix)) }
    }
}
