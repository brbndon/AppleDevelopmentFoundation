#!/usr/bin/env python3
"""Generate checked-in skill catalog projections from the canonical manifest."""

from __future__ import annotations

import argparse
import copy
import json
import re
import sys
from pathlib import Path, PurePosixPath
from typing import Any


REPO_ROOT = Path(__file__).resolve().parent.parent
MANIFEST_PATH = REPO_ROOT / ".agents/skills/manifest.json"
README_PATH = REPO_ROOT / ".agents/skills/README.md"
DOCS_PATH = REPO_ROOT / "docs/skills/index.mdx"
MASTER_PATH = REPO_ROOT / ".agents/skills/apple-development-foundation/master-skill.json"
README_BEGIN_MARKER = "<!-- BEGIN GENERATED SKILL CATALOG -->"
README_END_MARKER = "<!-- END GENERATED SKILL CATALOG -->"
DOCS_BEGIN_MARKER = "{/* BEGIN GENERATED SKILL CATALOG */}"
DOCS_END_MARKER = "{/* END GENERATED SKILL CATALOG */}"
GENERATED_COMMAND = "./Scripts/generate-skill-catalog.py"
NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
ALLOWED_SCOPES = {"repository", "repository-or-user"}
REQUIRED_SKILL_FIELDS = {
    "name": str,
    "path": str,
    "description": str,
    "role": str,
    "scope": str,
    "purpose": str,
    "use_for": str,
    "do_not_use_for": str,
    "installable": bool,
    "router_included": bool,
}


class CatalogError(Exception):
    """Raised when the manifest or a generated target is invalid."""


def load_manifest() -> dict[str, Any]:
    try:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise CatalogError(f"cannot read {MANIFEST_PATH.relative_to(REPO_ROOT)}: {error}") from error
    validate_manifest(manifest)
    return manifest


def require_nonempty(value: Any, expected_type: type, location: str) -> None:
    if not isinstance(value, expected_type):
        raise CatalogError(f"{location} must be {expected_type.__name__}")
    if expected_type is str and not value.strip():
        raise CatalogError(f"{location} must not be empty")


def validate_manifest(manifest: Any) -> None:
    if not isinstance(manifest, dict):
        raise CatalogError("manifest root must be an object")
    if manifest.get("schema_version") != 2:
        raise CatalogError("manifest schema_version must be 2")
    router = manifest.get("router")
    if not isinstance(router, dict):
        raise CatalogError("manifest.router must be an object")
    for field in ("skill_id", "name", "kind", "description", "example_prompt"):
        require_nonempty(router.get(field), str, f"manifest.router.{field}")
    for field in ("source", "invocation", "routing", "audit"):
        if not isinstance(router.get(field), dict):
            raise CatalogError(f"manifest.router.{field} must be an object")

    skills = manifest.get("skills")
    if not isinstance(skills, list) or not skills:
        raise CatalogError("manifest.skills must be a nonempty array")
    names: set[str] = set()
    paths: set[str] = set()
    for index, skill in enumerate(skills):
        location = f"manifest.skills[{index}]"
        if not isinstance(skill, dict):
            raise CatalogError(f"{location} must be an object")
        for field, expected_type in REQUIRED_SKILL_FIELDS.items():
            require_nonempty(skill.get(field), expected_type, f"{location}.{field}")
        name = skill["name"]
        path = skill["path"]
        if not NAME_PATTERN.fullmatch(name):
            raise CatalogError(f"{location}.name is not a lowercase kebab-case skill ID: {name}")
        pure_path = PurePosixPath(path)
        if pure_path.is_absolute() or len(pure_path.parts) != 1 or path in {".", ".."}:
            raise CatalogError(f"{location}.path must be one relative directory name: {path}")
        if name in names:
            raise CatalogError(f"duplicate skill name: {name}")
        if path in paths:
            raise CatalogError(f"duplicate skill path: {path}")
        if skill["scope"] not in ALLOWED_SCOPES:
            allowed = ", ".join(sorted(ALLOWED_SCOPES))
            raise CatalogError(f"{location}.scope must be one of: {allowed}")
        names.add(name)
        paths.add(path)

    router_id = router["skill_id"]
    if router_id not in names:
        raise CatalogError(f"manifest.router.skill_id is not a manifest skill: {router_id}")
    router_entry = next(skill for skill in skills if skill["name"] == router_id)
    if router_entry["router_included"]:
        raise CatalogError("the router skill cannot include itself in parent_skills")


