# Apple Development Foundation

This repository is a private, local source of small reusable Swift Package modules for iOS 17+ and macOS 14+. Before architectural changes, read `Package.swift`, `Documentation/ModuleBoundaries.md`, `Documentation/Architecture.md`, and the affected module source.

Use Swift 6, SwiftUI, SwiftData where appropriate, native observation, initializer or environment injection, structured concurrency, and focused views. Keep shared behavior shared; put Apple-convention differences in platform-specific files or extensions. Do not add a view model without a state-ownership or testability reason.

`AppFoundation` has no package dependencies. Foundation/service modules may depend only on it. UI modules may depend on it and DesignSystem. Higher-level modules never become dependencies of lower-level modules; circular dependencies are forbidden. Internal is the default access level. Every public API needs a DocC-compatible comment, stable additive design, relevant tests, and a documented platform constraint when applicable.

Reusable code must have at least two plausible applications, neutral terminology, no business model, no secrets, no user-specific paths, and no hidden network behavior. Prefer Apple APIs; do not add a third-party production dependency without explicit authorization and a documented removal path.

All SwiftUI components must support Dynamic Type, VoiceOver, keyboard access, contrast, Reduce Motion, Differentiate Without Color, and a descriptive label for an icon-only control. Validate imports before reading them. Never log credentials, tokens, private content, raw imports, complete sensitive paths, or security-scoped URLs.

Run the smallest relevant tests, then `./Scripts/verify.sh` for module-boundary or public API changes. Report commands not available locally. Avoid broad unrelated refactors during focused work; preserve public compatibility unless a breaking change is explicitly authorized.

Add a component in its narrowest module with a preview/example and test. Add a module with `./Scripts/create-module.sh Name`, then update Package.swift, boundaries, graph, README, tests, and skills manifest only if a skill relates. Update a skill through `.agents/skills`, then run `./Scripts/verify-skills.sh`. See `Documentation/SkillAuthoringGuide.md` before changing skill behavior.
