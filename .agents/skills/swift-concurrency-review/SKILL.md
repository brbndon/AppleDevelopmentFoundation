---
name: swift-concurrency-review
description: Use when reviewing async/await, actors, tasks, observation, Sendable warnings, or cancellation. Do not use for unrelated UI styling.
---

# Swift concurrency review

Map actor isolation and state ownership. Prefer structured concurrency, propagate cancellation, avoid detached tasks without a written reason, keep UI on the main actor, and resolve Sendable correctness at boundaries. Add deterministic tests where practical and report any compiler diagnostics that cannot be exercised.
