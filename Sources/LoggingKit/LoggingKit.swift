import AppFoundation
import OSLog

/// A narrow, privacy-first diagnostics boundary. Pass only developer-authored event names and counts.
public struct FoundationLogger: Sendable {
    private let logger: Logger
    public init(subsystem: String, category: String) { logger = Logger(subsystem: subsystem, category: category) }
    /// Logs a fixed diagnostic event. Do not interpolate user content, credentials, URLs, or file paths.
    public func debug(event: String) { logger.debug("event=\(event, privacy: .public)") }
    /// Logs a fixed error category without exposing the underlying error's potentially sensitive details.
    public func error(event: String) { logger.error("event=\(event, privacy: .public)") }
}
