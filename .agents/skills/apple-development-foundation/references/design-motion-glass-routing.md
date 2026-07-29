# Design, motion, and Liquid Glass routing

Foundation-first routing for polish, Liquid Glass, and animation work. Host skills are **depth only** — never installable catalog replacements.

## Hard rule

For new UI, never shortlist host design/motion skills instead of:

- `swiftui-tab-navigation` (+ `liquid-glass-chrome.md`)
- `apple-design-system`
- `swiftui-component-author`
- `apple-accessibility-review`

Always-on craft for feature screens also lives in root `Agents.md` / `AGENTS.md`.

## Intent matrix

| Intent | Foundation first | Then | Host depth only if needed |
| --- | --- | --- | --- |
| New app / major skeleton | `$apple-development-foundation` → `$codex-bootstrap` → design-system, tabs, a11y | Chained children | — |
| Liquid Glass / materials | System chrome + `swiftui-tab-navigation` + `liquid-glass-chrome.md` | Custom `glassEffect` only after restraint | `~/.agents/skills/liquid-glass-design/SKILL.md` |
| Animation polish on a screen/component | `swiftui-component-author` craft defaults + a11y Reduce Motion | Delete high-frequency motion first | `~/.agents/skills/apple-design/SKILL.md` (gesture physics) |
| “What should animate?” | Craft defaults + frequency gate (no keyboard / high-frequency paths) | — | `~/.agents/skills/find-animation-opportunities/SKILL.md` |
| Whole-app motion audit | Craft + a11y baselines applied | — | `~/.agents/skills/improve-animations/SKILL.md` (read-only plans) |
| Motion naming / vocabulary | Prefer plain craft language in foundation skills | — | `~/.agents/skills/animation-vocabulary/SKILL.md` |

Also see [competing-macos-skills-plan.md](competing-macos-skills-plan.md).

## Liquid Glass procedure

1. Prefer **system** navigation chrome (`TabView`, toolbars, navigation bars, sheets) — do not imitate with custom glass.
2. Read `swiftui-tab-navigation/references/liquid-glass-chrome.md` and apply Do/Don’t restraint.
3. Use custom `glassEffect` / `GlassEffectContainer` **only** when system chrome cannot express a navigation-plane control, and only after restraint.
4. Host `liquid-glass-design` last — API depth after foundation restraint, never instead of it.

## Animation refactor steps

1. **Inventory** custom transitions and decorative motion on the touched surfaces.
2. **Delete high-frequency first** — keyboard-initiated paths, command palettes, shortcuts, rapid focus moves stay unanimated.
3. **Apply craft defaults** from `swiftui-component-author` (critically damped; bounce only after momentum; touch-down press; source-anchored; interruptible; no input lock) and honor Reduce Motion with non-motion feedback.
4. **Keep spatial origin** when presentation origin matters; prefer system transitions over multi-second choreography.
5. **Stop**, or go host-depth: gesture physics (velocity handoff, projection, rubber-banding) → `apple-design`; whole-app opportunity/audit process → `find-animation-opportunities` / `improve-animations` (read-only plans). Do not import glossaries, spring tables, or duration budgets into foundation skills.

## Host pointers (paths only — not catalog entries)

These are **not** installed by `./Scripts/install-skills.sh` and are not in `manifest.json`:

- `~/.agents/skills/apple-design/SKILL.md`
- `~/.agents/skills/find-animation-opportunities/SKILL.md`
- `~/.agents/skills/improve-animations/SKILL.md`
- `~/.agents/skills/animation-vocabulary/SKILL.md`
- `~/.agents/skills/liquid-glass-design/SKILL.md`
