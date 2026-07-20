---
name: apple-app-marketing-site
description: Use when creating, re-theming, polishing, or migrating a static Astro + Tailwind marketing site for an iOS or macOS app (landing, help, support, privacy, terms). Do not use for SwiftUI app UI, App Store screenshot sets, or general web apps unrelated to Apple product marketing.
---

# Apple app marketing site

Build calm, monochrome-capable, Apple-inspired static marketing sites for consumer iOS/macOS apps. Prefer **Astro + Tailwind v4**, system fonts, zero third-party analytics, and shared layout components.

## When to use

- New app marketing site under `web/` (or similar) in a consumer app repo
- Visual polish / Apple-marketing redesign of an existing static landing site
- Re-theme of a prior site for a new product (colors, brand, fonts, assets)
- Migration from Vite multi-page HTML to Astro while preserving routes and legal copy

## When not to use

- Native SwiftUI screens or in-app design tokens → `$apple-design-system` / `$swiftui-component-author`
- App Store marketing screenshots and device frame exports → `$app-store-screenshots`
- Complex SaaS web apps, auth, CMS, or server forms

Inputs: product name, domain, support email; routes and page content (or permission to scaffold placeholders); theme intent (light-first monochrome default, or accent / dual appearance); privacy posture (local-first messaging is common).

Output: static Astro site with `BaseLayout`, `Header`, `Footer`, and design tokens in `global.css`; content-faithful pages (legal/help unchanged unless requested); Vercel-ready build with trailing-slash routes; clear re-theme edit points for the next product clone.

## Stack defaults

| Choice | Default |
| --- | --- |
| Framework | Astro (latest stable), static output |
| CSS | Tailwind CSS v4 via `@tailwindcss/vite` |
| Fonts | System stack only (`system-ui` / `-apple-system` / SF Pro) |
| JS | Minimal: mobile nav; optional help search, FAQ `<details>`, `mailto:` support form |
| Deploy | Vercel, project root = `web/` when monorepo |
| Analytics | None |

## Architecture (copy this shape)

```text
web/
├── astro.config.mjs      # site URL, trailingSlash: "always"
├── vercel.json
├── package.json
├── public/               # favicon.svg, favicon.ico, optional og image
└── src/
    ├── layouts/BaseLayout.astro
    ├── components/       # Header, Footer, BrandMark, PhoneMockup, …
    ├── pages/            # index, help/, support/, privacy/, terms/
    └── styles/global.css # @theme tokens — primary re-theme surface
```

Typical routes: `/`, `/help/`, `/support/`, `/privacy/`, `/terms/`.

## Design principles (from the polish reference)

1. **Type-led hierarchy** — display headlines with tight tracking; restrained body size and muted color.
2. **Generous whitespace** — section padding ~96–128px desktop; avoid dense SaaS chrome.
3. **Monochrome default** — near-black ink CTAs and links; accent optional via tokens.
4. **Minimal decoration** — one premium device treatment; no sticker collages or heavy gradients.
5. **Device mockup** — near-upright CSS iPhone, soft ground shadow, no floating badges.
6. **Static chrome** — header/footer in HTML at build time (never JS-injected).
7. **Privacy-respecting** — no third-party scripts; support via client `mailto:` only.

## Re-theme checklist (under one hour)

1. Edit `@theme` tokens in `src/styles/global.css` (colors, fonts, shadows, radii).
2. Update product strings: brand label, nav, footers, titles, meta, domain in `astro.config.mjs`.
3. Replace `public/` favicons (and OG image if present).
4. Adjust `BrandMark.astro` or swap for a logo image in `public/`.
5. Rewrite homepage copy and `PhoneMockup` screen content for the new product.
6. Port help/support/legal content **or** keep structure and replace article bodies carefully.
7. Set `site` URL and Vercel root; run `npm run build`.

Full token tables, component inventory, and page patterns:

- [references/retheme-guide.md](references/retheme-guide.md)
- [references/structure-and-pages.md](references/structure-and-pages.md)

Human-facing template pack (copy into consumer projects): repository path `Templates/AppMarketingSite/` (`README.md`, `RETHEME.md`, `STRUCTURE.md`, `CHECKLIST.md`, `TOKEN_REFERENCE.css`).

## Implementation order

1. Scaffold Astro + Tailwind in `web/`; configure `site` + trailing slashes.
2. Tokens + `BaseLayout` / `Header` / `Footer` (static).
3. Homepage (hero, mockup, trust, story, feature, privacy band).
4. Secondary pages with shared `PageIntro` + `LegalProse`.
5. Minimal islands only where needed.
6. `npm run build`; responsive pass; Vercel config.

## Verification

```bash
cd web && npm run build
```

Confirm routes emit under `dist/` with trailing-slash directories, header/footer present **without** client JS, and no third-party script tags. Optional: `npm run preview` and check mobile hero + mockup.

## Reference implementation

Consumer example of this polish language: **Group Trip Money** marketing site (`GroupTripMoney/web/`) — monochrome light-first Astro + Tailwind. Do not copy product-specific legal text; copy structure, tokens, and components.
