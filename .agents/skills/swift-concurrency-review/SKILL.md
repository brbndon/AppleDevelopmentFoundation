---
name: swift-concurrency-review
description: Use when reviewing async/await, actors, tasks, observation, Sendable diagnostics, or cancellation. Do not use for unrelated UI styling or synchronous API design.
---

# Swift concurrency review

Map actor isolation and state ownership. Prefer structured concurrency, propagate cancellation, avoid detached tasks without a written reason, keep UI on the main actor, and resolve Sendable correctness at boundaries.

Inputs: concurrent code and compiler diagnostics when available. Output: a concurrency finding/fix set, deterministic tests where practical, and strict-concurrency build result. A review-only request does not change code.
