import { useEffect, useRef, useState } from "react";

const installCopy = `dependencies: [
    .package(path: "../AppleDevelopmentFoundation")
]

targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(
                name: "FormKit",
                package: "AppleDevelopmentFoundation"
            )
        ]
    )
]`;

const apiCopy = `import AppFoundation
import FormKit

let clock: any AppClock =
    FixedAppClock(testDate)

struct ProfileForm: View {
    @Binding var name: String

    var body: some View {
        ValidatedTextField(
            "Display name",
            text: $name,
            validation: .init([
                .required(),
                .maximumLength(80)
            ])
        )
    }
}`;

const modules = [
  {
    number: "01",
    tag: "determinism",
    name: "AppFoundation",
    description: "Clocks, identifiers, environment flags, and generic errors that make previews and tests predictable.",
    code: "AppClock · IdentifierProviding",
    accent: true
  },
  {
    number: "02",
    tag: "ui primitives",
    name: "DesignSystem",
    description: "Semantic tokens and neutral SwiftUI components without app branding or screen-level decisions.",
    code: "FoundationCard · FoundationButton"
  },
  {
    number: "03",
    tag: "input",
    name: "FormKit",
    description: "Validation rules, locale-aware decimal input, and main-actor form state.",
    code: "FieldValidation · FormState"
  },
  {
    number: "04",
    tag: "guided flows",
    name: "OnboardingKit",
    description: "Inclusion, validation, progression, cancellation, and restoration for app-owned flow content.",
    code: "FlowStep · FlowProgression"
  },
  {
    number: "05",
    tag: "navigation",
    name: "NavigationKit",
    description: "Typed value paths and one sheet route, with Codable restoration when the route allows it.",
    code: "NavigationRouter<Route>"
  },
  {
    number: "06",
    tag: "persistence",
    name: "PersistenceKit",
    description: "SwiftData container creation and store reset, while the app owns schemas and migration plans.",
    code: "PersistenceContainerFactory"
  },
  {
    number: "07",
    tag: "file safety",
    name: "FileKit",
    description: "Regular-file validation, safe filenames, scoped access, and atomic writes that refuse accidental replacement.",
    code: "FileImportPolicy · AtomicFileWriter"
  },
  {
    number: "08",
    tag: "media",
    name: "MediaKit",
    description: "Validated image-data loading and an actor-isolated cache with no silent resizing or metadata stripping.",
    code: "ImageLoader · ImageDataCache"
  },
  {
    number: "09",
    tag: "feedback",
    name: "FeedbackKit",
    description: "Main-actor message state and an accessible banner for app-owned user feedback.",
    code: "FeedbackCenter · FeedbackBanner"
  },
  {
    number: "10",
    tag: "shell + logging",
    name: "LoggingKit + AppShellKit",
    description: "Literal-only privacy-conscious events, plus adaptive split shell structure and settings triggers.",
    code: "FoundationLogger · AdaptiveAppShell"
  }
];

const patterns = [
  ["Inject time and IDs", "Use system providers in production and fixed providers in tests or previews."],
  ["Compose validation", "Pass rules into a field; keep focus, domain meaning, and submission ownership in the app."],
  ["Route values, not screens", "Let the app define route types and destinations while the router owns path mechanics."],
  ["Validate before reading", "File and image modules check type, size, regular-file status, and cancellation before I/O."]
];

function Brand({ footer = false }) {
  return (
    <a className={`brand${footer ? " footer-brand" : ""}`} href="#top" aria-label="Apple Development Foundation home">
      <span className="brand-mark" aria-hidden="true"><i></i><i></i><i></i></span>
      <span>{footer ? <>Apple Development <strong>Foundation</strong></> : <>Apple Development<br /><strong>Foundation</strong></>}</span>
    </a>
  );
}

function SiteHeader({ menuOpen, setMenuOpen }) {
  const closeMenu = () => setMenuOpen(false);

  return (
    <header className="site-header">
      <div className="shell header-inner">
        <Brand />
        <button
          className="menu-toggle"
          type="button"
          aria-expanded={menuOpen}
          aria-controls="site-nav"
          onClick={() => setMenuOpen((open) => !open)}
        >
          Menu
        </button>
        <nav id="site-nav" className={`site-nav${menuOpen ? " is-open" : ""}`} aria-label="Primary navigation">
          <a href="#modules" onClick={closeMenu}>Modules</a>
          <a href="#apis" onClick={closeMenu}>API patterns</a>
          <a href="#agents" onClick={closeMenu}>Agent behavior</a>
          <a className="nav-cta" href="#quick-start" onClick={closeMenu}>Start here <span aria-hidden="true">↗</span></a>
        </nav>
      </div>
    </header>
  );
}

