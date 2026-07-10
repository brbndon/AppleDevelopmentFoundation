# Skill Authoring Guide

Repository source skills live in `.agents/skills/<name>/SKILL.md`; Codex discovers user skills from `~/.codex/skills` and repository skills using its configured local conventions. Explicitly invoke one with `$name` or name it in a request. A skill must have `name` and precise `description` frontmatter, one repeatable responsibility, triggers and exclusions, expected inputs/outputs, and verification. Keep operational instructions short; put durable long references in `references/`.

Use `AGENTS.md` for repository-wide always-on rules, a skill for conditional repeatable work, and normal documentation for human reference. Update the manifest, run `./Scripts/verify-skills.sh`, then inspect `./Scripts/install-skills.sh --dry-run`. Install selected skills with `./Scripts/install-skills.sh`; remove only links created by that script with `--uninstall`. Name conflicts are never overwritten: rename the source skill or remove the unrelated conflicting item yourself.
