---
name: swift-package-module-author
description: Use when adding an independently importable Swift Package module in the active workspace. Do not use for an app-local feature, extraction review, or editing AppleDevelopmentFoundation archived package code unless explicitly asked.
---

# Swift package module author

Work in the **active workspace** package (the consumer's `Package.swift`), not AppleDevelopmentFoundation's archived package unless the user explicitly requests it.

Confirm two plausible consumers and a non-overlapping responsibility. Check dependency direction, define minimal products/targets, keep public APIs documented and small, create focused tests and generic example use, then update the dependency graph.

Inputs: proposed module responsibility and consumers. Output: a scoped module implementation in the consumer package and package-wide verification. Stop at a plan when implementation was not requested.
