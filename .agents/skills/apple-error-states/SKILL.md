---
name: apple-error-states
description: Use when designing, implementing, or reviewing user-facing error handling and error states in a consumer iOS or macOS app. Do not use for pure error propagation without presentation, token-only design work, or non-UI services.
---

# Apple error states

Design, implement, or review **user-facing error handling** in the **consumer workspace** for iOS and macOS SwiftUI apps: choosing the right presentation, making errors recoverable and reportable, and modeling errors so user copy stays separate from diagnostics.

## Choose the presentation first

Match the error's severity and context to a presentation; do not default everything to an alert.

| Failure context | Presentation | Notes |
| --- | --- | --- |
| Blocking, single-context failure that stops the current action | System alert (`.alert`) | One alert at a time; never stack alerts. Human reason plus one primary action (Retry or OK); Cancel where dismissal is safe. |
| Transient, non-blocking failure the user can ignore | Inline status on iOS; banner alert (`.banner` presentation style) or inline status on macOS | Short message; recover automatically when possible; never block the interface. |
| Field or form validation | Inline next to the control | Keep the message next to the invalid field; a separate alert is only for a first invalid submission. |
| Content that failed to load | Dedicated retry state in the content area, not an alert | `ContentUnavailableView` (iOS 17+/macOS 14+) with a Retry action; the rest of the screen stays usable. |
| Feature or data permanently unavailable | Full-screen error state | `ContentUnavailableView` with an explanation and a way forward (contact support, reopen document) when relevant. |
| Destructive-confirmation decision | Confirmation dialog (action sheet) | A decision, not an error; do not style it as one. |

Alert rules: never surface two errors as stacked alerts — coalesce or queue them; dismiss an alert when the underlying state resolves; keep error text short and actionable (what happened, what to do next).

## Make errors reportable (copy and details)

Users hit errors the app cannot fix; give them a way to send you the useful part.

- **Copy button.** Every detailed error surface (alert, banner, retry state) should offer a "Copy details" affordance when the error carries diagnostics. Copy a structured multiline payload to the platform pasteboard (`UIPasteboard.general` on iOS, `NSPasteboard.general` on macOS) — not just the message: error title and message, error domain/code, the underlying error chain, app version and build, OS version, and a timestamp. Confirm the copy visibly (label change or haptic).
- **Show details disclosure.** Hide technical diagnostics behind a "Show details" disclosure by default; the user-facing message leads. Never dump debug strings into the main message.
- **Accessibility.** The copy control needs a descriptive label ("Copy error details"), expanded details must be readable by VoiceOver, and non-alert errors announce their arrival to assistive tech (announce the user-facing message, not the diagnostics payload). Verify at large Dynamic Type sizes that no essential text clips.
- **No secrets.** Copy payloads and logs must not include credentials, tokens, private content, or complete sensitive paths — chain `apple-security-privacy-review` when errors touch sensitive data.

## Model errors for humans and machines

- Conform to `LocalizedError` and provide `errorDescription` (user-facing message) and `recoverySuggestion` where a next step exists. Keep diagnostics (domain, code, underlying chain) separate for the copy payload.
- Never present `String(describing: error)` or a bare `localizedDescription` from a non-`LocalizedError` error as the user message — those are debug strings, not copy.
- Preserve the underlying error chain (wrap or use the underlying-error key) so "Copy details" includes the root cause, not just the outer failure.
- **Retry** means the failing operation is safely re-callable: the retried task must not depend on state the failed attempt left behind; Cancel dismisses rather than retries. Do not silently swallow failures and show success.
- Log diagnostics, not user-visible copy: structured log with error domain/code and chain, no secrets. Failures are reported in the UI, not only in logs.

## Platform differences

- **macOS:** prefer banner alerts or inline status for non-blocking errors; windowed alerts for blocking ones. Alerts must be keyboard-reachable with standard key equivalents (Esc to dismiss, Return for the primary action where the system provides it). Document-level errors can surface in the window's status area.
- **iOS:** alerts are modal and interruptive — reserve them for blocking failures; inline or retry states elsewhere. Confirmation dialogs are for destructive choices only, never for error reporting. Non-alert errors rely on VoiceOver announcements.
- Both: verify the error state at large Dynamic Type sizes and with keyboard access where the platform has it; never present an error with motion or color alone as the only signal.

## Review checklist

Review existing error handling top-down:

1. Presentation matches severity — no alert where an inline or retry state fits; no stacked alerts.
2. User-facing message is human copy; diagnostics hidden behind "Show details" and included in the copy payload.
3. Copy affordance exists on detailed errors; payload is structured and secret-free.
4. Retry is safe and re-callable; failures are not swallowed into success.
5. Accessibility: labeled controls, announcements, Dynamic Type, keyboard (macOS).
6. Logs carry diagnostics without secrets or private content.

For each finding: control/view, problem, user impact, recommended fix, and severity (blocking / should-fix / note).

## Stop conditions

- Non-UI services, networking, or data layers with no presentation → `swift-concurrency-review` for propagation; do not apply this skill.
- Token or branding-only design work → `apple-design-system`.
- Platform-behavior divergence with no error-state UX → `ios-macos-platform-adaptation`.
- Planning-only request → deliver the presentation plan and verification list without writing product code.

## Verification

After implementing error states: build the host target and run focused tests for retry/copy logic via `swift-testing-verification`; follow with `apple-accessibility-review` for shared error UI; cover at least one error journey (for example an airplane-mode load failure) with `maestro-apple-app-testing`. List manual checks the environment cannot automate (VoiceOver announcement timing, banner dismissal, platform-specific alert styling). Report residual risk for untested platforms.

Inputs: error-handling requirement or existing error UI in the consumer workspace. Output: presentation decision, user-facing copy plus structured diagnostics, safe retry behavior, copy/report affordances, and the relevant build/test evidence. Do not claim accessibility or platform behavior passed without evidence.
