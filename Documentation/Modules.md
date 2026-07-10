# Module API Guide

| Module | Use it for | Non-goal | Public entry points | Platform/testing/extension notes |
| --- | --- | --- | --- | --- |
| AppFoundation | deterministic time/IDs, app environment, generic errors | a global service locator | `AppClock`, `IdentifierProviding`, `AppEnvironment` | iOS/macOS; inject fakes in tests; add only genuine cross-project boundaries. |
| DesignSystem | neutral semantic UI primitives | branding or app screens | `FoundationTokens`, cards, buttons, states | iOS/macOS; test accessibility settings and gallery; add semantic components only. |
| FormKit | validation and owned form state | domain models or every app form | `ValidationRule`, `ValidatedTextField`, `FormState` | iOS/macOS; test rules/state deterministically; inject app bindings. |
| OnboardingKit | guided-flow progression | app onboarding content/storage | `FlowStep`, `FlowProgression`, `FlowContainer` | iOS/macOS; test branching/validation; app owns views and restoration. |
| NavigationKit | native path/sheet state | a custom navigation framework | `NavigationRouter` | iOS/macOS; test routing values; app owns destination types. |
| PersistenceKit | SwiftData setup/reset foundation | domain schemas or repositories by default | `PersistenceContainerFactory`, `PersistenceReset` | iOS/macOS; use in-memory schemas in tests; apps own migration/backup decisions. |
| FileKit | validated local import/export foundations | document-specific parsing | `FileImportPolicy`, `SafeFilename`, `AtomicFileWriter` | iOS/macOS; test temp files; apps own panels and entitlements. |
| MediaKit | explicit validated image data loading/cache | silent transforms or media editing | `ImageLoadPolicy`, `ImageLoader`, `ImageDataCache` | iOS/macOS; test cancellation/policy; add transformations only with explicit options. |
| FeedbackKit | generic message state/banner | app error taxonomy | `FeedbackCenter`, `FeedbackBanner` | iOS/macOS; test mapping app errors separately; compose placement at shell. |
| LoggingKit | privacy-first event categories | error presentation or raw value logging | `FoundationLogger` | iOS/macOS; test adapters if added; never widen to arbitrary sensitive values. |
| AppShellKit | native generic shell structure | app navigation/domain decisions | `AdaptiveAppShell`, `FoundationSettingsLink` | iOS/macOS; verify native navigation; app provides sidebar/detail/content. |
