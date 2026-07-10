---
name: apple-security-privacy-review
description: Use when reviewing storage, file access, logging, permissions, imports, or sensitive data. Do not use for purely visual changes or unrelated API style review.
---

# Apple security and privacy review

Check data minimization, explicit import validation, scoped-resource lifetime, sandbox/entitlement requirements, credential handling, unsafe paths, logging privacy, force unwraps on sensitive paths, and dependency risk.

Inputs: relevant storage, import, logging, or permission code. Output: severity-ranked findings, targeted fixes/tests when authorized, and clear app-owned entitlement limitations. Distinguish user-facing recovery from developer diagnostics.
