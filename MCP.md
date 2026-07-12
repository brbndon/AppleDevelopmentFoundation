# MCPs, Commands & Bootstrapping

## Primary MCPs
- XcodeBuildMCP (used heavily for build, test, sim, UI inspection on iOS/macOS)
- Other local MCPs as configured in your Codex/Hermes setup

## Useful Commands
- Build/test on sim: use XcodeBuildMCP tools
- Codex bootstrap: tell Codex "bootstrap a new Ridora-style iOS app using the skills in this repo"
- Install skills: `./Scripts/install-skills.sh`
- Verify skills: `./Scripts/verify-skills.sh`

## How to Reference These Skills
When using Codex, say:
"Use the skills from /path/to/this-repo/.agents/skills (codex-bootstrap, swiftui-component-author, apple-design-system, apple-security-privacy-review, etc.)"

## Bootstrap Flow (codex-bootstrap skill)
1. Confirm project type (iOS/macOS, SwiftUI, design system reuse).
2. Set up basic app structure + link to these skills.
3. Apply relevant skills (design system, components, concurrency, security).
4. Verify with XcodeBuildMCP + tests.

Keep bootstraps focused on reusable skills + clean architecture. Do not rebuild the old full package unless asked.
