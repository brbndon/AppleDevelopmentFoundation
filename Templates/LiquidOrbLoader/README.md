# Liquid orb loading mark (DotMatrixLoader)

Portable SwiftUI loading chrome proven in **Harborlight** (iOS 26). Use this for **indeterminate** full-surface and inline loading that feels continuous and liquid—not a discrete spinner or keyframed “pose” loop.

**Proven consumer:** Harborlight · `Harborlight/Components/DotMatrixLoader.swift`  
**Last synced:** soft-glow orb, per-surface loading copy, micro economy path, loader outside `ScrollView` (incl. Services + release sheets).

## What you get

| Piece | Role |
| --- | --- |
| `DotMatrixLoader` | 3×3 ring with a continuous highlight sweep; center cases: plain / pulse / symbol / emoji / **orb** |
| `DotMatrixLoader.feature` | Hero full-surface mark (generous ring air) |
| `DotMatrixLoader.compact` | Cards, forms, detail sections |
| `DotMatrixLoader.micro` | Poster tiles (~52pt-safe), dense banners; 30 Hz + lighter Canvas |
| `FeatureLoadingView` | Full-surface title + detail + hero orb (pass **screen-specific** detail) |
| `InlineLoadingRow` | Compact/micro orb + message for forms and panels |
| Continuous harmonics | REST → MERGE → REBOUND → RELAX emerge from sines—not keyframe holds |
| Reduce Motion | `TimelineView` pauses; orb freezes on the first frame |

## When to use

| Use | Avoid |
| --- | --- |
| Screen-level `FeatureState.loading` | Determinate progress → `ProgressView(value:)` |
| Empty-shell first fetch | High-frequency or keyboard-triggered chrome |
| Form “Searching…” / “Loading defaults…” | Putting private hostnames in detail copy |
| Detail panels (“Loading episodes…”) | Landing this in foundation `archive/Sources/` unless asked |
| Poster tile busy state (`.micro`) | |

Frequency note: loading chrome is occasional → motion is appropriate. Always honor Reduce Motion.

## Drop into a consumer app

1. Copy `DotMatrixLoader.swift` into the app target (e.g. `Components/`).
2. Map tokens if you have a design system:

   ```swift
   DotMatrixLoader(
       center: .orb,
       tint: AppColor.accent,            // default: Color.accentColor
       idleTint: AppColor.secondaryLabel // default: Color.secondary
   )
   ```

3. Use the right density:

   ```swift
   // Full-screen feature loading
   FeatureLoadingView(title: "Loading", detail: "Refreshing your library.")

   // Mark alone
   DotMatrixLoader.feature   // hero
   DotMatrixLoader.compact   // forms / cards
   DotMatrixLoader.micro     // posters / dense chrome

   // Inline row
   InlineLoadingRow(message: "Searching…")
   InlineLoadingRow(message: "Loading posters…", micro: true)
   ```

4. Wire full-screen `FeatureState` loading with **surface-specific** copy:

   ```swift
   switch state {
   case .loading:
       FeatureLoadingView(title: "Loading", detail: "Refreshing your library.")
           .frame(maxWidth: .infinity, minHeight: 360)
   // ...
   }

   // If you wrap FeatureState in a reusable view, pass loadingDetail per screen
   // (do not reuse a generic “services” string on Library/Calendar/Downloads).
   ```

5. **Layout critical:** put `FeatureStateView` (or the loading branch) **outside** `ScrollView`.  
   If the loader sits inside a scroll view, `maxHeight: .infinity` collapses and the mark looks wrong.  
   Same rule for **Services first load** and **release sheets**—not only tab roots.

   ```swift
   // Preferred structure
   FeatureStateView(state: state, retry: load) { content in
       ScrollView { /* content only */ }
   }

   // Avoid: ScrollView { FeatureStateView { … } }  // loader collapses
   // Avoid: ScrollView { if isLoading { FeatureLoadingView() } … }
   ```

6. Accessibility:
   - Mark: `accessibilityLabel("Loading")`, not an image.
   - Surface: combined `"\(title). \(detail)"` + a stable `accessibilityIdentifier` if you use inspection routes.

## Design rationale (keep these)

| Choice | Why |
| --- | --- |
| Harmonics, not keyframes | Smoothstep keyframes zero velocity at holds → “stop then go”. Sines never stop. |
| Oversized canvas (`layoutScale` ≈ 2.6) | Blur/glow needs room past the body; tight frames print a **hard square**. |
| No `scaleEffect` + tight secondary frame | That combo was the visible “box” around the orb. Bake squash into the polar path. |
| Radial mask + transparent gradient stops | Feathers residual canvas-edge hardness; body gradient ends in `.clear`. |
| Ring step from orb size | Liquid body must not overlap ring dots. |
| No brand glyph in the orb | Glyphs read as a frozen logo on a morphing blob; pure liquid reads cleaner. |
| `TimelineView(.animation)` | No `Timer`; pauses under Reduce Motion. |
| Presets scale with `dotSize` | `.feature` / `.compact` proportional (orb ≈ `dotSize * 5.2`); `.micro` tighter (≈4.5×, layoutScale 2.0) for compact posters. |
| Micro economy path | 30 Hz timeline, 64 path steps, single blur — safe when many tiles load at once. |

### Soft-glow anti-box checklist (when re-tuning visuals)

1. Canvas side ≥ body × **2.6** (or more).
2. Never apply `.frame(small)` **after** `scaleEffect` on the orb.
3. Body radial gradient last stop: **clear**.
4. Optional: mask the canvas with a soft radial white→clear gradient.
5. Parent bounds must include `orbSize * layoutScale` so the ring layout does not clip the glow.

## Proven Harborlight wiring

| Surface | Pattern |
| --- | --- |
| Home / Library / Calendar / Downloads | `FeatureStateView` → `FeatureLoadingView` with **per-screen** `loadingDetail` (loader outside `ScrollView`) |
| Services first load | `FeatureLoadingView` **outside** `ScrollView` (`detail: "Checking configured services…"`) |
| Settings developer preview | Sheet with `FeatureLoadingView` (~3s auto-dismiss) |
| Release sheets | `FeatureStateView` **outside** `ScrollView` (`loadingDetail: "Looking up releases."`) |
| Poster tiles | `DotMatrixLoader.micro` (economy path) |
| Poster progress banner | `InlineLoadingRow(..., micro: true)` |
| Add media search / defaults | `InlineLoadingRow` in form sections |
| Detail: episodes / *arr submit / qBit check | `InlineLoadingRow` |
| Transfer / download / completion bars | Keep **determinate** `ProgressView(value:)` |

## Verification checklist

- [ ] Reduce Motion freezes the mark
- [ ] Light and dark: orb remains readable on ambient background
- [ ] **No hard rectangular box** around the glow (screenshot at peak glow)
- [ ] Ring dots do not collide with the orb at peak scale
- [ ] Full-screen loader fills the viewport (not collapsed in a `ScrollView`)
- [ ] VoiceOver announces loading without treating the canvas as a photo
- [ ] Inspection / screenshot route if the app has deterministic loading states

## Do not

- Land this into AppleDevelopmentFoundation `archive/Sources/` unless you are explicitly expanding that package.
- Animate keyboard-triggered chrome with this mark.
- Put credentials or private hostnames on the loading detail string.
- Use this for determinate percent complete—keep `ProgressView(value:)`.
