# Ship checklist

## Content

- [ ] All marketing claims match the real app
- [ ] Privacy / terms effective date and body reviewed
- [ ] Support email works
- [ ] Help deep links (`#ids`) match support suggestion slugs
- [ ] No placeholder lorem
- [ ] Screenshots are real captures of the current build at platform-native framing (640px-wide portrait for iOS; native window aspect for macOS), with descriptive alt text
- [ ] Pre-launch social proof hidden, or placeholders visibly labeled on the page (code-only marking is not enough)
- [ ] Every link and form tested at desktop (1440px) and mobile (390px)
- [ ] No horizontal page overflow at 320px and 390px (gallery scrolls internally)

## Visual / UX

- [ ] Hero readable at 320px and 1280px
- [ ] Phone mockup does not overflow or collide with CTAs
- [ ] Trust strip stacks cleanly on mobile
- [ ] Forms usable on mobile (full-width fields)
- [ ] Focus rings visible on keyboard navigation
- [ ] “Coming soon” (if used) looks intentional, not disabled-faded

## Technical

- [ ] `npm run build` succeeds
- [ ] No third-party scripts in built HTML
- [ ] Header/footer present with JavaScript disabled
- [ ] Canonical + OG tags correct per page
- [ ] Favicon loads
- [ ] Vercel root / trailing slash config correct

## Privacy

- [ ] No analytics
- [ ] Support is client mailto only (or explicitly documented alternative)
- [ ] Fonts self-hosted or system only
