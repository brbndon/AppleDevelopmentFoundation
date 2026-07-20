# Re-theme guide — Apple app marketing site

Use this when cloning a polished Astro marketing site for a new iOS/macOS product. Target: re-theme in under an hour without redesigning layout.

## 1. Color tokens (`src/styles/global.css` → `@theme`)

| Token | Role | Monochrome default |
| --- | --- | --- |
| `--color-canvas` | Page background | `#f5f5f7` |
| `--color-surface` | Cards, elevated panels | `#ffffff` |
| `--color-ink` | Primary text + solid CTAs + brand mark | `#1d1d1f` |
| `--color-muted` | Secondary body / nav | `#6e6e73` |
| `--color-faint` | Tertiary / microcopy | `#86868b` |
| `--color-line` | Hairlines | `#d2d2d7` |
| `--color-night` | Inverted bands (privacy CTA) | `#1d1d1f` |
| `--color-on-night` | Text/buttons on night | `#f5f5f7` |
| `--color-on-accent` | Text on solid ink CTAs | `#ffffff` |

**Accent product:** set `--color-ink` for body text and introduce e.g. `--color-accent` for CTAs/links; update `.btn` and link utilities to use accent. Keep muted/line/canvas for calm fields.

**Dark marketing site (optional):** add a second `@media (prefers-color-scheme: dark)` block or dual token set; only if every surface stays intentional.

Hardcoded greys used sparingly for mockup chrome (`#1c1c1e`, `#e8e8ed`) may stay product-neutral; replace if the new brand needs a different device finish.

## 2. Typography

```css
--font-sans: system-ui, -apple-system, BlinkMacSystemFont, "SF Pro Text",
  "Segoe UI", sans-serif;
```

| Class / role | Guidance |
| --- | --- |
| `.display-title` | Hero: ~2.85–5rem, weight 600, tracking ~-0.035em |
| `.section-title` | Sections: ~2–3.15rem, weight 600, tracking ~-0.03em |
| `.lede` | Intro body: ~1.125rem, muted, max-width ~34rem |
| `.eyebrow` | 0.75rem, uppercase, wide tracking, muted |

**Custom web font:** only if product requires it; self-host (no third-party font CDNs if privacy messaging matters). Update `--font-sans` and preload in `BaseLayout`.

## 3. Radii & elevation

| Token | Default | Use |
| --- | --- | --- |
| `--radius-control` | 0.75rem | Inputs (often overridden to ~0.85rem) |
| `--radius-card` | 1.25rem | Cards / panels |
| `--radius-pill` | 9999px | Buttons, search field, nav chips |
| `--shadow-device` | Soft multi-layer | Phone mockup only |
| `--shadow-soft` | Light ambient | Cards, menus |

## 4. Assets

| Asset | Location | Notes |
| --- | --- | --- |
| Favicon SVG | `public/favicon.svg` | Prefer simple monochrome mark |
| Favicon ICO | `public/favicon.ico` | 32×32 fallback |
| OG image | `public/og.png` (optional) | 1200×630; wire in `BaseLayout` meta |
| Logo | `BrandMark.astro` or `public/logo.svg` | Replace three-bar mark or use `<img>` |

Phone mockup is **CSS-only** by default (no PNG). To use real screenshots, replace `PhoneMockup` screen content with an `<img>` of the app UI inside the bezel.

## 5. Product strings (search-replace list)

- Brand name in `Header`, `Footer`, `BaseLayout` titles
- Domain / `site` in `astro.config.mjs`
- Canonical + Open Graph URLs per page
- Support email (`mailto:` on support, privacy, terms)
- Homepage hero, story beats, trust strip, privacy band
- Help articles, FAQ, support categories (content, not structure)
- Footer privacy line if messaging differs

## 6. Component map (what to edit vs keep)

| Component | Re-theme? | Notes |
| --- | --- | --- |
| `BaseLayout` | Meta defaults | Skip link, font import |
| `Header` / `Footer` | Labels, links | Keep static HTML |
| `BrandMark` | Yes | Product identity |
| `PhoneMockup` | Screen copy + colors | Keep upright + ground shadow |
| `TrustStrip` | Item strings | Keep airy layout |
| `SettlementVisual` / feature visuals | Product-specific | Or replace with feature list |
| `PageIntro` | Usually keep | Shared secondary intro |
| `LegalProse` | Keep shell | Swap legal paragraphs only |
| `HelpSearch` / `SupportForm` | Labels/categories | Keep client-only behavior |

## 7. Vercel / deploy

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "astro",
  "trailingSlash": true
}
```

Monorepo: Vercel **Root Directory** = `web`. Set `site` in `astro.config.mjs` to the production origin.

## 8. Privacy defaults (recommended)

- No analytics, tag managers, or chat widgets
- Support form → `mailto:` draft only
- Help search and FAQ entirely client-side
- Prefer system fonts over remote font loading
