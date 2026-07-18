import Observation

/// Observable state owned by or injected into a `DownloadButton`.
@Observable
public final class DownloadController {
    /// The current visible phase.
    public var phase: DownloadPhase

    /// Creates a controller with the supplied initial phase.
    public init(phase: DownloadPhase = .idle) {
        self.phase = phase
    }
}
