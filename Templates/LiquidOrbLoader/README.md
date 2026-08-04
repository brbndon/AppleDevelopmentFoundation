# Liquid orb loading mark (DotMatrixLoader)

Portable SwiftUI loading chrome proven in **Harborlight** (iOS 26). Use this when you want a full-surface loading state that feels continuous and liquid, not a discrete spinner or keyframed “pose” loop.

## What you get

| Piece | Role |
| --- | --- |
| `DotMatrixLoader` | 3×3 ring with a continuous highlight sweep; center is a liquid-glass **orb** (or plain / pulse / symbol / emoji) |
| `FeatureLoadingView` | Full-surface “Loading” + detail copy above the mark |
| Continuous harmonics | Orb shape never holds still — REST → MERGE → REBOUND → RELAX emerge from sines, not keyframes |
| Reduce Motion | `TimelineView` pauses; orb freezes on the first frame |

## When to use

- **Yes:** Screen-level `FeatureState.loading`, empty-shell first fetch, developer loading previews.
- **No:** Determinate progress (use `ProgressView(value:)`), poster tile placeholders, tiny toolbar busy indicators, high-frequency keyboard paths.

Frequency note (Emil / Apple design): loading chrome is occasional → motion is appropriate. Keep Reduce Motion freezes.

## Drop into a consumer app

1. Copy `DotMatrixLoader.swift` into the app target (e.g. `Components/`).
2. Wire design tokens if you have them:

   ```swift
   // Optional: map to your design system
   DotMatrixLoader(
       center: .orb,
       tint: AppColor.accent,           // default: Color.accentColor
       idleTint: AppColor.secondaryLabel // default: Color.secondary
   )
   ```

3. Use the presets:

   ```swift
   // Full-screen feature loading
   FeatureLoadingView(title: "Loading", detail: "Refreshing your library.")

   // Or the mark alone
   DotMatrixLoader.feature   // generous spacing, hero orb
   DotMatrixLoader.compact   // cards / inline
   ```

4. Replace stock loading surfaces:

   ```swift
   switch state {
   case .loading:
       FeatureLoadingView()
   // ...
   }
   ```

5. Accessibility:
   - Mark: `accessibilityLabel("Loading")`, not an image.
   - Surface: combined label `"\(title). \(detail)"` + a stable `accessibilityIdentifier` if you use inspection routes.

## Design rationale (keep these)

| Choice | Why |
| --- | --- |
| Harmonics, not keyframes | Smoothstep keyframes zero velocity at holds → feels “stop then go”. Sines never stop. |
| Padded canvas (~1.55×) | Glow and stretch must not clip to a hard square. |
| Ring step from orb size | Prevents the liquid body from overlapping ring dots. |
| No brand glyph in the orb | Glyphs read as a frozen logo on a morphing blob; pure liquid reads cleaner. |
| `TimelineView(.animation)` | No `Timer`, no lifecycle dance; pauses under Reduce Motion. |

## Proven source

- App: Harborlight (`Harborlight/Components/DotMatrixLoader.swift`)
- Primary consumers: `FeatureStateView` loading case, Services first load, Settings developer preview

## Verification checklist

- [ ] Reduce Motion freezes the mark
- [ ] Light and dark: orb remains readable on ambient background
- [ ] Ring dots do not collide with the orb at peak scale
- [ ] VoiceOver announces loading without treating the canvas as a photo
- [ ] Inspection / screenshot route if the app has deterministic loading states

## Do not

- Land this into AppleDevelopmentFoundation `archive/Sources/` unless you are explicitly expanding that package.
- Animate keyboard-triggered chrome with this mark.
- Put credentials or private hostnames on the loading detail string.
