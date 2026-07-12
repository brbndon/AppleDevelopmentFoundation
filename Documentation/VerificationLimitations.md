# Verification Limitations

> **Archived.** Historical verification limitations reference only. See [ARCHIVE.md](../ARCHIVE.md). Do not expand this package unless explicitly asked.

The SwiftPM executable examples are implemented and compiled by `./Scripts/verify.sh`. Their reusable state and I/O behavior is unit-tested where practical. They are not signed, distributable iOS or macOS applications and therefore do not prove:

- real iOS or macOS application lifecycle behavior;
- signing, entitlements, sandboxing, or App Store/archive behavior;
- SwiftData integration with a real app container;
- PhotosPicker permissions or behavior;
- document pickers, panels, or security-scoped URL acquisition;
- macOS windows, commands, and application settings integration.

The async security-scoped API must be manually verified in a signed host app using a real document
picker URL, the app's sandbox entitlement, and any persisted bookmark flow. SwiftPM tests cannot
prove scoped-resource lifetime under real entitlements.

SwiftUI accessibility semantics, Dynamic Type at large accessibility sizes, Full Keyboard Access, pointer/hover behavior, Reduce Motion, Increased Contrast, and Differentiate Without Color require manual review in real host apps. The next scoped roadmap item is a minimal pair of Xcode host-app verification harnesses; it is not implemented in this package.

Manual host review must also confirm feedback-banner wrapping at large Dynamic Type sizes, VoiceOver
status announcements without redundant symbols, and macOS keyboard navigation.
