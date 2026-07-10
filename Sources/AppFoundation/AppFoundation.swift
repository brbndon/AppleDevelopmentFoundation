import Foundation
import SwiftUI

/// Errors whose presentation can remain generic across applications.
public enum AppFoundationError: LocalizedError, Equatable, Sendable {
    case unavailable(String)
    case invalidConfiguration(String)

    public var errorDescription: String? {
        switch self {
        case .unavailable(let detail): "This capability is unavailable. \(detail)"
        case .invalidConfiguration(let detail): "The configuration is invalid. \(detail)"
        }
    }
}

/// A deterministic boundary for code that needs the current date.
public protocol AppClock: Sendable { func now() -> Date }

public struct SystemAppClock: AppClock {
    public init() {}
    public func now() -> Date { Date() }
}

/// A deterministic boundary for generated identifiers.
public protocol IdentifierProviding: Sendable { func makeID() -> UUID }

public struct UUIDIdentifierProvider: IdentifierProviding {
    public init() {}
    public func makeID() -> UUID { UUID() }
}

/// Stable environment data injected by an application shell.
public struct AppEnvironment: Sendable, Equatable {
    public let isPreview: Bool
    public let isRunningTests: Bool

    public init(processInfo: ProcessInfo = .processInfo) {
        isPreview = processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        isRunningTests = processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}

extension EnvironmentValues {
    /// An application-specific environment value; defaults are safe for previews and tests.
    @Entry public var appEnvironment = AppEnvironment()
}
