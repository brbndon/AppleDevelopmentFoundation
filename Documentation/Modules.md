# Module API Guide

> **Archived.** Historical module API reference only. See [ARCHIVE.md](../ARCHIVE.md). Do not expand this package unless explicitly asked.

| Module | Use it for | Non-goal | Public entry points | Platform/testing/extension notes |
| --- | --- | --- | --- | --- |
| AppFoundation | deterministic time/IDs, app environment flags, generic errors | a global service locator or SwiftUI environment key | `AppClock`, `FixedAppClock`, `IdentifierProviding`, `FixedIdentifierProvider`, `AppEnvironment` | iOS/macOS; inject deterministic values in tests; add only genuine cross-project boundaries. |
| DesignSystem | neutral semantic UI primitives | branding or app screens | `FoundationTokens`, cards, buttons, states | iOS/macOS; test accessibility settings and gallery; add semantic components only. |
| FormKit | validation, decimal parsing/input, owned form state | domain models, focus ownership, or currency formatting | `ValidationRule`, `FieldValidation`, `DecimalParser`, `ValidatedTextField`, `FormState` | iOS/macOS; test rules/state deterministically; inject app bindings. |
| OnboardingKit | guided-flow progression | app onboarding content/storage | `FlowStep`, `FlowProgression`, `FlowContainer` | iOS/macOS; test inclusion, validation, cancellation, and restoration; app owns views and persistence. |
| NavigationKit | typed path, one sheet state, Codable path restoration | a custom navigation framework, URL parsing, or popovers | `NavigationRouter` | iOS/macOS; test routing values; app owns destination types and deep-link parsing. |
| PersistenceKit | SwiftData setup/reset foundation | domain schemas or repositories by default | `PersistenceContainerFactory`, `PersistenceReset` | iOS/macOS; apps may supply explicit `ModelConfiguration` values and own migration/backup decisions. |
| FileKit | validated local file foundations | document-specific parsing or panel presentation | `FileImportPolicy`, `SafeFilename`, `AtomicFileWriter` | iOS/macOS; validation requires a regular local file; atomic writes refuse replacement by default; apps own panels and entitlements. |
| MediaKit | validated image data loading/cache | silent transforms, compression, metadata stripping, or media editing | `ImageLoadPolicy`, `ImageLoader`, `ImageDataCache` | iOS/macOS; cache is bounded by encoded bytes with LRU eviction and best-effort source freshness indicators. |
| FeedbackKit | generic message state/banner | app error taxonomy | `FeedbackCenter`, `FeedbackBanner` | iOS/macOS; test mapping app errors separately; compose placement at shell. |
| LoggingKit | privacy-first literal event categories | error presentation or runtime-value logging | `FoundationLogger` | iOS/macOS; its event APIs accept `StaticString`; never widen to arbitrary sensitive values. |
| AppShellKit | native generic shell structure | app navigation/domain decisions | `AdaptiveAppShell`, `FoundationSettingsLink` | iOS/macOS; verify native navigation; app provides sidebar/detail/content. |
