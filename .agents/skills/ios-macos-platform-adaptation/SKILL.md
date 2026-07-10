---
name: ios-macos-platform-adaptation
description: Use when an Apple-platform feature behaves differently on iOS and macOS. Do not use when native behavior is genuinely identical.
---

# iOS and macOS adaptation

Identify the native convention on both platforms. Keep shared logic separate and isolate divergent presentation in platform-specific extensions or files; avoid large conditional view bodies. Document differences involving navigation, input, menus, windows, sheets, file access, or lifecycle, then verify both targets.
