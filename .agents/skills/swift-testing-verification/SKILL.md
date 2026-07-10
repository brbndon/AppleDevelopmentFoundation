---
name: swift-testing-verification
description: Use after a meaningful Apple-platform code change to select and run verification. Do not use for planning-only work or before an implementation exists.
---

# Swift testing and verification

Choose the smallest relevant tests; run package-wide tests for dependencies or public APIs; build affected iOS and macOS examples. Report exact commands/outcomes and distinguish existing failures from introduced failures.

Inputs: completed change and affected targets. Output: executed verification results, unavailable checks, and manual-only checks. Never claim a check passed without running it.
