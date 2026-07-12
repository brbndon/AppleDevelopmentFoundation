# MCPs, Commands & Bootstrapping

## Primary MCP: XcodeBuildMCP

Use XcodeBuildMCP tools instead of raw `xcodebuild`, `xcrun`, or `simctl` for iOS/macOS build, test, simulator, and UI inspection.

### Install and configure

1. Add XcodeBuildMCP to your Codex or Hermes MCP server list (see your client's MCP config docs).
2. Enable workflows you need beyond the default simulator tools: https://xcodebuildmcp.com/docs/configuration
3. After changing `.xcodebuildmcp/config.yaml`, reload or restart the MCP session.

Only simulator workflow tools are enabled by default. Device, macOS, debugging, and UI automation require explicit workflow configuration.

### Session workflow (every session)

1. Call `session_show_defaults` before the first build/run/test action.
2. Use `discover_projs` only when defaults show missing or incorrect project/workspace context — do not run discovery speculatively or in parallel with `session_show_defaults`.
3. For simulator run intent, prefer the combined build-and-run tool instead of separate build then run calls.
4. Report the active context used (project/workspace, scheme, simulator/device) and the exact failing step on errors.

### Key tools by task

| Task | Tools (representative) |
| --- | --- |
| Project discovery | `discover_projs`, scheme listing, build-settings inspection |
| Simulator build/run/test | build-and-run (preferred for run), build, test, install, launch |
| Simulator state | boot, erase, location, appearance |
| macOS | build, run, test (requires macOS workflow enabled) |
| Physical device | build, test, install, launch (requires device workflow + signing) |
| Logs | stream and capture from simulators and devices |
| UI inspection | screenshots, view hierarchy with coordinates, taps/swipes/gestures |
| SwiftPM | build, run, test Swift Package Manager projects |
| Scaffolding | generate new iOS/macOS project templates |

See the `xcodebuildmcp` skill in your user skills for full capability notes.

## Skill scripts

```bash
./Scripts/install-skills.sh      # symlink skills to user scope
./Scripts/verify-skills.sh       # validate manifest and skill contracts
./Scripts/test-install-skills.sh # test installer behavior
```

## Copy-paste prompts

**Reference these skills in any Codex session:**

> Use the skills from `/path/to/AppleDevelopmentFoundation/.agents/skills` — start with `codex-bootstrap`, then apply `apple-design-system`, `swiftui-component-author`, and review skills as needed.

**Bootstrap a new SwiftUI app:**

> Bootstrap a new iOS (or macOS) SwiftUI app using `$codex-bootstrap` and the skills in `/path/to/AppleDevelopmentFoundation/.agents/skills`. Use the consumer's design system or create a minimal neutral one. Verify with XcodeBuildMCP.

**Verify after bootstrap or feature work:**

> Call `session_show_defaults`, then build and test on the iOS simulator with XcodeBuildMCP. Report scheme, simulator, and any failures with the next actionable tool call.

## Bootstrap verification checklist

After `$codex-bootstrap` completes initial structure:

1. `session_show_defaults` — confirm project, scheme, and simulator/device
2. Build on simulator (or macOS target if applicable)
3. Run unit tests if present
4. Optional: capture a screenshot or view hierarchy to confirm the shell launches
5. Apply review skills (`swift-concurrency-review`, `apple-security-privacy-review`, `apple-accessibility-review`) before shipping shared components

Keep bootstraps focused on reusable skills and clean architecture in the **consumer workspace**. Do not rebuild the archived package in this repo unless asked — see [ARCHIVE.md](ARCHIVE.md).