function Hero() {
  return (
    <section id="top" className="hero section-shell">
      <div className="hero-copy">
        <p className="eyebrow"><span className="pulse" aria-hidden="true"></span> Swift 6 · local package · no third-party dependencies</p>
        <h1>A calmer base layer for Apple-platform coding agents.</h1>
        <p className="hero-lede">
          Small, independently selectable Swift foundations for iOS 17+ and macOS 14+, with explicit
          boundaries that help an agent make useful changes without inventing an application framework.
        </p>
        <div className="hero-actions">
          <a className="button button-primary" href="#quick-start">Explore the package <span aria-hidden="true">↓</span></a>
          <a className="button button-secondary" href="#agents">How agents use it <span aria-hidden="true">→</span></a>
        </div>
        <dl className="hero-facts" aria-label="Package facts">
          <div><dt>10</dt><dd>focused modules</dd></div>
          <div><dt>2</dt><dd>Apple platforms</dd></div>
          <div><dt>0</dt><dd>third-party deps</dd></div>
        </dl>
      </div>
      <div className="hero-visual" aria-label="A map of the foundation package" role="img">
        <div className="visual-grid" aria-hidden="true"></div>
        <div className="orbit orbit-one" aria-hidden="true"></div>
        <div className="orbit orbit-two" aria-hidden="true"></div>
        <div className="core-node">
          <span className="node-kicker">package</span>
          <strong>Foundation</strong>
          <span className="node-caption">compose only what you need</span>
        </div>
        <span className="module-node node-app">App<br />Foundation</span>
        <span className="module-node node-design">Design<br />System</span>
        <span className="module-node node-file">FileKit</span>
        <span className="module-node node-nav">Navigation<br />Kit</span>
        <span className="module-node node-form">FormKit</span>
        <span className="visual-note">application-owned<br />composition</span>
      </div>
    </section>
  );
}

function SignalStrip() {
  return (
    <section className="signal-strip" aria-label="Foundation guarantees">
      <div className="shell signal-grid">
        <div><span className="signal-icon" aria-hidden="true">↳</span><span>Native APIs first</span></div>
        <div><span className="signal-icon" aria-hidden="true">⌘</span><span>Structured concurrency</span></div>
        <div><span className="signal-icon" aria-hidden="true">◌</span><span>Accessibility by default</span></div>
        <div><span className="signal-icon" aria-hidden="true">▱</span><span>Host app owns the domain</span></div>
      </div>
    </section>
  );
}

function CopyButton({ targetId, copyValue }) {
  const [label, setLabel] = useState("Copy");
  const resetTimer = useRef(null);

  useEffect(() => () => window.clearTimeout(resetTimer.current), []);

  async function copyCode() {
    const target = document.getElementById(targetId);
    if (!target) return;

    try {
      await navigator.clipboard.writeText(copyValue);
      setLabel("Copied");
    } catch {
      const selection = window.getSelection();
      const range = document.createRange();
      range.selectNodeContents(target);
      selection?.removeAllRanges();
      selection?.addRange(range);
      setLabel("Select + copy");
    }

    window.clearTimeout(resetTimer.current);
    resetTimer.current = window.setTimeout(() => setLabel("Copy"), 1800);
  }

  return (
    <button className="copy-button" type="button" data-copy-target={targetId} onClick={copyCode} aria-live="polite">
      {label}
    </button>
  );
}

function CodeCard({ id, title, copyValue, className = "", children, caption }) {
  return (
    <article className={`code-card ${className}`}>
      <div className="card-topline"><span>{title}</span><CopyButton targetId={id} copyValue={copyValue} /></div>
      <pre id={id}><code>{children}</code></pre>
      <p className="code-caption">{caption}</p>
    </article>
  );
}

