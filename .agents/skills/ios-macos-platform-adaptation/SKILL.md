---
name: ios-macos-platform-adaptation
description: Use when an Apple-platform feature genuinely behaves differently on iOS and macOS. Do not use when native behavior is identical or when only planning a new feature.
---

# iOS and macOS adaptation

Identify the native convention on both platforms. Keep shared logic separate and isolate divergent presentation in platform-specific extensions or files; avoid large conditional view bodies.

Inputs: an existing divergent feature and both platform expectations. Output: documented platform differences, focused implementation/tests, and both-platform verification. Do not add conditionals merely to speculate about future divergence.
