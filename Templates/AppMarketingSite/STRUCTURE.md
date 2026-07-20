# Structure

## Stack

- Astro (static)
- Tailwind CSS v4 (`@tailwindcss/vite`)
- Node 22.12+

## Commands

```bash
cd web
npm install
npm run dev
npm run build
npm run preview
```

## Source layout

```text
src/
├── layouts/BaseLayout.astro   # meta, skip link, header, footer, global CSS
├── components/
│   ├── BrandMark.astro
│   ├── Header.astro           # static nav + mobile menu script
│   ├── Footer.astro
│   ├── PageIntro.astro        # secondary page hero
│   ├── LegalProse.astro
│   ├── PhoneMockup.astro
│   ├── TrustStrip.astro
│   ├── SettlementVisual.astro # optional product visual
│   ├── HelpSearch.astro
│   └── SupportForm.astro
├── pages/
│   ├── index.astro
│   ├── help/index.astro
│   ├── support/index.astro
│   ├── privacy/index.astro
│   └── terms/index.astro
└── styles/global.css          # tokens + component classes
```

## Routes

| Path | Purpose |
| --- | --- |
| `/` | Marketing homepage |
| `/help/` | Help center + FAQ |
| `/support/` | Mailto support form |
| `/privacy/` | Privacy policy |
| `/terms/` | Terms of service |

Use `trailingSlash: "always"` and directory build format so URLs stay `/help/`-style.

## Page composition

**Home:** Hero + device → Trust → Story beats → Feature visual → Privacy band  

**Help:** PageIntro + search → category grids → FAQ details  

**Support:** PageIntro → form + related answers card  

**Legal:** PageIntro → LegalProse sections  

## JS surface

- All pages: mobile menu only (in Header)
- Help: search filter
- Support: validation + mailto draft
- Prefer `<details>` for FAQ (zero JS)
