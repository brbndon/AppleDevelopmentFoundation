import AppFoundation
import Foundation

/// A deterministic clock for package tests only.
public struct FixedClock: AppClock { public let date: Date; public init(_ date: Date) { self.date = date }; public func now() -> Date { date } }

public enum TemporaryDirectory {
    public static func make(fileManager: FileManager = .default) throws -> URL { let url = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true); try fileManager.createDirectory(at: url, withIntermediateDirectories: true); return url }
}