function QuickStart() {
  return (
    <section id="quick-start" className="section-shell section-block quick-start">
      <div className="section-intro narrow-intro">
        <p className="eyebrow">01 / quick start</p>
        <h2>Bring in one foundation. Keep the rest of your app yours.</h2>
        <p>
          Add the repository as a local Swift package or Git reference, then select only the products the
          app actually uses. The package supplies seams and primitives; your app keeps its models, branding,
          routing destinations, and persistence decisions.
        </p>
      </div>
      <div className="quick-grid">
        <CodeCard
          id="install-code"
          title="Package.swift"
          copyValue={installCopy}
          className="featured-code"
          caption="Select products by responsibility. Nothing is re-exported for convenience."
        >
          <span className="syntax-key">dependencies</span>: [
    .<span className="syntax-call">package</span>(path: <span className="syntax-string">"../AppleDevelopmentFoundation"</span>)
]

<span className="syntax-key">targets</span>: [
    .<span className="syntax-call">target</span>(
        name: <span className="syntax-string">"MyApp"</span>,
        dependencies: [
            .<span className="syntax-call">product</span>(
                name: <span className="syntax-string">"FormKit"</span>,
                package: <span className="syntax-string">"AppleDevelopmentFoundation"</span>
            )
        ]
    )
]</CodeCard>
        <article className="principle-card">
          <span className="card-index">A /</span>
          <h3>Make the app the composition root.</h3>
          <p>Inject clocks, identifiers, services, and environment data at the application shell. Let modules stay generic and testable.</p>
          <a className="text-link" href="#apis">See the patterns <span aria-hidden="true">→</span></a>
        </article>
      </div>
    </section>
  );
}

function ModulesSection() {
  return (
    <section id="modules" className="section-shell section-block modules-section">
      <div className="section-intro split-intro">
        <div>
          <p className="eyebrow">02 / the module map</p>
          <h2>Ten small tools. One clear direction.</h2>
        </div>
        <p>Each module has a narrow job, an independently importable surface, and a documented non-goal. The dependency graph only moves downward.</p>
      </div>
      <div className="module-grid">
        {modules.map((module) => (
          <article className={`module-card${module.accent ? " module-accent" : ""}`} key={module.number}>
            <span className="module-number">{module.number}</span><span className="module-tag">{module.tag}</span>
            <h3>{module.name}</h3><p>{module.description}</p>
            <code>{module.code}</code>
          </article>
        ))}
      </div>
    </section>
  );
}

function ApiPatterns() {
  return (
    <section id="apis" className="section-shell section-block api-section">
      <div className="section-intro split-intro">
        <div>
          <p className="eyebrow">03 / API patterns</p>
          <h2>Use the seam. Own the decision.</h2>
        </div>
        <p>The public APIs are deliberately additive and small. These patterns show how a host app composes them without handing its domain to the package.</p>
      </div>
      <div className="api-layout">
        <div className="pattern-list" role="list" aria-label="API usage patterns">
          {patterns.map(([title, description], index) => (
            <article className={`pattern-item${index === 0 ? " active" : ""}`} role="listitem" key={title}>
              <span className="pattern-dot" aria-hidden="true"></span>
              <div><h3>{title}</h3><p>{description}</p></div>
            </article>
          ))}
        </div>
        <CodeCard
          id="api-code"
          title="SwiftUI + deterministic tests"
          copyValue={apiCopy}
          className="api-code"
          caption="The app owns state and injection; the module owns reusable behavior."
        >
          <span className="syntax-key">import</span> AppFoundation
<span className="syntax-key">import</span> FormKit

<span className="syntax-key">let</span> clock: <span className="syntax-type">any</span> AppClock =
    <span className="syntax-type">FixedAppClock</span>(<span className="syntax-call">testDate</span>)

<span className="syntax-key">struct</span> ProfileForm: <span className="syntax-type">View</span> &#123;
    @<span className="syntax-type">Binding</span> <span className="syntax-key">var</span> name: String

    <span className="syntax-key">var</span> body: <span className="syntax-key">some</span> <span className="syntax-type">View</span> &#123;
        <span className="syntax-type">ValidatedTextField</span>(
            <span className="syntax-string">"Display name"</span>,
            text: $name,
            validation: .<span className="syntax-call">init</span>([
                .<span className="syntax-call">required</span>(),
                .<span className="syntax-call">maximumLength</span>(<span className="syntax-number">80</span>)
            ])
        )
    &#125;
&#125;</CodeCard>
      </div>
    </section>
  );
}

