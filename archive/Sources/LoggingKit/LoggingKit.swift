import OSLog

/// A narrow, privacy-first diagnostics boundary for developer-authored literal event names.
public struct FoundationLogger: Sendable {
    private let logger: Logger

    /// Creates a logger for an application-controlled subsystem and category.
    ///
    /// Do not derive either value from user content, URLs, filenames, or credentials.
    public init(subsystem: String, category: String) {
        logger = Logger(subsystem: subsystem, category: category)
    }

    /// Logs a compile-time diagnostic event name at debug level.
    ///
    /// `StaticString` intentionally prevents interpolating arbitrary runtime values into this API.
    public func debug(event: StaticString) {
        logger.debug("event=\(String(describing: event), privacy: .public)")
    }

    /// Logs a compile-time error category without exposing an underlying error description.
    ///
    /// `StaticString` intentionally prevents interpolating arbitrary runtime values into this API.
    public func error(event: StaticString) {
        logger.error("event=\(String(describing: event), privacy: .public)")
    }
}
