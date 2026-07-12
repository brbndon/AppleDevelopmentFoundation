# Local skills

These source-controlled skills are intentionally general Apple-development workflows. They are discoverable from this repository according to the installed Codex local-skill conventions; optionally symlink them to the user scope with `./Scripts/install-skills.sh`.

| Skill | Use for | Do not use for |
| --- | --- | --- |
| apple-development-foundation | reference-first child-skill routing and explicitly requested foundation audits | replacing child instructions, implied audits/verification, or claiming automatic activation |
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
| maestro-apple-app-testing | thorough Maestro testing for Apple apps | non-testing product implementation |
| codex-skill-maintainer | skill changes | product code changes |
| codex-bootstrap | bootstrapping new iOS/macOS projects in the consumer workspace using these skills | one-off screens, editing archived package code in this repo |

The master catalog and resolvable parent-skill paths are defined in [`apple-development-foundation/master-skill.json`](apple-development-foundation/master-skill.json). It first shortlists skills from the catalog, then reads only selected child instructions; invoke it explicitly as `$apple-development-foundation`.

## External skill routing

Use the globally installed [`app-store-screenshots`](https://github.com/ParthJadhav/app-store-screenshots) skill (`$app-store-screenshots`) when a consumer app task involves App Store assets: marketing screenshots, device mockups, export dimensions, screenshot sets, or a screenshot editor. This repository only documents the routing; the upstream skill remains externally installed and is not copied into `.agents/skills/` or listed in `manifest.json`.
