# Liquid Glass chrome (restraint)

System navigation chrome owns Liquid Glass. Prefer native `TabView`, toolbars, navigation bars, and sheets.

## Do

- Put glass on the **navigation / control** layer only.
- Prefer **system** materials and containers; let the OS adopt Liquid Glass without imitation.
- Default material: **Regular**. Use **Clear** only over media, with dimming and bold/legible foreground.
- Custom floating controls in the navigation plane: `glassEffect` **inside** `GlassEffectContainer` only when system chrome cannot express the control.
- Tint **one** primary action (or semantic accent), not every bar item.

## Don’t

- Do not apply glass to list/table/card **content** rows or large content surfaces.
- Do not stack glass-on-glass.
- Do not mix Regular and Clear in the same surface hierarchy without a clear media reason.
- Do not fake system tab/nav bars with custom `glassEffect`, materials, overlays, or safe-area bars.
- Do not keep older custom bar/sheet **opaque backgrounds** that fight scroll-edge / system materials — remove them when adopting system chrome.
