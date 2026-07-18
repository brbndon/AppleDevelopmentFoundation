# Archive boundary

The repository's former Swift package, examples, apps, website, historical package documentation, and package tooling are contained in [`archive/`](archive/). They are preserved for history and reference only.

## What is archived

| Path | Status |
| --- | --- |
| `archive/Sources/`, `archive/Tests/`, `archive/Package.swift` | Exploratory Swift package — not consumed or maintained as a product |
| `archive/Documentation/` | Historical architecture and module-boundary reference |
| `archive/Apps/`, `archive/Examples/`, `archive/Website/` | Exploratory demos and superseded marketing site |
| `archive/Scripts/` | Package, demo-site, and environment tooling — use only for explicitly requested archive work |

## What is live

| Path | Purpose |
| --- | --- |
| `.agents/skills/` | Reusable Codex skills (the product) |
| `MCP.md` | XcodeBuildMCP and command reference |
| `docs/`, `blume.config.ts` | Agent playbook (Blume docs site) |
| `docs/skills/skill-authoring-guide.mdx`, `docs/skills/skill-evaluation.mdx` | Live skill-maintenance guidance and evaluation inputs |
| `Scripts/` | Live skill catalog, install, consumer-guidance, and verification tooling |
| `Templates/` | Skill and consumer templates |
| `README.md`, `AGENTS.md` | Entry points for humans and agents |

## Agent guidance

Do **not** add modules, expand public APIs, refactor package code, or "improve" archived targets unless the user explicitly asks. Skills in this repo apply to **consumer apps and packages in the user's active workspace**, not to landing code in `archive/`. See [`archive/README.md`](archive/README.md) for the preserved layout.

## History note

Commit `2c9f948` repurpose also included unrelated LoggingKit/AppShellKit test additions. Those diffs were left in place; they are not part of the skills/MCP product story.
