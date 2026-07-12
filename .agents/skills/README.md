# Local skills

These source-controlled skills are intentionally general Apple-development workflows. They are discoverable from this repository according to the installed Codex local-skill conventions; optionally symlink them to the user scope with `./Scripts/install-skills.sh`.

| Skill | Use for | Do not use for |
| --- | --- | --- |
| apple-platform-planner | planning a platform feature | implementation-only requests |
| swiftui-component-author | reusable SwiftUI components | app-specific screen copy |
| apple-design-system | design-system changes | application branding |
| ios-macos-platform-adaptation | divergent platform behavior | shared identical behavior |
| swift-package-module-author | a reusable package target | an app-local feature |
| reusable-code-extractor | generalizing proven app code | speculative extraction |
| swift-concurrency-review | async/await and actor review | unrelated styling |
| apple-accessibility-review | reusable UI accessibility | a non-UI service |
| apple-security-privacy-review | files, logging, permissions, sensitive data | visual-only polish |
| swift-testing-verification | meaningful change verification | planning-only requests |
| codex-skill-maintainer | skill changes | product code changes |
| codex-bootstrap | bootstrapping new iOS/macOS projects using these skills | rebuilding the old full package |