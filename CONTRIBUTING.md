# Contributing

This repo's product is **skills + MCP references**, not the archived Swift package.

- Skill changes: update `.agents/skills/<name>/SKILL.md` and the canonical `.agents/skills/manifest.json`, run `./Scripts/generate-skill-catalog.py`, then run `./Scripts/verify-skills.sh` and `./Scripts/test-install-skills.sh`
- Docs: keep `README.md`, `MCP.md`, and `AGENTS.md` aligned with skills-first purpose
- Agent playbook: update Blume content under `docs/` when the skill/MCP workflow changes; run `npm run build` and `npm run validate` from the repo root
- Archived package: see `ARCHIVE.md` — do not expand `archive/Sources/` or public APIs unless explicitly requested

See `AGENTS.md` and `docs/skills/skill-authoring-guide.mdx` for durable rules.
