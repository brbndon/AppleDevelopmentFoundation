# Template: Apple app marketing site

Reusable pattern for a **static Astro + Tailwind** marketing site that ships with an iOS or macOS app.

This pack documents the polish language proven on consumer apps (light-first, monochrome-capable, system fonts, privacy-respecting). It is meant to be **copied into a consumer repo’s `web/` folder** and re-themed—not published as a live package dependency.

## What’s in this folder

| File | Purpose |
| --- | --- |
| [README.md](./README.md) | This overview |
| [RETHEME.md](./RETHEME.md) | Colors, fonts, assets, strings — edit checklist |
| [STRUCTURE.md](./STRUCTURE.md) | Folder layout, components, routes |
| [CHECKLIST.md](./CHECKLIST.md) | Ship checklist (a11y, perf, Vercel, content) |
| [TOKEN_REFERENCE.css](./TOKEN_REFERENCE.css) | Copy-paste `@theme` starter |

Agent workflow skill (for Codex and other hosts that load foundation skills):

`.agents/skills/apple-app-marketing-site/`

## Quick start (new product)

1. Scaffold Astro + Tailwind v4 in the consumer app’s `web/` directory (or copy a prior app’s `web/` tree and strip product copy).
2. Drop in layout/components from the skill structure guide.
3. Paste `TOKEN_REFERENCE.css` into `src/styles/global.css` and adjust tokens.
4. Walk [RETHEME.md](./RETHEME.md).
5. Fill homepage + legal/help content.
6. `npm run build` and deploy with Vercel root = `web`.

## Design intent

- Calm Apple product-marketing feel
- Typography and whitespace as primary tools
- Near-black / monochrome chrome by default (easy accent swap)
- CSS device mockup, upright, soft ground shadow
- Zero third-party tracking scripts

## Related foundation skills

- `$apple-app-marketing-site` — agent playbook for build/polish/retheme
- `$app-store-screenshots` — App Store screenshot sets (external)
- `$apple-design-system` — **native** app design tokens (SwiftUI), not the website
