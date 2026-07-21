---
name: apple-accessibility-review
description: Use when reviewing reusable SwiftUI UI for accessibility. Do not use for non-UI code, general design-token work, or pixel-only critique.
---

# Apple accessibility review

Review **reusable SwiftUI** in the **consumer workspace** for accessibility and platform interaction. Prefer findings and a fix plan; change code only when authorized.

## Inspection order

Work top-down through the component or shared UI under review:

1. **VoiceOver** — meaningful labels, traits, values, hints only when needed; correct grouping/combine; decorative images hidden; custom controls expose actions.
2. **Dynamic Type** — layouts reflow; no truncated essential text at large sizes; avoid fixed heights that clip content.
3. **Focus and keyboard** — logical order on platforms with keyboard/focus (especially macOS); no keyboard traps; actionable elements reachable.
4. **Touch and hit targets** — controls remain usable; spacing does not rely on tiny hit areas alone.
5. **Color and contrast** — text and essential icons remain readable; Increased Contrast considered when the project supports it.
6. **Reduce Motion** — essential feedback not motion-only; honor reduced-motion preferences for non-essential animation.
7. **Differentiate Without Color** — state not conveyed by hue alone (icons, text, shapes).
8. **Icon-only controls** — every one has a descriptive accessibility label (not the SF Symbol name alone when that is opaque).
9. **Platform differences** — when iOS and macOS both ship the UI, note divergent interaction (pointer, menus, tab vs sidebar) and verify both if behavior differs.

## Findings format

For each issue: control/view, problem, user impact, recommended fix, and evidence type (`code-review` | `build` | `runtime-hierarchy` | `manual-VoiceOver` | `manual-keyboard`). Severity: blocking / should-fix / note.

## Review-only vs fix

- **Review-only:** severity-ranked findings + recommended sequence; no product code changes.
- **Authorized fixes:** smallest accessibility-correct change; add focused tests/examples where practical.
- Do not use this skill for non-UI services, token-only design work, or pixel-only critique.

## Stop conditions

- Non-UI services, networking, or pure data layers → out of scope.
- Token-only or general design-system authoring without UI review → `apple-design-system`.
- Pixel-perfect visual critique without a11y criteria → out of scope.
- Review-only request → do not change code unless authorized.

## Claims and verification

- **Do not claim** VoiceOver, keyboard, or contrast “passed” without corresponding evidence. List manual checks the environment cannot automate.
- Prefer runtime hierarchy or screenshot evidence when available via XcodeBuildMCP UI tools.
- When platforms diverge, verify both or explicitly mark the skipped platform as residual risk.
- After authorized fixes to shared UI, re-check the affected items and use `swift-testing-verification` for logic/tests that support accessibility behavior.

Inputs: reusable SwiftUI views and supported platforms. Output: actionable findings, focused tests/examples where possible, documented manual checks, and both-platform verification when behavior differs. Do not claim automated validation for semantics the environment cannot test.
