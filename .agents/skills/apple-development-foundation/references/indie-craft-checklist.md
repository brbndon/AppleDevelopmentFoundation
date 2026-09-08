# Indie craft checklist (consolidation only)

This file introduces no new rules, branding, or scopes. It consolidates existing
foundation craft so indie builders find it in one place. Source of truth stays in
the linked skills, `AGENTS.md`, and templates.

- Feature screens follow `AGENTS.md` "Apple development defaults": content opaque;
  glass reserved for system navigation chrome; ~44x44 pt targets on iOS/touch
  (platform-native sizing on macOS); system text styles; selective accent;
  frequency-gated motion (no animation on high-frequency or keyboard paths).
- Liquid Glass means adopting OS-owned navigation/control appearance first:
  native `TabView`, navigation bars, toolbars, sheets; never imitate system chrome
  with custom materials. See `swiftui-tab-navigation/references/liquid-glass-chrome.md`.
- User-facing failures go through `apple-error-states`; indeterminate loading uses
  `Templates/LiquidOrbLoader/README.md` (loader outside `ScrollView`, Reduce Motion
  freeze, no hard glow box); feature scope uses `Templates/NewFeature/Feature.md`.
- Shared UI passes `apple-accessibility-review` before calling reusable work
  complete; async work passes `swift-concurrency-review`; sensitive paths pass
  `apple-security-privacy-review`. Verify with `swift-testing-verification`.
