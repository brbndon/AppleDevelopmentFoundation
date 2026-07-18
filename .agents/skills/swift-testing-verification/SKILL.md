---
name: swift-testing-verification
description: Use after a meaningful Apple-platform code change to select and run verification. Do not use for planning-only work or before an implementation exists.
---

# Swift testing and verification

Choose the smallest relevant tests; run package-wide tests for dependencies or public APIs; build affected iOS and macOS examples. Report exact commands/outcomes and distinguish existing failures from introduced failures.

Inputs: completed change and affected targets. Output: executed verification results, unavailable checks, and manual-only checks. Never claim a check passed without running it.

## Apple verification capability ladder

For Xcode projects, use the first authorized path:

1. XcodeBuildMCP MCP tools. Before the first build/run/test, call
   `session_show_defaults` and report project/workspace, scheme, configuration,
   and exact simulator/device. Use one exact `simulatorId`; serialize same-project
   simulator tests and default `test_sim` to
   `extraArgs: ["-parallel-testing-enabled", "NO"]`.
2. XcodeBuildMCP CLI only when active repository/user policy explicitly permits
   CLI fallback.
3. Repository-native raw Xcode tooling only when active policy authorizes it;
   obtain explicit approval when required.
4. Report blocked when no authorized path exists.

Never infer authorization from shell access or installed binaries. Preserve the
same target context and test scope in an authorized fallback. Handoff must include
the project/workspace, scheme, configuration, exact destination, commands or tools,
outcomes, skipped checks, and residual risk.
