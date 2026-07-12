# Foundation website

This is an isolated React + Tailwind SPA powered by Vite that introduces the **skills + MCP** product of this repository. The site deliberately lives outside the Swift package targets and does not change package source, products, or module dependencies.

Authoritative entry points in the repository:

- [README.md](../README.md) — install skills and skill inventory
- [MCP.md](../MCP.md) — XcodeBuildMCP setup, tools, and copy-paste prompts
- [.agents/skills/](../.agents/skills/) — reusable Codex skills (the live product)
- [ARCHIVE.md](../ARCHIVE.md) — archived Swift package, examples, and historical docs

The website includes a clearly labeled archived-package reference section. Do not treat that material as active integration guidance.

## Install and preview locally

From the repository root, install the website-only dependencies once:

```bash
npm ci --prefix Website
```

Start the Vite development server with HMR:

```bash
npm run dev --prefix Website
```

Open <http://localhost:5173>.

## Build and preview production output

```bash
npm run build --prefix Website
npm run preview --prefix Website
```

The production preview runs on <http://localhost:4174>. The build output is written to `Website/dist/`.

## Deploy

Publish the contents of `Website/dist/` as the document root on any static host, including GitHub Pages, Cloudflare Pages, Netlify, or a simple web server. No backend, runtime service, environment variables, or external assets are required.

Run `./Scripts/verify-website.sh` after `npm ci --prefix Website` and before publishing to validate the source anchors and production build.

The website dependencies are intentionally isolated from the Swift package. To remove the frontend tooling, delete `Website/package.json`, `Website/package-lock.json`, `Website/vite.config.js`, and `Website/src/`, then restore the static `index.html` and `script.js` entry arrangement.
