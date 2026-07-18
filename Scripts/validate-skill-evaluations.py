#!/usr/bin/env python3
"""Validate behavioral evaluation fixtures against the canonical skill catalog."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_FIXTURES = REPO_ROOT / "Evaluations/skill-routing.json"
MANIFEST_PATH = REPO_ROOT / ".agents/skills/manifest.json"
SCHEMA_PATH = REPO_ROOT / "Evaluations/schema.json"
ACTIVATION_CLAIM = (
    "Fixtures define prompt expectations; they do not guarantee automatic skill "
    "activation in any host."
)
IDENTIFIER = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
WORKSPACES = {
    "consumer-workspace",
    "foundation-repository",
    "foundation-archive",
    "non-apple-workspace",
    "unresolved",
}
VERIFICATION_CATEGORIES = {
    "none",
    "planning",
    "review",
    "apple-code",
    "apple-ui-e2e",
    "skill-framework",
    "foundation-audit",
    "installer-behavior",
}
STOP_CONDITIONS = {
    "none",
    "plan-only",
    "review-only",
    "request-clarification",
    "report-blocked",
    "preserve-conflict",
    "outside-scope",
}
REQUIRED_BOUNDARIES = {
    "ordinary-routing-no-audit",
    "consumer-workspace-no-archive",
    "review-only-no-edit",
    "missing-xcodebuildmcp-policy",
    "planning-only-no-implementation",
    "installer-conflicts-preserved",
    "handoff-exact-checks-and-risk",
}
BOUNDARY_REQUIREMENTS = {
    "ordinary-routing-no-audit": {
        "workspace_classification": "consumer-workspace",
        "implementation_authorized": False,
        "audit_expected": False,
    },
    "consumer-workspace-no-archive": {
        "workspace_classification": "consumer-workspace",
    },
    "review-only-no-edit": {
        "implementation_authorized": False,
        "stop_condition": "review-only",
    },
    "missing-xcodebuildmcp-policy": {
        "stop_condition": "report-blocked",
    },
    "planning-only-no-implementation": {
        "implementation_authorized": False,
        "stop_condition": "plan-only",
    },
    "installer-conflicts-preserved": {
        "verification_category": "installer-behavior",
        "stop_condition": "preserve-conflict",
    },
}
EXPECTED_FIELDS = {
    "skill_ids",
    "workspace_classification",
    "implementation_authorized",
    "audit_expected",
    "verification_category",
    "stop_condition",
    "handoff",
}


class EvaluationError(Exception):
    """Raised when fixtures violate the behavioral evaluation contract."""


def load_json(path: Path, label: str) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise EvaluationError(f"cannot read {label} {path}: {error}") from error


def require_object(value: Any, location: str, fields: set[str]) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise EvaluationError(f"{location} must be an object")
    missing = sorted(fields - value.keys())
    extra = sorted(value.keys() - fields)
    if missing or extra:
        raise EvaluationError(
            f"{location} fields differ; missing: {', '.join(missing) or 'none'}; "
            f"extra: {', '.join(extra) or 'none'}"
        )
    return value


def require_identifier(value: Any, location: str) -> str:
    if not isinstance(value, str) or not IDENTIFIER.fullmatch(value):
        raise EvaluationError(f"{location} must be a lowercase kebab-case identifier")
    return value


def validate_expectation(value: Any, location: str, skill_ids: set[str]) -> None:
    expectation = require_object(value, location, EXPECTED_FIELDS)
    expected_skills = expectation["skill_ids"]
    if not isinstance(expected_skills, list):
        raise EvaluationError(f"{location}.skill_ids must be an array")
    if len(expected_skills) != len(set(expected_skills)):
        raise EvaluationError(f"{location}.skill_ids must not contain duplicates")
    invalid = sorted(
        repr(skill) if not isinstance(skill, str) else skill
        for skill in expected_skills
        if not isinstance(skill, str) or skill not in skill_ids
    )
    if invalid:
        raise EvaluationError(f"{location}.skill_ids contains invalid IDs: {', '.join(invalid)}")
    if expectation["workspace_classification"] not in WORKSPACES:
        raise EvaluationError(f"{location}.workspace_classification is invalid")
    for field in ("implementation_authorized", "audit_expected"):
        if not isinstance(expectation[field], bool):
            raise EvaluationError(f"{location}.{field} must be boolean")
    if expectation["verification_category"] not in VERIFICATION_CATEGORIES:
        raise EvaluationError(f"{location}.verification_category is invalid")
    if expectation["stop_condition"] not in STOP_CONDITIONS:
        raise EvaluationError(f"{location}.stop_condition is invalid")
    handoff = require_object(
        expectation["handoff"],
        f"{location}.handoff",
        {"report_exact_checks", "report_residual_risk"},
    )
    for field, field_value in handoff.items():
        if not isinstance(field_value, bool):
            raise EvaluationError(f"{location}.handoff.{field} must be boolean")


def validate_prompt_case(
    value: Any,
    location: str,
    skill_ids: set[str],
    seen_case_ids: set[str],
    *,
    boundary: bool = False,
) -> dict[str, Any]:
    fields = {"id", "prompt", "expected"}
    if boundary:
        fields.add("boundary_id")
    case = require_object(value, location, fields)
    case_id = require_identifier(case["id"], f"{location}.id")
    if case_id in seen_case_ids:
        raise EvaluationError(f"duplicate fixture ID: {case_id}")
    seen_case_ids.add(case_id)
    if not isinstance(case["prompt"], str) or not case["prompt"].strip():
        raise EvaluationError(f"{location}.prompt must be a nonempty string")
    validate_expectation(case["expected"], f"{location}.expected", skill_ids)
    return case


def validate(fixtures_path: Path) -> tuple[int, int]:
    manifest = load_json(MANIFEST_PATH, "manifest")
    schema = load_json(SCHEMA_PATH, "schema")
    schema_properties = schema.get("properties", {})
    schema_expectation = schema.get("$defs", {}).get("expectation", {})
    if schema_properties.get("schema_version", {}).get("const") != 1:
        raise EvaluationError("Evaluations/schema.json does not document schema version 1")
    if schema_properties.get("activation_claim", {}).get("const") != ACTIVATION_CLAIM:
        raise EvaluationError("Evaluations/schema.json activation limitation has drifted")
    if set(schema_expectation.get("required", [])) != EXPECTED_FIELDS:
        raise EvaluationError("Evaluations/schema.json expected fields have drifted")
    schema_expectation_properties = schema_expectation.get("properties", {})
    documented_enums = {
        "workspace_classification": WORKSPACES,
        "verification_category": VERIFICATION_CATEGORIES,
        "stop_condition": STOP_CONDITIONS,
    }
    for field, allowed in documented_enums.items():
        if set(schema_expectation_properties.get(field, {}).get("enum", [])) != allowed:
            raise EvaluationError(f"Evaluations/schema.json {field} values have drifted")
    skill_ids = {item["name"] for item in manifest.get("skills", [])}
    if not skill_ids:
        raise EvaluationError("manifest contains no skill IDs")

    fixtures = require_object(
        load_json(fixtures_path, "fixtures"),
        "fixtures",
        {"schema_version", "activation_claim", "skills", "framework_boundaries"},
    )
    if fixtures["schema_version"] != 1:
        raise EvaluationError("fixtures.schema_version must be 1")
    if fixtures["activation_claim"] != ACTIVATION_CLAIM:
        raise EvaluationError("fixtures.activation_claim must preserve the activation limitation")
    if not isinstance(fixtures["skills"], list):
        raise EvaluationError("fixtures.skills must be an array")

    seen_case_ids: set[str] = set()
    covered_skills: set[str] = set()
    prompt_count = 0
    for index, value in enumerate(fixtures["skills"]):
        location = f"fixtures.skills[{index}]"
        entry = require_object(value, location, {"skill_id", "should_use", "should_not_use"})
        skill_id = require_identifier(entry["skill_id"], f"{location}.skill_id")
        if skill_id not in skill_ids:
            raise EvaluationError(f"{location}.skill_id is not in the manifest: {skill_id}")
        if skill_id in covered_skills:
            raise EvaluationError(f"duplicate skill evaluation: {skill_id}")
        covered_skills.add(skill_id)
        for kind in ("should_use", "should_not_use"):
            cases = entry[kind]
            if not isinstance(cases, list) or len(cases) < 2:
                raise EvaluationError(f"{location}.{kind} must contain at least two cases")
            for case_index, case_value in enumerate(cases):
                case_location = f"{location}.{kind}[{case_index}]"
                case = validate_prompt_case(case_value, case_location, skill_ids, seen_case_ids)
                expected = case["expected"]["skill_ids"]
                if kind == "should_use" and skill_id not in expected:
                    raise EvaluationError(
                        f"{case_location} must include its subject skill {skill_id}"
                    )
                if kind == "should_not_use" and skill_id in expected:
                    raise EvaluationError(
                        f"{case_location} must exclude its subject skill {skill_id}"
                    )
                prompt_count += 1

    missing_skills = sorted(skill_ids - covered_skills)
    extra_skills = sorted(covered_skills - skill_ids)
    if missing_skills or extra_skills:
        raise EvaluationError(
            "fixture skill coverage differs from manifest; "
            f"missing: {', '.join(missing_skills) or 'none'}; "
            f"extra: {', '.join(extra_skills) or 'none'}"
        )

    boundaries = fixtures["framework_boundaries"]
    if not isinstance(boundaries, list):
        raise EvaluationError("fixtures.framework_boundaries must be an array")
    seen_boundaries: set[str] = set()
    for index, value in enumerate(boundaries):
        location = f"fixtures.framework_boundaries[{index}]"
        case = validate_prompt_case(
            value, location, skill_ids, seen_case_ids, boundary=True
        )
        boundary_id = require_identifier(case["boundary_id"], f"{location}.boundary_id")
        if boundary_id in seen_boundaries:
            raise EvaluationError(f"duplicate framework boundary: {boundary_id}")
        seen_boundaries.add(boundary_id)
        expectation = case["expected"]
        for field, expected_value in BOUNDARY_REQUIREMENTS.get(boundary_id, {}).items():
            if expectation[field] != expected_value:
                raise EvaluationError(
                    f"{location}.expected.{field} must be {expected_value!r} for {boundary_id}"
                )
        if boundary_id == "handoff-exact-checks-and-risk" and expectation["handoff"] != {
            "report_exact_checks": True,
            "report_residual_risk": True,
        }:
            raise EvaluationError(
                f"{location}.expected.handoff must require exact checks and residual risk"
            )
        prompt_count += 1
    missing_boundaries = sorted(REQUIRED_BOUNDARIES - seen_boundaries)
    if missing_boundaries:
        raise EvaluationError(
            f"missing required framework boundaries: {', '.join(missing_boundaries)}"
        )
    return len(covered_skills), prompt_count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--fixtures",
        type=Path,
        default=DEFAULT_FIXTURES,
        help="fixture file to validate (defaults to Evaluations/skill-routing.json)",
    )
    args = parser.parse_args()
    fixtures_path = args.fixtures.resolve()
    try:
        skill_count, prompt_count = validate(fixtures_path)
    except EvaluationError as error:
        print(f"evaluation error: {error}", file=sys.stderr)
        return 1
    print(f"validated {prompt_count} behavioral fixtures across {skill_count} skills")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
