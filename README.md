# Apple Development Foundation

A local Swift Package of small, independently selectable foundations for iOS 17+ and macOS 14+. It has no third-party dependencies and is currently verified with Xcode 26.2 / Swift 6.2.3.

## Modules

| Module | Implemented responsibility | Direct package dependencies |
| --- | --- | --- |
| AppFoundation | deterministic clocks/identifiers, environment flags, non-sensitive generic errors | — |
| DesignSystem | semantic SwiftUI tokens and neutral accessible components | — |
| FormKit | string validation, locale-aware decimal parsing/input, dirty and form validation state | DesignSystem |
| OnboardingKit | guided-flow inclusion, validation, progression, cancellation, restoration | DesignSystem |
| NavigationKit | typed value paths, one sheet state, Codable path restoration | — |
| PersistenceKit | SwiftData container creation and store-file reset | — |
| FileKit | regular-file validation, sanitization, safe locations, atomic writes, scoped access | — |
| MediaKit | validated image-data loading and actor-isolated cache | FileKit |
| FeedbackKit | main-actor message state and accessible banner | DesignSystem |
| LoggingKit | compile-time-literal OSLog event boundary | — |
| AppShellKit | adaptive split shell and settings trigger | DesignSystem |

```text
DesignSystem ← { FormKit, OnboardingKit, FeedbackKit, AppShellKit }
FileKit ← MediaKit
```

The graph above is generated from and must agree with `Package.swift`; `AppFoundation` is intentionally standalone rather than a convenience dependency of every module.

## Integrate only what you use

In Xcode, add this folder as a local package, then add only the required products to an app target. A Package.swift consumer may use `.package(path: "../AppleDevelopmentFoundation")` and depend on `.product(name: "FormKit", package: "AppleDevelopmentFoundation")`.

```swift
import FormKit

ValidatedTextField(
    "Display name",
    text: $name,
    validation: .init([.required(), .maximumLength(80)])
)
```

## Workflows

```bash
./Scripts/bootstrap.sh                 # inspect only
./Scripts/bootstrap.sh --install-skills # opt-in symlink installation
./Scripts/build.sh
./Scripts/test.sh
./Scripts/verify.sh
./Scripts/install-skills.sh --dry-run
./Scripts/install-skills.sh --uninstall
```

`FoundationGallery`, `iOSExample`, and `macOSExample` are implemented SwiftPM executable examples. The package tests and macOS/iOS-simulator compilation verify their compilation, but they do not verify a signed Xcode host app. See [Verification Limitations](Documentation/VerificationLimitations.md).

## Status and roadmap

Implemented behavior is covered by focused unit tests where it has platform-independent state or I/O semantics. SwiftUI accessibility semantics and platform interaction are manually reviewed; no automatic host-app UI testing has been claimed.

Deliberate non-goals include image resizing, compression, conversion, metadata stripping, document parsing, app-specific error mapping, popover routing, and file import/export formats. The next roadmap item is a minimal iOS and macOS Xcode host-app verification harness, not a new library module.

See [Architecture](Documentation/Architecture.md), [module API guide](Documentation/Modules.md), [integration](Documentation/IntegrationGuide.md), [testing](Documentation/TestingGuide.md), [public API policy](Documentation/PublicAPIPolicy.md), [versioning](Documentation/Versioning.md), and [local skills](.agents/skills/README.md).
