# ADR 0001: iOS 17 and macOS 14 minimums

> **Archived.** Historical package decision only. See the [archive README](../../README.md). Do not expand this package unless explicitly asked.

The package targets iOS 17 and macOS 14. These versions provide modern SwiftUI navigation, observation, SwiftData, and `@Entry`, while maintaining a useful compatibility floor for a reusable local foundation. Newer APIs need availability gates and fallbacks. Revisit only with a documented consumer need.
