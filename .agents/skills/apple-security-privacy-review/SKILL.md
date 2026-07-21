---
name: apple-security-privacy-review
description: Use when reviewing storage, file access, logging, permissions, imports, or sensitive data. Do not use for purely visual changes or unrelated API style review.
---

# Apple security and privacy review

Review storage, file access, logging, permissions, imports, and sensitive data handling in the **consumer workspace**. Prefer findings and a fix plan; change code only when authorized.

## Workflow

1. **Data inventory for the change.** List data types touched (credentials, tokens, PII, user files, health/location if any, imported documents). Prefer minimization: collect, retain, and log only what the feature needs.
2. **Storage placement.** Secrets and credentials belong in Keychain (or equivalent secure storage), not `UserDefaults`, plain files, or source. Flag secrets in fixtures, previews, logs, or handoff text.
3. **Logging and diagnostics.** Never log credentials, tokens, private content, raw import payloads, complete sensitive paths, or security-scoped URLs. Prefer redacted identifiers. Distinguish user-facing recovery messages from developer diagnostics.
4. **Imports and file access.** Validate type/size/structure before parsing. Use security-scoped resource access correctly: start access, use the resource, stop access; do not retain long-lived scoped URLs casually. Prefer user-mediated picks over broad filesystem entitlement when possible.
5. **Permissions and entitlements.** Request only entitlements the feature needs. Note Info.plist usage strings when introducing new privacy-sensitive APIs. Entitlement grants are app-owned — report limitations; do not invent signing or provisioning steps as complete “fixes.”
6. **Unsafe paths.** Flag force-unwraps and force-tries on sensitive paths, path traversal on user-controlled paths, overly broad file permissions, and debug backdoors left in release code.
7. **Dependency and transport risk (when in scope).** Note new network clients, plaintext transport, or third-party SDKs that expand data sharing; require user authorization before adding dependencies.
8. **Findings format.** For each issue: location, data/risk, impact, recommended fix, and whether a test can guard it. Severity: blocking / should-fix / note.

## Review-only vs fix

- **Review-only:** severity-ranked findings; no product code changes.
- **Authorized fixes:** smallest safe change; add tests for validation/redaction where practical.
- Purely visual or style-only changes → out of scope.

## Verification

Re-check logging paths and import validation after fixes. Use `swift-testing-verification` for automated coverage of validation and redaction logic. Report residual risk for manual permission prompts, device-only behaviors, and entitlement configuration the agent cannot complete.

Inputs: relevant storage, import, logging, or permission code. Output: severity-ranked findings, targeted fixes/tests when authorized, and clear app-owned entitlement limitations. Distinguish user-facing recovery from developer diagnostics.
