# Codex Skills Reference

Reusable Codex skills for Apple development (design system, SwiftUI, concurrency, security, etc.).

This repo's primary purpose is **skills + command references**. The original Swift package and demos are contained under [`archive/`](archive/) — see [ARCHIVE.md](ARCHIVE.md).

## Agent playbook (Blume docs)

Agent-facing workflow docs live under [`docs/`](docs/) and are served with [Blume](https://useblume.dev).

**Production:** [https://brbndon.github.io/AppleDevelopmentFoundation/](https://brbndon.github.io/AppleDevelopmentFoundation/) (GitHub Pages via `.github/workflows/docs.yml`).

```bash
npm install
npm run dev      # local docs site
npm run build    # static build + llms.txt artifacts
npm run validate # link check
npm run preview  # serve production build locally
```

Requires **Node.js 22.12+**. One-time GitHub setup: **Settings → Pages → Source: GitHub Actions**.

Start with the [quickstart](docs/quickstart.mdx) and [session workflow](docs/workflow/index.mdx). The site covers skill routing, consumer-workspace rules, XcodeBuildMCP, Maestro, scripts, and copy-paste prompts for agentic coders.

## Agent host support

Codex is the supported and verified host. The installer targets
`${CODEX_HOME:-$HOME/.codex}/skills`, and invocation examples use `$skill-name`.
Other skill- and MCP-capable hosts have documentation-only/manual compatibility;
the repository does not currently ship verified Cursor or Claude Code adapters.
See [Agent host support](docs/reference/host-support.mdx).

## Repository map

| Path | Purpose |
| --- | --- |
| `.agents/skills/` | Live reusable skills |
| `Scripts/` | Live catalog, installer, consumer-guidance, and verification tools |
| `docs/`, `MCP.md` | Live agent playbook and command reference |
| `Templates/` | Skill and consumer-project templates |
| `archive/` | Preserved exploratory package, demos, old website, historical documentation, and package tooling |

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
| `apple-development-foundation` | Reference-first child-skill router with optional foundation audits |
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
| `maestro-apple-app-testing` | Test Apple apps end to end with Maestro |
| `codex-skill-maintainer` | Maintain and update skills in this repo |

Full use/do-not-use table: [.agents/skills/README.md](.agents/skills/README.md). Manifest: [.agents/skills/manifest.json](.agents/skills/manifest.json).

For a single reusable baseline in a new chat, invoke `$apple-development-foundation`; it uses its [machine-readable catalog](.agents/skills/apple-development-foundation/master-skill.json) to shortlist child skills before reading their instructions. Audits and foundation verification are explicit requests.

## External skill routing

For App Store asset work, use the globally installed [`app-store-screenshots`](https://github.com/ParthJadhav/app-store-screenshots) skill (`$app-store-screenshots`). It is the focused workflow for App Store marketing screenshots, device mockups, exportable screenshot sets, and screenshot-editor scaffolding. It is intentionally referenced here rather than copied into this repository or added to the local manifest.
