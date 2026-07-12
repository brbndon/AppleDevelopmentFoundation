# Skill Authoring Guide

> **Repo product:** skills under `.agents/skills/` are the live product. The Swift package and most of `Documentation/` are archived reference — see [ARCHIVE.md](../ARCHIVE.md).

Repository source skills live in `.agents/skills/<name>/SKILL.md`; Codex discovers user skills from `~/.codex/skills` and repository skills using its configured local conventions. Explicitly invoke one with `$name` or name it in a request. A skill must have `name` and precise `description` frontmatter, one repeatable responsibility, triggers and exclusions, expected inputs/outputs, and verification. Keep operational instructions short; put durable long references in `references/`.

Skills apply to the **consumer workspace** (the app or package the user is building), not to AppleDevelopmentFoundation's archived `Sources/` unless explicitly requested.

Use `AGENTS.md` for repository-wide always-on rules, a skill for conditional repeatable work, and normal documentation for human reference. Update the manifest, run `./Scripts/verify-skills.sh`, `./Scripts/test-install-skills.sh`, then inspect `./Scripts/install-skills.sh --dry-run`. Install selected skills with `./Scripts/install-skills.sh`; `--uninstall` removes only a symlink whose destination still matches installer state, including a broken symlink left by a moved repository. Name conflicts and identical external links are never claimed or overwritten. See [Skill Evaluation](SkillEvaluation.md) for semantic review and activation limits.
