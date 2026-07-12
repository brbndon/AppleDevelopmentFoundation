# Local skills

These source-controlled skills are intentionally general Apple-development workflows. They are discoverable from this repository according to the installed Codex local-skill conventions; optionally symlink them to the user scope with `./Scripts/install-skills.sh`.

| Skill | Use for | Do not use for |
| --- | --- | --- |
| apple-platform-planner | planning a platform feature | implementation-only requests |
| swiftui-component-author | reusable SwiftUI components | app-specific screen copy |
| apple-design-system | design-system changes | application branding |
| ios-macos-platform-adaptation | divergent platform behavior | shared identical behavior |
| swift-package-module-author | a reusable package target in the active workspace | an app-local feature or archived package work here |
| reusable-code-extractor | generalizing proven app code into consumer shared modules | speculative extraction or landing code in this repo's archived package |
| swift-concurrency-review | async/await and actor review | unrelated styling |
| apple-accessibility-review | reusable UI accessibility | a non-UI service |
| apple-security-privacy-review | files, logging, permissions, sensitive data | visual-only polish |
| swift-testing-verification | meaningful change verification | planning-only requests |
| codex-skill-maintainer | skill changes | product code changes |
| codex-bootstrap | bootstrapping new iOS/macOS projects in the consumer workspace using these skills | one-off screens, editing archived package code in this repo |