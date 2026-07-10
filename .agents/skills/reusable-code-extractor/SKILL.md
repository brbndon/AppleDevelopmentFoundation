---
name: reusable-code-extractor
description: Use when extracting a proven implementation from an application into this foundation. Do not use for speculative abstraction, a new module request, or an app-local refactor.
---

# Reusable code extractor

Inspect working application behavior and tests. Remove project terminology, domain models, branding, and hidden assumptions; design the smallest reusable API and preserve behavior with generic tests and example use.

Inputs: a proven implementation plus its tests and at least two plausible consumers. Output: a neutral extraction with integration verification. Stop if the evidence does not support reuse.
