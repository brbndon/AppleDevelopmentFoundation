# Verification Limitations

The SwiftPM executable examples are implemented and compiled by `./Scripts/verify.sh`. Their reusable state and I/O behavior is unit-tested where practical. They are not signed, distributable iOS or macOS applications and therefore do not prove:

- real iOS or macOS application lifecycle behavior;
- signing, entitlements, sandboxing, or App Store/archive behavior;
- SwiftData integration with a real app container;
- PhotosPicker permissions or behavior;
- document pickers, panels, or security-scoped URL acquisition;
- macOS windows, commands, and application settings integration.

SwiftUI accessibility semantics, Dynamic Type at large accessibility sizes, Full Keyboard Access, pointer/hover behavior, Reduce Motion, Increased Contrast, and Differentiate Without Color require manual review in real host apps. The next scoped roadmap item is a minimal pair of Xcode host-app verification harnesses; it is not implemented in this package.
