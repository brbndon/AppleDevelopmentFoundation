# Integration Guide

Add this directory as an Xcode local package or use a Git package reference. Select only required library products. An application owns `ModelContainer` schema types, routing destinations, feedback placement, app configuration, file export presentation, sandbox entitlements, and appearance. Inject `AppEnvironment`, clocks, identifiers, and services at the app shell. Do not copy source files into applications: extend the module or create app-local code when the concern is not general.
