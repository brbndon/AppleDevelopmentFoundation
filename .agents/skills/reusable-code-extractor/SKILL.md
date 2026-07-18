---
name: reusable-code-extractor
description: Use when extracting a proven implementation from an application into a shared module or package in the consumer workspace. Do not use for speculative abstraction, landing code in the AppleDevelopmentFoundation archived package, or an app-local refactor that should stay local.
---

# Reusable code extractor

Inspect working application behavior and tests in the **active workspace**. Remove project terminology, domain models, branding, and hidden assumptions; design the smallest reusable API and preserve behavior with generic tests and example use.

Target the consumer's shared module or Swift package — not AppleDevelopmentFoundation `archive/Sources/` unless the user explicitly asked to work on that archived package.

Inputs: a proven implementation plus its tests and at least two plausible consumers. Output: a neutral extraction in the consumer workspace with integration verification. Stop if the evidence does not support reuse.
