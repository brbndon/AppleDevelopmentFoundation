---
name: swift-concurrency-review
description: Use when reviewing async/await, actors, tasks, observation, Sendable diagnostics, or cancellation. Do not use for unrelated UI styling or synchronous API design.
---

# Swift concurrency review

Review concurrent Swift code in the **consumer workspace**. Prefer findings and a fix plan; change code only when the user authorized implementation.

## Workflow

1. **Map isolation.** List actor boundaries (`MainActor`, custom actors), global/shared mutable state, and which types cross isolation. Note observation/`@Observable` objects and where UI reads them.
2. **Structured concurrency first.** Prefer `async` functions, task groups, and child tasks tied to a scope. Flag unstructured `Task { }` that outlives the caller without ownership; require a written reason for `Task.detached`.
3. **Cancellation.** Ensure long-running work checks cancellation (`Task.checkCancellation` / `try Task.checkCancellation` / cooperative exits) and that callers can cancel. Avoid swallowing `CancellationError` as success.
4. **UI on the main actor.** View updates, UIKit/AppKit bridging, and observable model mutations that drive UI should be main-actor isolated or explicitly hopped. Flag off-main UI mutation.
5. **Sendable at boundaries.** Resolve compiler diagnostics at isolation edges; avoid `@unchecked Sendable` unless the invariant is documented and enforced. Prefer value types or actor-owned state over shared classes.
6. **Data races and reentrancy.** Watch for mutable capture in concurrent closures, non-isolated mutable globals, and actor reentrancy assumptions (state may change across `await`).
7. **Observation pitfalls.** Avoid redundant observation that performs heavy work on every change; keep expensive async work explicit and cancellable when views disappear.
8. **Findings format.** For each issue: location, isolation problem, impact, recommended fix, and whether a test can lock it. Severity: blocking / should-fix / note.

## Review-only vs fix

- **Review-only:** findings + recommended sequence; no product code changes.
- **Authorized fixes:** smallest isolation-correct change; add deterministic tests where practical.
- Do not use this skill for pure styling or synchronous API bikeshedding.

## Verification

When code changes, use `swift-testing-verification` and a strict-concurrency-aware build when the project enables it. Report exact tools/commands and outcomes. Never claim a concurrency check passed without running it. List residual risk for untested race windows.

Inputs: concurrent code and compiler diagnostics when available. Output: a concurrency finding/fix set, deterministic tests where practical, and strict-concurrency build result. A review-only request does not change code.
