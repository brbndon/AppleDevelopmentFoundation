---
name: apple-design-system
description: Use when adding or changing reusable design-system tokens or components. Do not use for application branding, app-specific screens, or a general accessibility audit.
---

# Apple design system

Change **shared** semantic tokens or design-system components in the **consumer workspace**. Keep the system neutral and reusable; do not encode product branding or one-off screen layout here.

## Workflow

1. **Inventory first.** Locate existing token modules, color/type/space scales, and shared components in the consumer repo. Extend them; do not create a parallel design system without authorization.
2. **Semantic tokens before chrome.** Prefer roles (`background`, `label`, `accent`, `danger`, spacing scale, type styles) over raw hex or one-off sizes. Map tokens to light/dark (and increased contrast when the project supports it).
3. **Native first.** Prefer system materials, typography, and controls. Custom tokens should wrap or complement platform defaults, not fight them.
4. **Appearance and motion.** New visual tokens must remain readable in light and dark appearance. Prefer Reduce Motion–safe defaults; avoid decorative motion that is the only affordance of meaning.
5. **Differentiate without color alone.** Status and state must not rely only on hue when color is the sole signal.
6. **Layering.** Tokens feed shared components; app screens consume components/tokens. Do not hardcode magic numbers for shared UI when a token should exist.
7. **Document usage.** Name tokens for role, not for a single marketing campaign or temporary experiment. Note deprecations when replacing tokens.
8. **Verify.** Add or update focused tests/examples or a gallery surface when the project has one. Build the affected target. Accessibility audits of screens belong to `apple-accessibility-review`, not this skill alone.

## Stop conditions

- Application branding, campaign colors, or logo work → keep out of the shared system unless the user explicitly wants brand tokens in the consumer design system.
- App-specific screens or feature copy → feature implementation, not this skill.
- General accessibility audit of existing UI → `apple-accessibility-review`.
- Planning-only request → document proposed tokens/components and migration impact without implementation.

## Verification

Use `swift-testing-verification` for meaningful API or token logic changes. Build affected consumer targets. Report which appearances were checked and residual risk for unchecked contrast modes.

Inputs: shared token or component change. Output: neutral documented behavior, focused tests/examples, and gallery/build verification. Do not introduce branding or implement a planning-only request.
