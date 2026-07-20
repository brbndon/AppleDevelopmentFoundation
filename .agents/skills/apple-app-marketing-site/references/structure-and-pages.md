# Structure and page patterns

## Recommended tree

```text
web/
├── astro.config.mjs
├── vercel.json
├── package.json
├── public/
│   ├── favicon.svg
│   └── favicon.ico
└── src/
    ├── layouts/
    │   └── BaseLayout.astro
    ├── components/
    │   ├── BrandMark.astro
    │   ├── Header.astro
    │   ├── Footer.astro
    │   ├── PageIntro.astro
    │   ├── LegalProse.astro
    │   ├── PhoneMockup.astro
    │   ├── TrustStrip.astro
    │   ├── SettlementVisual.astro   # or product-specific visual
    │   ├── HelpSearch.astro
    │   └── SupportForm.astro
    ├── pages/
    │   ├── index.astro
    │   ├── help/index.astro
    │   ├── support/index.astro
    │   ├── privacy/index.astro
    │   └── terms/index.astro
    └── styles/
        └── global.css
```

## `astro.config.mjs` essentials

```js
export default defineConfig({
  site: "https://example.app",
  trailingSlash: "always",
  build: { format: "directory" },
  vite: { plugins: [tailwindcss()] },
});
```

## Homepage sections (order)

1. **Hero** — eyebrow, display title, lede, coming-soon (or App Store) CTA, secondary text link, device mockup
2. **Trust strip** — three short privacy / product promises
3. **Story / journey** — three numbered beats (before / during / after)
4. **Clarity / feature** — diagram or simple visual + bullets
5. **Privacy band** — inverted night panel + link to privacy policy

Keep copy product-specific; keep rhythm and component reuse.

## Secondary pages

| Page | Shell | Interactive |
| --- | --- | --- |
| Help | `PageIntro` + category grids + FAQ | Search filter; FAQ via `<details>` |
| Support | `PageIntro` + form + suggestions card | Validation + `mailto:` toast |
| Privacy / Terms | `PageIntro` + `LegalProse` | None |

## Header / footer

- Primary nav example: Overview · Help · Support · Privacy (Terms footer-only)
- Footer: brand, one-line positioning, privacy promises, legal links, © year (build-time)
- Mobile: menu button + expandable nav; desktop: horizontal pill links
- `aria-current="page"` from pathname (normalize trailing slash)

## JS policy

| Behavior | Approach |
| --- | --- |
| Mobile menu | Small script in `Header` |
| Help search | Script in `HelpSearch` only |
| FAQ | Native `<details>` (no JS) |
| Support form | Script in `SupportForm`; `mailto:` only |
| Year | `new Date().getFullYear()` at build in Astro |

Homepage and legal pages should ship with **no page-specific JS** beyond the shared mobile menu.

## Accessibility baselines

- Skip link to `#main`
- `:focus-visible` rings on interactive controls
- ~44px min targets for primary controls
- `prefers-reduced-motion` disables non-essential transitions
- Semantic landmarks: `header`, `main`, `footer`, labelled sections
- Contrast: near-black on light canvas; check muted text on canvas

## Anti-patterns (avoid)

- JS-injected header/footer (FOUC, no-JS empty chrome)
- Third-party font CDNs + analytics on privacy-first products
- Rotated “sticker” UI cards competing with the device
- Disabled-opacity App Store buttons — use intentional “Coming soon” pill
- Duplicated head boilerplate across pages (use `BaseLayout`)
