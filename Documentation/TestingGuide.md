# Testing Guide

Use XCTest and deterministic inputs. Test pure validation/progression/routing directly; use `FixedClock` and `TemporaryDirectory` from TestingSupport; configure SwiftData containers in-memory for preview/test-only schemas. Test actor state through actor methods and main-actor UI state with actor-aware tests. Run `./Scripts/test.sh` for all package tests and `./Scripts/verify.sh` after public or module changes. Manual accessibility review remains required for SwiftUI semantics and platform navigation.
