# AppleDevelopmentFoundation

A Codex skill foundation for Apple development. It gives coding agents reusable skills for building iOS 17+ and macOS 14+ apps with SwiftUI, plus guidance for XcodeBuildMCP.

> Status: I maintain this solo and use it in my own app work. It is ready to install and use.

## Why I made this

I gathered these patterns over the past few months while building local-first iOS and macOS apps. I kept solving the same problems (navigation shells, error states, verification loops), so I wrote them down as skills my agent could reuse. I published the repo so anyone running Codex can use the same foundation, including people opening an agent harness for the first time.

## Start in five minutes

```bash
git clone https://github.com/brbndon/AppleDevelopmentFoundation.git
cd AppleDevelopmentFoundation
./Scripts/install-skills.sh
```

That symlinks 17 skills into `${CODEX_HOME:-$HOME/.codex}/skills`. Then open Codex and invoke `$apple-development-foundation`. Ask it to bootstrap a new app, add error states, or improve tab navigation, and it shortlists the right skills from there. `docs/quickstart.mdx` walks through the full path including XcodeBuildMCP setup.

## What it covers

- starting out: `apple-development-foundation` (routes every request), `codex-bootstrap` (new app from scratch)
- app UI: `swiftui-tab-navigation`, `swiftui-component-author`, `apple-design-system`, `apple-error-states`, `apple-app-marketing-site`, `ios-macos-platform-adaptation`
- code structure: `apple-platform-planner`, `swift-package-module-author`, `reusable-code-extractor`
- reviews before shipping: `swift-concurrency-review`, `apple-accessibility-review`, `apple-security-privacy-review`, `swift-testing-verification`, `maestro-apple-app-testing`
- repo upkeep: `codex-skill-maintainer`

## How it is laid out

- `.agents/skills/` holds the skills. `manifest.json` there is the source of truth for what gets installed.
- `Scripts/` holds the installer plus the checks I run after skill changes (`verify-skills.sh`, `test-install-skills.sh`).
- `docs/` holds the playbook site I use day to day: https://brbndon.github.io/AppleDevelopmentFoundation/
- `Templates/` holds drop-in starters (a loading mark, a marketing-site recipe).
- `archive/` holds an old Swift package. I keep it frozen and do not expand it.

## Requirements

- Codex, the only verified host. Other agent harnesses may work by hand, but I do not verify them.
- Xcode with XcodeBuildMCP for builds and tests (see `MCP.md`). Maestro only matters for UI flows. Node 22.12+ only matters for the docs site.
- For App Store screenshot sets, I use the external `$app-store-screenshots` skill (see `docs/reference/external-skills.mdx`). It is not installed by this repo.

## Limits

I review changes alone, so turnaround follows my own app schedule. Skills target the app you are building, not this repo. The archived package stays as is unless I say otherwise. Issues and pull requests are welcome (see `CONTRIBUTING.md`), but this is a foundation I publish, not a document anyone needs permission to use.

MIT License, Copyright (c) 2026 brbndon. See `LICENSE`.