function AgentBehavior() {
  return (
    <section id="agents" className="agent-section">
      <div className="shell section-block">
        <div className="section-intro split-intro light-intro">
          <div>
            <p className="eyebrow">04 / agent behavior</p>
            <h2>What most strongly shapes an agent’s next change?</h2>
          </div>
          <p>The framework is more than a bag of APIs. Repository instructions, boundaries, and verification rules act as a behavioral contract around every implementation.</p>
        </div>
        <div className="agent-grid">
          <article className="agent-card agent-card-large"><span>01</span><h3>Repository instructions</h3><p>The local <code>AGENTS.md</code> sets the operating rules: Swift 6, native observation, initializer or environment injection, focused views, and no hidden network behavior.</p></article>
          <article className="agent-card"><span>02</span><h3>Dependency direction</h3><p><code>Package.swift</code> and the module graph decide where a new type belongs. Circular or convenience dependencies are out.</p></article>
          <article className="agent-card"><span>03</span><h3>Reusable API bar</h3><p>New public surface needs two plausible applications, neutral terminology, DocC comments, platform constraints, and focused tests.</p></article>
          <article className="agent-card"><span>04</span><h3>Platform + accessibility</h3><p>iOS/macOS differences stay platform-specific. SwiftUI work must account for Dynamic Type, VoiceOver, keyboard access, contrast, and Reduce Motion.</p></article>
          <article className="agent-card agent-card-wide"><span>05</span><h3>Security and verification</h3><p>Validate imports before reads, refuse unsafe file writes, avoid sensitive logs, run focused tests, and use repository verification before handoff. Correctness includes the boundary, not just the code path.</p></article>
        </div>
      </div>
    </section>
  );
}

function Ownership() {
  return (
    <section id="ownership" className="section-shell section-block ownership-section">
      <div className="section-intro narrow-intro">
        <p className="eyebrow">05 / the boundary</p>
        <h2>The foundation stops where product decisions begin.</h2>
        <p>That line is intentional. It keeps reusable code easy to audit and gives coding agents a safe place to stop guessing.</p>
      </div>
      <div className="ownership-grid">
        <div className="ownership-column owns"><div className="ownership-heading"><span aria-hidden="true">+</span><h3>The package owns</h3></div><ul><li>Deterministic seams and generic state</li><li>Semantic UI primitives</li><li>Validated local file and image operations</li><li>Typed path mechanics and flow progression</li><li>Privacy-safe, testable behavior</li></ul></div>
        <div className="ownership-column app-owns"><div className="ownership-heading"><span aria-hidden="true">→</span><h3>The host app owns</h3></div><ul><li>Domain models and SwiftData schemas</li><li>Branding, screens, and app content</li><li>Deep-link parsing and destinations</li><li>Entitlements and file importer panels</li><li>Migration, backup, and product error mapping</li></ul></div>
      </div>
    </section>
  );
}

function DocumentationLinks() {
  return (
    <section className="section-shell section-block docs-section">
      <div className="docs-card">
        <div><p className="eyebrow">Keep going</p><h2>Read the source of truth.</h2><p>The website is the map; the repository documents the decisions behind it.</p></div>
        <div className="docs-links">
          <a href="#modules">Module API guide <span aria-hidden="true">↗</span></a>
          <a href="#ownership">Architecture <span aria-hidden="true">↗</span></a>
          <a href="#quick-start">Integration guide <span aria-hidden="true">↗</span></a>
          <a href="#modules">Accessibility guide <span aria-hidden="true">↗</span></a>
          <a href="#agents">Security + privacy <span aria-hidden="true">↗</span></a>
          <a href="#top">Repository README <span aria-hidden="true">↗</span></a>
        </div>
      </div>
    </section>
  );
}

function Footer() {
  return (
    <footer className="site-footer">
      <div className="shell footer-inner">
        <div><Brand footer /><p>Small foundations for thoughtful Apple-platform software.</p></div>
        <p className="footer-meta">Swift 6 · iOS 17+ · macOS 14+<br />Built to be composed, tested, and extended carefully.</p>
      </div>
    </footer>
  );
}

export default function App() {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <div className="min-h-screen">
      <a className="skip-link" href="#main-content">Skip to content</a>
      <SiteHeader menuOpen={menuOpen} setMenuOpen={setMenuOpen} />
      <main id="main-content">
        <Hero />
        <SignalStrip />
        <QuickStart />
        <ModulesSection />
        <ApiPatterns />
        <AgentBehavior />
        <Ownership />
        <DocumentationLinks />
      </main>
      <Footer />
    </div>
  );
}
