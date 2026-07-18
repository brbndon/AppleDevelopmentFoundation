import Foundation

/// Errors whose presentation can remain generic across applications.
public enum AppFoundationError: LocalizedError, Equatable, Sendable {
    /// Indicates that a requested capability is unavailable.
    case unavailable(String)

    /// Indicates that application configuration is invalid.
    case invalidConfiguration(String)

    /// A non-sensitive error message suitable for user presentation.
    public var errorDescription: String? {
        switch self {
        case .unavailable: "This capability is unavailable."
        case .invalidConfiguration: "The configuration is invalid."
        }
    }
}

/// A deterministic boundary for code that needs the current date.
public protocol AppClock: Sendable {
    /// Returns the current date according to this clock.
    func now() -> Date
}

/// A clock backed by the system date. Use a fixed clock for deterministic tests.
public struct SystemAppClock: AppClock {
    /// Creates a system-backed clock.
    public init() {}

    /// Returns the current system date.
    public func now() -> Date { Date() }
}

/// A clock that always returns one date for deterministic previews and tests.
public struct FixedAppClock: AppClock {
    /// The date returned by ``now()``.
    public let date: Date

    /// Creates a clock that always returns `date`.
    public init(_ date: Date) { self.date = date }

    /// Returns the configured date.
    public func now() -> Date { date }
}

/// A deterministic boundary for generated identifiers.
public protocol IdentifierProviding: Sendable {
    /// Creates an identifier.
    func makeID() -> UUID
}

/// An identifier provider backed by newly generated UUIDs.
public struct UUIDIdentifierProvider: IdentifierProviding {
    /// Creates a UUID-backed provider.
    public init() {}

    /// Creates a new UUID.
    public func makeID() -> UUID { UUID() }
}

/// An identifier provider that always returns one configured UUID.
public struct FixedIdentifierProvider: IdentifierProviding {
    /// The identifier returned by ``makeID()``.
    public let id: UUID

    /// Creates a provider that always returns `id`.
    public init(_ id: UUID) { self.id = id }

    /// Returns the configured identifier.
    public func makeID() -> UUID { id }
}

/// Stable environment data injected by an application shell.
public struct AppEnvironment: Sendable, Equatable {
    /// Whether the application is running in a SwiftUI preview.
    public let isPreview: Bool

    /// Whether the application is running under XCTest.
    public let isRunningTests: Bool

    /// Creates environment flags from the process environment.
    public init(processInfo: ProcessInfo = .processInfo) {
        self.init(environment: processInfo.environment)
    }

    /// Creates environment flags from explicit values, primarily for deterministic tests and previews.
    public init(environment: [String: String]) {
        isPreview = environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        isRunningTests = environment["XCTestConfigurationFilePath"] != nil
    }
}
