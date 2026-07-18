# Versioning and Compatibility

> **Archived.** Historical versioning and compatibility reference only. See the [archive README](../README.md). Do not expand this package unless explicitly asked.

This package follows semantic versioning once shared outside its local repository: patch releases fix compatible behavior and documentation; minor releases add compatible public APIs; major releases may remove or change source-visible behavior.

A breaking change includes removing or renaming a product, public declaration, case, parameter, generic constraint, platform availability, default behavior, documented security guarantee, or skill name. Deprecate public APIs before removal whenever practical and include a migration note in `CHANGELOG.md`. Raise iOS 17 or macOS 14 only in a major release unless consumers explicitly agree otherwise.

Skill names are compatibility surface for explicit invocation. Preserve a renamed skill as a documented compatibility alias only when the Codex discovery environment supports it; otherwise retain the old name until a major release and document the replacement. Each release should include concise changelog entries for public changes, migrations, minimum-platform changes, and verification limitations. Do not tag or publish a release without explicit authorization.
