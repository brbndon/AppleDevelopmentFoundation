---
name: apple-development-foundation
description: Use to reference-first route an Apple-platform task to this repository's relevant child skills, or when an audit or comparison is explicitly requested. Do not treat it as a replacement for child instructions, an implied repository audit, or proof of automatic activation.
---

# Apple Development Foundation master

Use this skill as the single entry point when a new Apple-platform chat needs a
curated skill shortlist, or when a foundation audit or comparison is explicitly
requested.

## Procedure

1. Read [master-skill.json](master-skill.json) as the machine-readable catalog.
2. Use its IDs, roles, and purposes to shortlist only the children relevant to
   the request. Do not scan the repository, audit inventories, install skills,
   or run verification for ordinary routing.
3. Read only the shortlisted child `SKILL.md` files and follow their workflows;
   use `codex-bootstrap` for a new consumer Apple-platform project.
4. Audit or compare inventories only when explicitly requested. Use the JSON
   audit definitions and report its classifications consistently.
5. Run the JSON verification commands only for an audit of this foundation
   repository or its installer. Consumer app-code verification belongs to the
   selected child skill, such as `swift-testing-verification` or
   `maestro-apple-app-testing`.

Inputs: an Apple-platform task, or an explicitly requested skill inventory or
foundation audit. Output: a selected child-skill shortlist; for requested
audits, a baseline comparison and applicable exact verification outcomes.

This master skill references sibling skills; it does not copy their instructions,
override their exclusions, install global files, or claim automatic activation.
