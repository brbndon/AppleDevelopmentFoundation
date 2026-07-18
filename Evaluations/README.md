# Skill behavioral evaluations

`skill-routing.json` is the version-controlled behavioral fixture set for the
repository's skill router and framework boundaries. It records prompt-level
expectations; it does not execute a model and does not prove that a supported
host will automatically activate a skill.

Each catalog skill has at least two `should_use` and two `should_not_use`
fixtures. Every prompt records:

- the expected skill ID or ordered shortlist;
- the workspace classification;
- whether implementation is authorized;
- whether a foundation audit is expected;
- the required verification category and stop condition; and
- whether handoff must report exact checks and residual risk.

An empty `skill_ids` array means that no skill in this repository's catalog is
appropriate for that prompt; it is still an explicit routing expectation.

`schema.json` documents the machine-readable contract. The dependency-free
`Scripts/validate-skill-evaluations.py` validator enforces that contract,
catalog ID validity, complete catalog coverage, and the required framework
boundaries. Run it directly with:

```bash
./Scripts/validate-skill-evaluations.py
```

Normal CI validates fixture structure and coverage only. Prompt conformance
still requires a person or an optional model runner to compare an observed
response with these expectations. Any future model-run record must include the
host, model, model version, and evaluation date, and must describe its result as
prompt conformance rather than guaranteed automatic activation.
