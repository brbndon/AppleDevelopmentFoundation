# Integration Guide

> **Archived.** Historical package integration reference only. See [ARCHIVE.md](../ARCHIVE.md). Do not expand this package unless explicitly asked.

Add this directory as an Xcode local package or use a Git package reference. Select only required library products. An application owns `ModelContainer` schema types, routing destinations and deep-link parsing, feedback placement, app configuration, file export presentation, sandbox entitlements, appearance, currency formatting, and popover state. Inject `AppEnvironment`, clocks, identifiers, and services at the app shell. `AppEnvironment` has no package-provided SwiftUI environment key; apps choose their own environment key or initializer injection. Do not copy source files into applications: extend the module or create app-local code when the concern is not general.
