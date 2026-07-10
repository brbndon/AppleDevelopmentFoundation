---
name: swift-package-module-author
description: Use when adding an independently importable Swift Package module. Do not use for an app-local feature, extraction review, or a type added to an existing module.
---

# Swift package module author

Confirm two plausible consumers and a non-overlapping responsibility. Check dependency direction, define minimal products/targets, keep public APIs documented and small, create focused tests and generic example use, then update the graph.

Inputs: proposed module responsibility and consumers. Output: a scoped module implementation and package-wide verification. Stop at a plan when implementation was not requested.
