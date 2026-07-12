# Module Boundaries

> **Archived.** Historical dependency graph reference only. See [ARCHIVE.md](../ARCHIVE.md). Do not expand this package unless explicitly asked.

`Package.swift` is the definitive dependency graph. The current non-empty edges are:

```text
DesignSystem ← { FormKit, OnboardingKit, FeedbackKit, AppShellKit }
FileKit ← MediaKit
```

`AppFoundation`, `NavigationKit`, `PersistenceKit`, `FileKit`, and `LoggingKit` have no package-target dependencies. A module must not import a higher-level product; test-only `TestingSupport` is not a library product; examples must not contain reusable implementation.

Do not add `AppFoundation` as a convenience dependency. It is reserved for genuinely cross-cutting deterministic boundaries and must remain free of SwiftUI. Keep platform UI in UI modules, persistence schemas and application routing destinations in host apps, and no app-shell behavior in lower-level services.

Add a type to an existing module only when its responsibility matches the module table in the README and it preserves this direction. Create a module only for a separately importable concern with a non-empty implementation, focused test target, documented public API, generic example use, and an updated graph. Do not create `Core`, `Utilities`, or a re-export-only module.
