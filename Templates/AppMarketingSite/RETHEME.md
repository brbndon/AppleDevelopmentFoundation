# Re-theme in under an hour

Complete these steps when cloning the marketing site for a new app.

## A. Identity (5–10 min)

- [ ] Product name everywhere (header, footer, titles, meta)
- [ ] Domain in `astro.config.mjs` → `site`
- [ ] Support email on support / privacy / terms
- [ ] Favicons in `public/`
- [ ] Brand mark (`BrandMark.astro` or logo asset)

## B. Colors (5 min)

Edit `@theme` in `src/styles/global.css` (see also `TOKEN_REFERENCE.css`):

| Token | Change for |
| --- | --- |
| `--color-canvas` | Page wash |
| `--color-surface` | Cards |
| `--color-ink` | Text + monochrome CTAs |
| `--color-muted` / `--color-faint` | Secondary text |
| `--color-line` | Borders |
| `--color-night` / `--color-on-night` | Dark privacy band |

For a **brand accent**, add `--color-accent` and point `.btn` / links at it while keeping body text on `--color-ink`.

## C. Typography (2 min)

- Keep system stack for privacy + performance, **or**
- Self-host a font file under `public/fonts/`, `@font-face` in `global.css`, update `--font-sans`
- Avoid Google Fonts / Typekit if the product markets “no third parties”

## D. Homepage content (15–20 min)

- [ ] Hero eyebrow, title, lede
- [ ] App Store CTA (live link vs “Coming soon” pill)
- [ ] Trust strip promises
- [ ] Three story beats
- [ ] Feature / settlement visual
- [ ] Privacy band copy
- [ ] Phone mockup screen labels (trip name, amounts, itinerary — fictional sample data is fine)

## E. Secondary pages (15–25 min)

- [ ] Help categories + article summaries + FAQ answers
- [ ] Support categories + suggestion map in `SupportForm`
- [ ] Privacy policy body (legal review as needed)
- [ ] Terms of service body (legal review as needed)

Do not invent legal promises; only ship reviewed text.

## F. Deploy (5 min)

- [ ] `vercel.json` present; Root Directory = `web` if monorepo
- [ ] `npm run build` clean
- [ ] Spot-check `/`, `/help/`, `/support/`, `/privacy/`, `/terms/`
- [ ] Confirm header/footer render with JS disabled
