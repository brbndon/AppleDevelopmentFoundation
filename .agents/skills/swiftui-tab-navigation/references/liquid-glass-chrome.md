# Liquid Glass chrome (restraint)

Liquid Glass is a system-managed material for navigation and controls, not an
app-wide surface style. When a user requests Liquid Glass, preserve the
platform's layer hierarchy:

1. **System chrome:** use native `TabView`, navigation bars, toolbars, and
   sheets. On iOS 26 and later, these containers adopt the current system
   appearance automatically; let the OS own their shape, material, selection,
   safe-area behavior, and interaction.
2. **Content surfaces:** keep lists, tables, cards, forms, and feature content
   opaque. Glass should not be used to make ordinary content look like
   navigation chrome.
3. **Custom navigation controls:** only when a system container cannot express
   the control, use `glassEffect` in the navigation plane. Coordinate multiple
   glass elements with `GlassEffectContainer`; do not use custom glass to fake a
   tab bar or navigation bar.
4. **Fallbacks and accessibility:** preserve native behavior on older supported
   OS versions, Dynamic Type, contrast, VoiceOver, keyboard/pointer access,
   Reduce Motion, Differentiate Without Color, and usable hit targets.

## Do

- Put glass on the **navigation / control** layer only.
- Prefer **system** materials and containers; let the OS adopt Liquid Glass without imitation.
- Default material: **Regular**. Use **Clear** only over media, with dimming and bold/legible foreground.
- Use `.interactive()` only for controls that actually respond to touch or pointer interaction.
- Tint **one** primary action (or semantic accent), not every bar item.

## Don’t

- Do not apply glass to list/table/card **content** rows or large content surfaces.
- Do not stack glass-on-glass.
- Do not mix Regular and Clear in the same surface hierarchy without a clear media reason.
- Do not fake system tab/nav bars with custom `glassEffect`, materials, overlays, or safe-area bars.
- Do not keep older custom bar/sheet **opaque backgrounds** that fight scroll-edge / system materials — remove them when adopting system chrome.
- Do not treat glass appearance as a plain opacity fade when customizing materials; prefer system materialization behavior.
- In steady states, avoid large content intersections under glass chrome (rely on system scroll-edge effects; don’t pin opaque blockers that kill blur).
