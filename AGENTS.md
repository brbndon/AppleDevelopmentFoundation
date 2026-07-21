# Apple Development Foundation

This repository is a **Codex-first skills and MCP/commands reference** for Apple development (iOS 17+, macOS 14+). Codex is the supported and verified agent host: skills use `.agents/skills/`, the installer targets `${CODEX_HOME:-$HOME/.codex}/skills`, and examples use `$skill-name`. Other skill- and MCP-capable hosts have documentation-only/manual compatibility unless this repository adds and verifies a host adapter. See `docs/reference/host-support.mdx`.

The exploratory Swift package and demos are isolated under `archive/` — do not expand them unless explicitly asked.

Agent-facing playbook (install, routing, MCP, verification): Blume site under `docs/` (`npm run dev`). Keep always-on rules here; put longer onboarding in `docs/`.

## Primary work

- Maintain, install, and verify skills: `./Scripts/install-skills.sh`, `./Scripts/verify-skills.sh`, `./Scripts/test-install-skills.sh`
- Keep skills neutral and reusable: no business models, branding, secrets, user-specific paths, or hidden network behavior
- Follow the Apple verification capability ladder in `MCP.md`: XcodeBuildMCP MCP tools first; XcodeBuildMCP CLI only when the active project/user policy explicitly permits it; repository-native raw Xcode tooling only when that policy authorizes it; otherwise report blocked. Never infer fallback permission from tool availability.
- For Maestro app testing, use `$maestro-apple-app-testing` as the main workflow; combine XcodeBuildMCP for Apple builds/simulators with Maestro MCP and CLI flows for UI inspection and regression coverage.
- Use `$apple-development-foundation` for new-chat routing and new iOS/macOS app bootstrap (it shortlists `$codex-bootstrap`); use `$codex-bootstrap` directly when already selected
- Update skills through `.agents/skills/`; see `docs/skills/skill-authoring-guide.mdx` before changing skill behavior

## Skill routing

For new-chat Apple-platform skill selection and explicitly requested foundation
audits, use [`apple-development-foundation`](.agents/skills/apple-development-foundation/SKILL.md).
It reads [`master-skill.json`](.agents/skills/apple-development-foundation/master-skill.json)
to shortlist relevant child skills before reading their instructions. Explicit
invocation is required; ordinary routing does not imply an audit, repository
scan, installer action, or verification run. The catalog defines the detailed
inventory, audit classifications, and foundation-only verification workflow.

## Skills apply to consumer apps

Skills target the **active workspace** (the app or package the user is building), not this repository's archived modules. Do not add code to `archive/Sources/`, create modules with `./archive/Scripts/create-module.sh`, or treat `DesignSystem` / `FileKit` here as live products unless the user explicitly asks to work on archived package code.

## Apple development defaults (when writing Swift in any workspace)

Use Swift 6, SwiftUI, SwiftData where appropriate, native observation, initializer or environment injection, structured concurrency, and focused views. Do not add a view model without a state-ownership or testability reason.

All SwiftUI components must support Dynamic Type, VoiceOver, keyboard access, contrast, Reduce Motion, Differentiate Without Color, and a descriptive label for an icon-only control. Validate imports before reading them. Never log credentials, tokens, private content, raw imports, complete sensitive paths, or security-scoped URLs.

## Verification

- Skill or manifest changes: `./Scripts/verify-skills.sh` (and `./Scripts/test-install-skills.sh` if installer behavior changes)
- Archived package changes (only when explicitly requested): `cd archive && ./Scripts/verify.sh` — see `ARCHIVE.md` and `archive/Documentation/ModuleBoundaries.md`

Avoid broad unrelated refactors. Report commands not available locally.
