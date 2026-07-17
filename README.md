# Codex Skills Reference

Reusable Codex skills for Apple development (design system, SwiftUI, concurrency, security, etc.).

This repo's primary purpose is **skills + command references**. The original Swift package was exploratory and is archived — see [ARCHIVE.md](ARCHIVE.md).

## Install skills

```bash
./Scripts/install-skills.sh
./Scripts/verify-skills.sh
```

## MCP & commands

See [MCP.md](MCP.md) for XcodeBuildMCP setup, tool names, copy-paste prompts, and bootstrap verification.

Point Codex at this repo when bootstrapping apps:

> Use the skills from `/path/to/AppleDevelopmentFoundation/.agents/skills` (start with `codex-bootstrap`).

## Skill inventory

| Skill | One-liner |
| --- | --- |
| `codex-bootstrap` | Bootstrap a new iOS/macOS SwiftUI project using these skills |
| `apple-platform-planner` | Plan a platform feature before implementation |
| `swiftui-tab-navigation` | Build native app-level tabs with system Liquid Glass behavior |
| `swiftui-component-author` | Author reusable SwiftUI components |
| `apple-design-system` | Add or change reusable design-system tokens and components |
| `ios-macos-platform-adaptation` | Adapt behavior between iOS and macOS |
| `swift-package-module-author` | Add an independently importable Swift Package module |
| `reusable-code-extractor` | Extract proven app code into a shared module |
| `swift-concurrency-review` | Review async/await, actors, and structured concurrency |
| `apple-accessibility-review` | Review reusable UI accessibility |
| `apple-security-privacy-review` | Review files, logging, permissions, and sensitive data |
| `swift-testing-verification` | Verify meaningful changes with focused tests |
| `codex-skill-maintainer` | Maintain and update skills in this repo |

Full use/do-not-use table: [.agents/skills/README.md](.agents/skills/README.md). Manifest: [.agents/skills/manifest.json](.agents/skills/manifest.json).
