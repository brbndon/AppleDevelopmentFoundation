# Archived package surface

The Swift package, examples, apps, and website in this repository are **archived exploratory work**. They are preserved for history and reference only.

## What is archived

| Path | Status |
| --- | --- |
| `Sources/`, `Tests/`, `Package.swift` | Exploratory Swift package — not consumed or maintained as a product |
| `Documentation/` (except skill guides) | Historical architecture and module-boundary reference |
| `Apps/`, `Examples/`, `Website/` | Exploratory demos and marketing — not the repo's primary purpose |
| `Scripts/create-module.sh`, `Scripts/verify.sh` | Package tooling — use only when explicitly working on archived package code |

## What is live

| Path | Purpose |
| --- | --- |
| `.agents/skills/` | Reusable Codex skills (the product) |
| `MCP.md` | XcodeBuildMCP and command reference |
| `docs/`, `blume.config.ts` | Agent playbook (Blume docs site) |
| `README.md`, `AGENTS.md` | Entry points for humans and agents |

## Agent guidance

Do **not** add modules, expand public APIs, refactor package code, or "improve" archived targets unless the user explicitly asks. Skills in this repo apply to **consumer apps and packages in the user's active workspace**, not to landing code here.

## History note

Commit `2c9f948` repurpose also included unrelated LoggingKit/AppShellKit test additions. Those diffs were left in place; they are not part of the skills/MCP product story.
