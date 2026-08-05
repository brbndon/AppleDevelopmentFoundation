# Landing page recipe

The proven homepage pattern from the Group Trip Money marketing site.
Structure, tokens, and workflow stay identical across products — only the
frontmatter content changes.

## Homepage anatomy (build in this order)

All copy lives in `as const` arrays at the top of `src/pages/index.astro`
(`screens`, `benefits`, `testimonialPlaceholders`, `pricingPoints`, `faqs`).
The next product is a data swap, not a redesign.

1. **Hero** — eyebrow, display title (two short lines), lede, CTA trio, CSS
   device mockup. CTAs: "Coming soon" status pill (`role="status"` +
   microcopy note), "See it in action" → `#screens`, "Explore Help Center".
2. **Trust strip** — three privacy/product promises that match the real app.
3. **Screenshot gallery** (`id="screens"`) — 4 real captures (Overview,
   Expenses, Itinerary, Trips). Mobile: horizontal snap-scroll, ~72vw cards;
   desktop: 4-column grid. Every image needs `alt`, `width`/`height`, lazy
   loading. Real screenshots only — the CSS mockup belongs in the hero.
4. **Benefits** — 6 cards on a light band: splitting, budgets, settlements,
   itinerary, offline, trust. One card per real capability.
5. **Clarity / product visual** — calm diagram card + copy + short bullets.
6. **Social proof** — quote cards (initials avatar, name, context). Before
   launch these are placeholders, marked in code — never invented customers.
7. **Pricing** — one centered card; only real pricing facts ("Free" works
   for local-first apps). Full-width status pill when pre-launch.
8. **FAQ** — 5 native `<details>` rows + link to the Help Center. Answers
   describe real behavior: accounts, money movement, storage, launch timing.
9. **Final CTA / privacy band** — dark rounded panel: privacy posture +
   launch status, "See it in action" and "Read privacy details" links.

Section rhythm: `py-24 md:py-32`, canvas `#f5f5f7` alternating with full-bleed
`#efeff1` bands, `site-shell` container.

## Honesty rules

- Pre-launch CTAs are status pills with microcopy, never fake App Store
  buttons or dead links.
- Every claim traces to something the app actually does — read the app
  source first.
- Placeholder testimonials are labeled `PLACEHOLDER` in the frontmatter.

## Real screenshots (not mockups)

1. Launch the app with its fixture argument (e.g. `-useFixtureData`) via
   XcodeBuildMCP `build_run_sim`.
2. Drive navigation with a throwaway Maestro flow in `/tmp` — do NOT
   `launchApp` inside it (restarts the app without fixtures). Tap by text;
   tab bars by percentage points (Overview 17% / Itinerary 50% / Expenses
   83% at 94% height). Assert on-screen text before each `takeScreenshot`.
3. Downscale to 640px wide into `web/public/screenshots/`:
   `sips --resampleWidth 640 in.png --out web/public/screenshots/name.png`.
4. Regenerate whenever the app UI changes.

## Ship checklist (additions to CHECKLIST.md)

- [ ] Screenshots are real captures of the current build, 640px wide, with descriptive alt text
- [ ] Every link and form tested at desktop (1440px) and mobile (390px)
- [ ] No horizontal page overflow at 320px and 390px (gallery scrolls internally)
- [ ] Placeholder testimonials marked in code (pre-launch)
- [ ] Full verification pass ran: build → preview → 200s → links/forms → widths → error sweep
