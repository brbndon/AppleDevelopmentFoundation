---
name: swift-package-module-author
description: Use when adding an independently importable Swift Package module. Do not use for an app-local feature without reusable consumers.
---

# Swift package module author

Confirm the module has two plausible consumers and a non-overlapping responsibility. Check dependency direction, define the product and targets, keep public APIs documented and small, create focused tests and generic example usage, update the graph/boundaries, and run package-wide verification.
