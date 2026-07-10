# Apple Development Foundation

A fully local Swift Package source of reusable, independent iOS and macOS foundations. It targets iOS 17+ and macOS 14+, requires Xcode 16+ / Swift 6 (validated with Xcode 26.2 / Swift 6.2), and has no third-party dependencies.

## Modules

| Module | Responsibility | Dependencies |
| --- | --- | --- |
| AppFoundation | deterministic boundaries, app environment, shared errors | — |
| DesignSystem | semantic SwiftUI tokens and accessible neutral components | AppFoundation |
| FormKit | validation, validated fields, decimal input, dirty state | AppFoundation, DesignSystem |
| OnboardingKit | testable generic guided-flow progression and container | AppFoundation, DesignSystem |
| NavigationKit | native value path and sheet routing state | AppFoundation |
| PersistenceKit | SwiftData container and reset foundation | AppFoundation |
| FileKit | filename, import validation, locations, atomic writing, scoped access | AppFoundation |
| MediaKit | explicit image-load validation and actor cache | AppFoundation, FileKit |
| FeedbackKit | observable feedback center and accessible banner | AppFoundation, DesignSystem |
| LoggingKit | narrow privacy-first OSLog boundary | AppFoundation |
| AppShellKit | adaptive shell and settings trigger | AppFoundation, DesignSystem, NavigationKit |

```text
AppFoundation ← { DesignSystem, NavigationKit, PersistenceKit, FileKit, LoggingKit }
DesignSystem ← { FormKit, OnboardingKit, FeedbackKit, AppShellKit }
FileKit ← MediaKit
NavigationKit ← AppShellKit
```

## Integrate only what you use

In Xcode, add this folder as a local package, then add a product to the app target. From another Git repository, add its URL and select individual products. A Package.swift consumer may use `.package(path: "../AppleDevelopmentFoundation")` and depend on `.product(name: "FormKit", package: "AppleDevelopmentFoundation")`.

```swift
import FormKit

ValidatedTextField("Display name", text: $name,
                   validation: .init([.required(), .maximumLength(80)]))
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

Open `Package.swift` in Xcode; the `FoundationGallery`, `iOSExample`, and `macOSExample` executable schemes demonstrate reusable UI. `FoundationGallery` is the component gallery.

## Current limitations and roadmap

This release deliberately provides image loading rather than automatic transforms: resizing, compression, conversion, and metadata stripping must be explicit. Examples are Swift Package executable schemes, not signed distributable projects. Next priorities: (1) image transformation/PhotosPicker and document panels, (2) richer form focus and discard presentation, (3) SwiftData migration/backup examples, (4) optional native Xcode app templates, (5) accessibility UI-test harnesses.

See [Architecture](Documentation/Architecture.md), [module API guide](Documentation/Modules.md), [Integration](Documentation/IntegrationGuide.md), [Testing](Documentation/TestingGuide.md), and [skills](.agents/skills/README.md).
