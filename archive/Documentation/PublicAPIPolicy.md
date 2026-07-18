# Public API Policy

> **Archived.** Historical public API policy reference only. See the [archive README](../README.md). Do not expand this package unless explicitly asked.

Library declarations are internal by default. A declaration becomes public only when two plausible application integrations need to name it directly, it cannot remain inside a public initializer or closure, and its behavior can be tested and documented without application terminology.

Every retained public declaration needs a DocC-compatible comment, stable additive semantics, an iOS 17/macOS 14 constraint unless a narrower availability is documented, and focused behavioral tests where it has observable logic. Public stored properties are reserved for immutable configuration or state clients genuinely need to inspect; mutable state remains actor- or main-actor-owned. Do not expose speculative protocols, type erasure, test helpers, implementation storage, or extensions merely to support examples.

When a newly introduced API is obviously unsafe or violates a documented module boundary, correct it even when the source-compatible surface must change. Otherwise preserve source compatibility: add an overload or new type, deprecate the old API with migration guidance, and remove only in the next major version. `AppFoundation` deliberately exposes no SwiftUI environment key, `FoundationLogger` accepts literal event names, and `AtomicFileWriter` requires explicit overwrite as examples of this policy.
