---
name: codex-bootstrap
description: Use when bootstrapping a new iOS or macOS SwiftUI project or major feature set. Reference the skills in this repo (design system, components, reviews). Do not use for one-off app screens or when the user wants a full custom package rebuild.
---

# Codex bootstrap

Start with project goals, target platforms, and which skills to apply (swiftui-component-author, apple-design-system, apple-security-privacy-review, swift-concurrency-review, etc.). Set up minimal clean structure. Apply reusable design system and components from the start. Use XcodeBuildMCP for verification. Keep the bootstrap focused on the skills in this repo.

Inputs: bootstrap request + any existing design system or app constraints. Output: initial project structure, key files using the skills, verification plan with MCP/build commands, and instructions for the user to continue with specific skills. For planning only, output the bootstrap plan and skill selection without writing files.