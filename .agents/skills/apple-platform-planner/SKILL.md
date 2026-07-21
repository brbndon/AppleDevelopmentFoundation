---
name: apple-platform-planner
description: Use when planning a new iOS, macOS, or shared Apple-platform feature. Do not use for implementation-only requests or non-Apple planning.
---

# Apple platform planner

Produce a **bounded implementation plan** for an Apple-platform feature in the **consumer workspace**. Do not write product code when the request is planning-only.

## Workflow

1. **Inspect context.** Read consumer `AGENTS.md` (root through relevant scopes), deployment targets, package products, existing modules, and navigation/state patterns before proposing architecture.
2. **Clarify the slice.** Restate the user goal, platforms in scope, and out-of-scope items. Stop and ask if platforms, consumer path, or success criteria are materially ambiguous.
3. **Separate shared vs platform-specific.** Identify logic that can stay shared versus presentation, navigation, or lifecycle differences that need `ios-macos-platform-adaptation` later.
4. **Name ownership.** For each major state or dependency, say who owns it (view, environment, observable model, actor, package) and how it is injected. Flag any proposed view model with an ownership or testability reason.
5. **Surface constraints early.** Note accessibility, privacy/permissions, entitlements, offline/network, and concurrency risks that affect design — not only polish.
6. **Plan verification.** List the smallest build/test/UI checks (XcodeBuildMCP / unit / Maestro) that will prove the feature. Prefer one exact simulator/device strategy when iOS is in scope.
7. **Sequence work.** Ordered implementation slices small enough to land independently. Recommend skill chain for the build phase (for example design system → component author → platform adaptation → reviews → testing).
8. **Risks and stops.** Call out unknowns, dependency needs that require authorization, and decisions that need the user.

## Plan shape (required sections)

- Goal and non-goals  
- Platforms and deployment assumptions  
- Shared core vs platform deltas  
- State / dependency ownership  
- Accessibility and privacy notes  
- Implementation sequence  
- Verification plan  
- Risks and open questions  
- Suggested skill chain for implementation  

## Stop conditions

- Implementation-only request with clear scope → do not over-plan; hand off to authoring skills and implement.
- Non-Apple or pure backend/web planning → out of scope for this skill.
- Planning-only → **no code**, no dependency changes, no project file edits.
- Missing consumer workspace → stop; do not plan against this foundation repo’s `archive/` unless explicitly asked.

Inputs: requested feature and existing project context. Output: a bounded implementation plan with risks and verification. Planning-only requests produce no code or repository changes.
