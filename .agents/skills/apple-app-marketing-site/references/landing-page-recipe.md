# Homepage recipe — anatomy, real screenshots, verification

The proven homepage pattern from **Group Trip Money** (`GroupTripMoney/web/`).
Everything is data-driven: structure, tokens, and workflow stay identical
across products; only frontmatter content changes. Read the example repo
before building; keep this reference as the spec.

## Homepage anatomy (section order)

All copy lives in frontmatter `as const` arrays at the top of
`src/pages/index.astro` (`screens`, `benefits`, `testimonialPlaceholders`,
`pricingPoints`, `faqs`) so the next product swap only edits data.

1. **Hero** — eyebrow, `h1.display-title` (two short lines, e.g. "Plan
   together. Split fairly."), `.lede`, CTA trio, CSS device mockup right.
   CTA trio: status pill (`span.btn.btn-coming-soon`, `role="status"`,
   `aria-describedby` → microcopy note), `a.btn.btn-secondary[href="#screens"]`
   "See it in action", text link to `/help/`.
2. **Trust strip** — thin divider + centered row of three privacy/product
   promises that match the app's real behavior.
3. **Screenshot gallery** (`id="screens"`) — exactly 4 real captures
   (Overview, Expenses, Itinerary, Trips). Mobile: horizontal
   `snap-x snap-mandatory` scroll, `w-[72vw] max-w-[16.5rem]` cards; `sm+`:
   `grid sm:grid-cols-2 lg:grid-cols-4`. Each item: `figure` → rounded frame
   (`rounded-[1.4rem] ring-1 ring-black/10 shadow-soft`) → `img`
   (`width="640" height="1392"`, `loading="lazy"`, descriptive `alt`) →
   `figcaption` (bold title + muted caption). Never CSS illustrations here —
   only captures of the real app.
4. **Benefits** — full-bleed `#efeff1` band, `ul.grid sm:grid-cols-2
   lg:grid-cols-3` of 6 cards (`rounded-[1.25rem] border border-line
   bg-surface p-6 shadow-soft`) with uppercase kicker, `h3`, muted body.
   One benefit per real capability.
5. **Clarity / product visual** — two-column grid; calm diagram card
   (flat cards, `shadow-soft`, no stickers/gradients) + copy + short bullet
   list with 5px ink dot markers.
6. **Social proof placeholders** — full-bleed band, `md:grid-cols-3` quote
   cards: `blockquote` in curly quotes + `footer` with 36px initials avatar
   (soft pastel bg), name, context line. Pre-launch: array is
   `testimonialPlaceholders` with a `// PLACEHOLDER` comment — never present
   invented people as real customers.
7. **Pricing** — centered; one card (`max-w-md`, `rounded-[1.5rem]`,
   `p-8 md:p-10`) with app name + "Free" (or real price), border-t bullet
   list with ink dots, full-width coming-soon status pill, microcopy. Only
   state pricing facts the product really has.
8. **FAQ** — `max-w-3xl border-t border-line` list of 5 native
   `details.faq-item` rows (`border-b border-line`, `+`/`−` circle
   indicators), plus a muted line linking `/help/`. Answers describe the
   app's real behavior (accounts? money movement? storage? launch timing).
9. **Final CTA / privacy band** — dark `bg-night rounded-[1.5rem]` panel:
   eyebrow + `h2` ("Your next trip will thank you."), body combining privacy
   posture + launch status (`#a1a1a6`), right column with `a.btn.btn-on-dark`
   → `#screens` and underline link → `/privacy/`.

Section rhythm: page canvas (`#f5f5f7`) alternating with full-bleed
`#efeff1` bands; `py-24 md:py-32` section padding; `site-shell`
(`min(1120px, calc(100% - 2.5rem))`).

## Honesty conventions

- Pre-launch CTAs are **status controls**, not fake buttons: `role="status"`
  + `aria-describedby` + microcopy ("The App Store listing is not available
  yet."). No dead App Store links.
- Social proof is placeholder data until real users exist, marked in code.
- Every claim traces to something the app actually does — read the app
  source first; never invent features, pricing, or privacy posture.

## Capturing real screenshots

Fixture mode first: launch the app with its fixture launch argument (e.g.
`-useFixtureData` seeding an in-memory container) via XcodeBuildMCP
(`build_run_sim` with `launchArgs`). Then drive navigation with a throwaway
Maestro flow in `/tmp` — never the repo's committed `.maestro/` suite:

- Do **not** include `launchApp` in the flow: Maestro restarts the app and
  its `arguments:` map does not reproduce `-useFixtureData` on iOS, so the
  app relaunches without fixtures. Drive the already-running app.
- `assertVisible` only text guaranteed on screen (below-fold assertions
  fail); scroll first (`swipe: {direction: UP}`) for below-fold shots.
- Tap rows/buttons by text; tap tab bars by percentage points
  (Overview 17% / Itinerary 50% / Expenses 83% at 94% height). Toolbar
  buttons like "New trip" exist only on the library screen.
- Maestro terminates the app between runs: one flow covering every screen,
  or relaunch with fixtures before each flow.
- Assert distinctive text on every screen before screenshotting; names on
  `takeScreenshot` map to content.

Downscale to 640px wide into `web/public/screenshots/`:
`sips --resampleWidth 640 shot.png --out web/public/screenshots/name.png`
(optionally `xcrun simctl io booted screenshot /tmp/x.png` for full-res).
Delete unused captures; register each in the `screens` array.

## Verification pass (mandatory)

1. `cd web && npm run build` — all routes emit, no errors.
2. `npm run preview -- --port 4321`; every route and asset returns 200
   (`/`, `/help/`, `/support/`, `/privacy/`, `/terms/`, screenshots, favicon).
3. Browser automation (agent-browser CLI or equivalent): desktop 1440×900 —
   no console/page errors; no horizontal overflow
   (`document.documentElement.scrollWidth <= innerWidth`); **every link**
   clicked (scroll the element into view first — below-fold clicks miss),
   URLs/hashes confirmed; support form: empty submit shows per-field errors
   and focuses the first invalid field, valid submit reveals the toast and a
   correctly built `mailto:` href; help search filters with result count and
   empty state; FAQ `<details>` toggles; skip link (Tab → Enter → `#main`);
   `img` naturalWidth > 0 with non-empty `alt`; heading order h1→h2→h3
   without jumps; `role="status"` pills present.
4. Mobile 390×844: overflow still false (gallery scrolls internally); menu
   toggle sets `aria-expanded` and a nav link closes it.
5. Full-page screenshots at both widths; if the model cannot view images,
   pixel-sample the PNGs (canvas `#f5f5f7`, bands `#efeff1`, night
   `#1d1d1f`, white cards) to confirm sections render.
6. Re-sweep all routes for console errors; commit only intended files
   (revert incidental lockfile churn).

Regenerate screenshots whenever the app UI changes — stale captures are
worse than none.

## Per-project swap table

| What changes | Where |
| --- | --- |
| Product name, domain, support email | `astro.config.mjs`, `BaseLayout` meta, `Header`/`Footer`, `SupportForm` address |
| Screenshots | recapture from THIS app |
| Reviews / social proof | `testimonialPlaceholders` array |
| Hero, benefits, FAQ, pricing copy | frontmatter arrays on `index.astro` |
| Privacy / trust claims | `TrustStrip`, final band — match real posture |
| Phone mockup content | `PhoneMockup.astro` (illustrative) |
| Favicon / brand mark | `public/favicon.*`, `BrandMark.astro` |
