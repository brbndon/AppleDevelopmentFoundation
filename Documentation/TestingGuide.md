# Testing Guide

> **Archived.** Historical package testing reference only. See [ARCHIVE.md](../ARCHIVE.md). Do not expand this package unless explicitly asked.

Use XCTest and deterministic inputs. Test pure validation/progression/routing directly; use `FixedAppClock`, `FixedIdentifierProvider`, and `TemporaryDirectory` from the test-only `TestingSupport` target; configure SwiftData containers in-memory for preview/test-only schemas. Test actor state through actor methods and main-actor UI state with actor-aware tests. `./Scripts/verify.sh` runs package description, strict-concurrency compilation, macOS build/tests, iOS-simulator compilation, installer behavior tests, skill schema validation, and documentation-link validation. Manual accessibility review remains required for SwiftUI semantics and platform navigation; see [Verification Limitations](VerificationLimitations.md).
