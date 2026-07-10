# Security and Privacy

No telemetry, analytics, network clients, secrets, or user-specific paths belong in this foundation. Validate imported type and byte size before reading a file; use security-scoped access only around necessary work; write exports atomically; use Application Support and temporary locations deliberately. Apps must supply sandbox entitlements and document any file, Photos, camera, or microphone permission.

`FoundationLogger` accepts only developer-authored event categories. Never interpolate credentials, tokens, private user content, raw imports, complete sensitive paths, security-scoped URLs, or arbitrary error descriptions. Handle failures explicitly; avoid force unwraps on import, storage, and security paths.