def markdown_table(skills: list[dict[str, Any]], include_path: bool) -> str:
    if include_path:
        lines = [
            "| Skill | Path | Use for | Do not use for |",
            "| --- | --- | --- | --- |",
        ]
        for skill in skills:
            path = f".agents/skills/{skill['path']}/SKILL.md"
            lines.append(
                f"| `{skill['name']}` | `{path}` | {skill['use_for']} | {skill['do_not_use_for']} |"
            )
    else:
        lines = ["| Skill | Use for | Do not use for |", "| --- | --- | --- |"]
        for skill in skills:
            lines.append(
                f"| {skill['name']} | {skill['use_for']} | {skill['do_not_use_for']} |"
            )
    return "\n".join(lines)


def generated_readme_section(manifest: dict[str, Any]) -> str:
    return "\n".join(
        [
            README_BEGIN_MARKER,
            "<!-- Generated from .agents/skills/manifest.json. Do not edit this section directly. -->",
            markdown_table(manifest["skills"], include_path=False),
            README_END_MARKER,
        ]
    )


def generated_docs_section(manifest: dict[str, Any]) -> str:
    count = len(manifest["skills"])
    return "\n".join(
        [
            DOCS_BEGIN_MARKER,
            "{/* Generated from .agents/skills/manifest.json. Do not edit this section directly. */}",
            ":::note Generated catalog",
            f"This inventory contains **{count} skills** and is checked for drift in CI. Regenerate it with `{GENERATED_COMMAND}`.",
            ":::",
            "",
            "## Inventory",
            "",
            "Deep procedure lives in each skill’s `SKILL.md` — prefer reading that over forking long instructions into this site. Paths are relative to the foundation repository root.",
            "",
            markdown_table(manifest["skills"], include_path=True),
            DOCS_END_MARKER,
        ]
    )


def replace_generated_section(path: Path, generated: str, begin_marker: str, end_marker: str) -> str:
    try:
        current = path.read_text(encoding="utf-8")
    except OSError as error:
        raise CatalogError(f"cannot read {path.relative_to(REPO_ROOT)}: {error}") from error
    begin_count = current.count(begin_marker)
    end_count = current.count(end_marker)
    if begin_count != 1 or end_count != 1:
        raise CatalogError(
            f"{path.relative_to(REPO_ROOT)} must contain exactly one generated catalog marker pair"
        )
    before, remainder = current.split(begin_marker, 1)
    _, after = remainder.split(end_marker, 1)
    return before + generated + after


def generated_master(manifest: dict[str, Any]) -> str:
    router = copy.deepcopy(manifest["router"])
    output: dict[str, Any] = {
        "schema_version": 1,
        "_generated": {
            "source": ".agents/skills/manifest.json",
            "command": GENERATED_COMMAND,
            "notice": "Do not edit this file directly.",
        },
        "skill_id": router.pop("skill_id"),
        "name": router.pop("name"),
        "kind": router.pop("kind"),
        "description": router.pop("description"),
        "source": router.pop("source"),
        "invocation": router.pop("invocation"),
        "routing": router.pop("routing"),
        "parent_skills": [
            {
                "id": skill["name"],
                "path": f".agents/skills/{skill['path']}/SKILL.md",
                "role": skill["role"],
                "purpose": skill["purpose"],
            }
            for skill in manifest["skills"]
            if skill["router_included"]
        ],
        "audit": router.pop("audit"),
        "example_prompt": router.pop("example_prompt"),
    }
    if router:
        raise CatalogError(f"unhandled manifest.router fields: {', '.join(sorted(router))}")
    return json.dumps(output, indent=2, ensure_ascii=False) + "\n"


def expected_outputs(manifest: dict[str, Any]) -> dict[Path, str]:
    return {
        README_PATH: replace_generated_section(
            README_PATH,
            generated_readme_section(manifest),
            README_BEGIN_MARKER,
            README_END_MARKER,
        ),
        DOCS_PATH: replace_generated_section(
            DOCS_PATH,
            generated_docs_section(manifest),
            DOCS_BEGIN_MARKER,
            DOCS_END_MARKER,
        ),
        MASTER_PATH: generated_master(manifest),
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate skill catalog projections from .agents/skills/manifest.json."
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="exit nonzero instead of writing when a generated output is stale",
    )
    args = parser.parse_args()
    try:
        outputs = expected_outputs(load_manifest())
    except CatalogError as error:
        print(f"catalog error: {error}", file=sys.stderr)
        return 1

    stale: list[Path] = []
    for path, expected in outputs.items():
        current = path.read_text(encoding="utf-8") if path.is_file() else ""
        if current == expected:
            continue
        if args.check:
            stale.append(path)
        else:
            path.write_text(expected, encoding="utf-8")
            print(f"updated {path.relative_to(REPO_ROOT)}")

    if stale:
        for path in stale:
            print(f"stale generated catalog: {path.relative_to(REPO_ROOT)}", file=sys.stderr)
        print(f"run {GENERATED_COMMAND} to regenerate", file=sys.stderr)
        return 1
    if args.check:
        print(f"skill catalog is current ({len(outputs)} generated outputs)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
