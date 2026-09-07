# Archived website (superseded)

Historical Vite + React marketing SPA preserved for reference only. It is **not** the live product site and should not be deployed.

**Live docs:** [https://brbndon.github.io/AppleDevelopmentFoundation/](https://brbndon.github.io/AppleDevelopmentFoundation/) (Blume site under [`docs/`](../../docs/) at the repository root).

Authoritative entry points:

- [README.md](../../README.md) — install skills and skill inventory
- [MCP.md](../../MCP.md) — XcodeBuildMCP setup, tools, and copy-paste prompts
- [.agents/skills/](../../.agents/skills/) — reusable Codex skills (the live product)
- [ARCHIVE.md](../../ARCHIVE.md) — archive boundary

## Local preview (archive work only)

Only when explicitly working on this archived material. From the `archive/` directory:

```bash
npm ci --prefix Website
npm run dev --prefix Website
```

Open <http://localhost:5173>. Production build output lands in `Website/dist/` (gitignored).
