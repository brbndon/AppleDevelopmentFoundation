# Architecture

The package is a portfolio of small libraries, not an application framework. `AppFoundation` is the only bottom-level target. Service foundations (`PersistenceKit`, `FileKit`, `MediaKit`, `LoggingKit`) do not depend on UI. `DesignSystem` is the shared SwiftUI layer; feature-shaped reusable tools may depend on it. Applications compose products at their shell and own all domain models, persistence schema, branding, networking, and entitlements.

Use initializer injection for concrete collaborators. Use protocols only at an external or deterministic boundary (clock, identifier, filesystem/service seam). Put UI state on the main actor and keep background work cancellation-aware. A new module is warranted when a unit has independent consumers, a clear public API, and would otherwise reverse dependency direction.
