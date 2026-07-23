# MCPs, Commands & Bootstrapping

## Primary MCP: XcodeBuildMCP

Use XcodeBuildMCP MCP tools as the primary interface for iOS/macOS build, test, simulator, and UI inspection. A missing capability does not by itself authorize a shell fallback.

**Naming:** MCP tool ids use underscores (e.g. `build_run_sim`). The CLI uses `xcodebuildmcp <workflow> <verb>` (e.g. `xcodebuildmcp simulator build-and-run`). Same implementations. Full map: Blume [XcodeBuildMCP](docs/tools/xcodebuildmcp.mdx) and https://xcodebuildmcp.com/docs/tools · https://xcodebuildmcp.com/docs/cli

### Install and configure

1. Add XcodeBuildMCP to your agent host’s MCP server list (see your client’s MCP config docs). Server entrypoint is typically `xcodebuildmcp mcp`.
2. Enable workflows you need beyond the default simulator tools: https://xcodebuildmcp.com/docs/configuration  
   Interactive: `xcodebuildmcp setup`. Diagnostics: `xcodebuildmcp doctor`.
3. After changing `.xcodebuildmcp/config.yaml`, reload or restart the MCP session.

Default MCP advertisement is the **`simulator`** workflow (plus session-management tools). Device, macOS, debugging, UI automation, and others require explicit `enabledWorkflows`.

### Session workflow (every session)

1. Call `session_show_defaults` before the first build/run/test action.
2. If defaults are missing or wrong, use `session_set_defaults` and/or config `sessionDefaults`. Use `discover_projs` only when you still need discovery — do not run it speculatively or in parallel with `session_show_defaults`.
3. For simulator run intent, prefer **`build_run_sim`** (CLI: `simulator build-and-run`) instead of separate build → install → launch.
4. Prefer an exact `simulatorId` when pinning a simulator for tests or Maestro.
5. Report the active context used (project/workspace, scheme, configuration, exact simulator/device) and the exact failing tool on errors.

### Capability and fallback ladder

Apply this order to every Apple build, run, test, simulator, or UI-inspection task:

1. **XcodeBuildMCP MCP tools.** Use the host's live MCP tool list and the session workflow above.
2. **XcodeBuildMCP CLI.** Use the matching `xcodebuildmcp` CLI workflow only when the active repository or user policy explicitly permits CLI fallback. Do not treat shell access or an installed binary as permission.
3. **Repository-native raw Xcode tooling.** Use documented project commands backed by `xcodebuild`, `xcrun`, or `simctl` only when the active repository/user policy authorizes that path. If it requires approval, obtain approval first. Preserve the selected project/workspace, scheme, configuration, exact destination, serialized test scope, and other safety constraints.
4. **Blocked.** If no authorized path exists, report the unavailable capability, the policy boundary, what was not run, and the next action needed. Do not silently bypass policy.

Every result or blocker must report the project/workspace, scheme, configuration, exact simulator/device when applicable, tool or command used, outcome, and residual risk. This ladder does not relax approval requirements for destructive actions, deployment, publishing, credentials, or user data.

### Key tools by task (MCP names)

| Task | MCP tools (representative) | CLI sketch |
| --- | --- | --- |
| Session context | `session_show_defaults`, `session_set_defaults`, `session_clear_defaults`, `session_use_defaults_profile` | config `sessionDefaults` / profiles |
| Project discovery | `discover_projs`, `list_schemes`, `show_build_settings` | `project-discovery discover-projects`, `list-schemes`, … |
| Simulator build/run/test | **`build_run_sim`** (preferred for run), `build_sim`, `test_sim`, `install_app_sim`, `launch_app_sim` | `simulator build-and-run`, `build`, `test`, `install`, `launch-app` |
| Simulator state | `boot_sim`, `open_sim`, erase/appearance/location tools in `simulator-management` | `simulator-management …` |
| macOS | `build_run_macos`, `build_macos`, `test_macos`, `launch_mac_app` | `macos build-and-run`, … |
| Physical device | `build_run_device`, `build_device`, `test_device`, `install_app_device`, `launch_app_device` | `device build-and-run`, … |
| UI inspection / automation | `screenshot`, `snapshot_ui`, `tap`, `swipe`, `type_text`, … | `ui-automation …` |
| SwiftPM | `swift_package_build`, `swift_package_test`, `swift_package_run`, … | `swift-package …` |
| Scaffolding | `scaffold_ios_project`, `scaffold_macos_project` | `project-scaffolding scaffold-ios` / `scaffold-macos` |

**`launchArgs`** go to the app process; **`extraArgs`** are `xcodebuild`/build-settings only (not app runtime args).

See the host’s live tool list and any global `xcodebuildmcp` skill for version-specific details.

## Skill scripts

```bash
./Scripts/install-skills.sh      # symlink skills to user scope
./Scripts/verify-skills.sh       # validate manifest and skill contracts
./Scripts/test-install-skills.sh # test installer behavior
```

## Copy-paste prompts

**Reference these skills in any Codex session:**

> Use the skills from `/path/to/AppleDevelopmentFoundation/.agents/skills` — start with `$apple-development-foundation` for routing (it shortlists `$codex-bootstrap` for new apps). Invoke `$codex-bootstrap` directly only when that skill is already selected. Then apply `$swiftui-tab-navigation`, `$apple-design-system`, `$swiftui-component-author`, and review skills as needed.

**Bootstrap a new SwiftUI app:**

> Use `$apple-development-foundation` as the entry point to bootstrap a new iOS (or macOS) SwiftUI app in the consumer workspace. It should route to `$codex-bootstrap` and chain `$swiftui-tab-navigation`, `$apple-design-system`, `$swiftui-component-author`, and review skills as needed. Verify with XcodeBuildMCP on the correct platform.

**Verify after bootstrap or feature work:**

> Call `session_show_defaults`, then verify with XcodeBuildMCP on the target platform: iOS → `build_run_sim` / `test_sim` (exact `simulatorId`); macOS → enable `macos` workflow, then `build_run_macos` / `test_macos`. Do not use simulator or ui-automation tools for macOS-only apps. Report scheme, destination, and any failures with the next actionable tool call.

## Bootstrap verification checklist

After `$codex-bootstrap` completes initial structure:

1. `session_show_defaults` — confirm project/workspace, scheme, configuration, and platform destination
2. **iOS:** `build_run_sim` for launch smoke; **macOS:** `build_run_macos` (requires `macos` workflow). If macOS launch smoke and tests are not run, at least `build_macos`
3. Run unit tests if present (`test_sim` / `test_macos`) with parallel testing disabled by default
4. Optional iOS-only: capture a screenshot or view hierarchy (`ui-automation`). macOS has no XcodeBuildMCP UI automation — rely on `test_macos`; if tests are absent, still require `build_run_macos` or at least `build_macos` (do not declare complete on residual risk alone)
5. Apply review skills (`swift-concurrency-review`, `apple-security-privacy-review`, `apple-accessibility-review`) before shipping shared components

Keep bootstraps focused on reusable skills and clean architecture in the **consumer workspace**. Do not rebuild the archived package in this repo unless asked — see [ARCHIVE.md](ARCHIVE.md).
