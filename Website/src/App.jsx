import { useEffect, useRef, useState } from "react";

const installCopy = `./Scripts/install-skills.sh
./Scripts/verify-skills.sh`;

const bootstrapPromptCopy = `Use the skills from /path/to/AppleDevelopmentFoundation/.agents/skills — start with codex-bootstrap, then apply apple-design-system, swiftui-component-author, and review skills as needed.

Bootstrap a new iOS (or macOS) SwiftUI app using $codex-bootstrap. Use the consumer's design system or create a minimal neutral one. Verify with XcodeBuildMCP.`;

const skills = [
  {
    number: "01",
    tag: "bootstrap",
    name: "codex-bootstrap",
    description: "Bootstrap a new iOS/macOS SwiftUI project in the consumer workspace using these skills.",
    code: "new app · neutral design system",
    accent: true
  },
  {
    number: "02",
    tag: "planning",
    name: "apple-platform-planner",
    description: "Plan a platform feature before implementation.",
    code: "architecture · boundaries"
  },
  {
    number: "03",
    tag: "ui",
    name: "swiftui-component-author",
    description: "Author reusable SwiftUI components with accessibility and platform support.",
    code: "components · previews"
  },
  {
    number: "04",
    tag: "design",
    name: "apple-design-system",
    description: "Add or change reusable design-system tokens and neutral components.",
    code: "tokens · semantic roles"
  },
  {
    number: "05",
    tag: "platform",
    name: "ios-macos-platform-adaptation",
    description: "Adapt behavior between iOS and macOS when shared code diverges.",
    code: "split views · commands"
  },
  {
    number: "06",
    tag: "packages",
    name: "swift-package-module-author",
    description: "Add an independently importable Swift Package module in the active workspace.",
    code: "SPM target · public API"
  },
  {
    number: "07",
    tag: "extraction",
    name: "reusable-code-extractor",
    description: "Extract proven app code into a shared module in the consumer workspace.",
    code: "generalize · migrate"
  },
  {
    number: "08",
    tag: "concurrency",
    name: "swift-concurrency-review",
    description: "Review async/await, actors, and structured concurrency.",
    code: "Sendable · cancellation"
  },
  {
    number: "09",
    tag: "a11y",
    name: "apple-accessibility-review",
    description: "Review reusable UI accessibility across Dynamic Type, VoiceOver, and keyboard.",
    code: "labels · contrast"
  },
  {
    number: "10",
    tag: "security",
    name: "apple-security-privacy-review",
    description: "Review files, logging, permissions, and sensitive data handling.",
    code: "imports · scoped access"
  },
  {
    number: "11",
    tag: "testing",
    name: "swift-testing-verification",
    description: "Verify meaningful changes with focused tests and XcodeBuildMCP.",
    code: "build · test · report"
  },
  {
    number: "12",
    tag: "maintenance",
    name: "codex-skill-maintainer",
    description: "Maintain and update skills in this repository.",
    code: "manifest · verify"
  }
];

const archivedModules = [
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

const mcpWorkflow = [
  ["Session defaults first", "Call session_show_defaults before the first build, run, or test action."],
  ["Discover only when needed", "Use discover_projs when defaults show missing project context — not speculatively."],
  ["Prefer build-and-run", "For simulator run intent, use the combined build-and-run tool instead of separate calls."],
  ["Report context on errors", "Name project, scheme, simulator or device, and the exact failing step."]
];

const mcpTools = [
  ["Project discovery", "discover_projs, scheme listing, build-settings inspection"],
  ["Simulator build/run/test", "build-and-run (preferred), build, test, install, launch"],
  ["UI inspection", "screenshots, view hierarchy, taps/swipes/gestures"],
  ["SwiftPM", "build, run, test Swift Package Manager projects"]
];

function Brand({ footer = false }) {
  return (
    <a className={`brand${footer ? " footer-brand" : ""}`} href="#top" aria-label="Apple Development Foundation home">
      <span className="brand-mark" aria-hidden="true"><i></i><i></i><i></i></span>
      <span>{footer ? <>Apple Development <strong>Foundation</strong></> : <>Apple Development<br /><strong>Foundation</strong></>}</span>
    </a>
  );
}

function SiteHeader({ menuOpen, setMenuOpen, guide }) {
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
          {guide ? (
            <>
              <a href="#top" onClick={closeMenu}>Home</a>
              <a href="#guide-start" onClick={closeMenu}>Start a task</a>
              <a href="#handoff" onClick={closeMenu}>Handoff check</a>
              <a className="nav-cta" href="#guide-template" onClick={closeMenu}>Use the brief <span aria-hidden="true">↗</span></a>
            </>
          ) : (
            <>
              <a href="#modules" onClick={closeMenu}>Skills</a>
              <a href="#apis" onClick={closeMenu}>MCP</a>
              <a href="#agents" onClick={closeMenu}>Agent behavior</a>
              <a href="#guide" onClick={closeMenu}>Agent guide <span aria-hidden="true">↗</span></a>
              <a className="nav-cta" href="#quick-start" onClick={closeMenu}>Start here <span aria-hidden="true">↗</span></a>
            </>
          )}
        </nav>
      </div>
    </header>
  );
}

function Hero() {
  return (
    <section id="top" className="hero section-shell">
      <div className="hero-copy">
        <p className="eyebrow"><span className="pulse" aria-hidden="true"></span> Codex skills · XcodeBuildMCP · iOS 17+ · macOS 14+</p>
        <h1>Reusable skills and commands for Apple-platform coding agents.</h1>
        <p className="hero-lede">
          Install neutral Codex skills for SwiftUI, design systems, concurrency, security, and testing — then
          verify work in the consumer workspace with XcodeBuildMCP. Skills target the app you are building, not
          this repository&apos;s archived package.
        </p>
        <div className="hero-actions">
          <a className="button button-primary" href="#quick-start">Install skills <span aria-hidden="true">↓</span></a>
          <a className="button button-secondary" href="#guide">Agent guide <span aria-hidden="true">→</span></a>
        </div>
        <dl className="hero-facts" aria-label="Repository facts">
          <div><dt>12</dt><dd>reusable skills</dd></div>
          <div><dt>2</dt><dd>Apple platforms</dd></div>
          <div><dt>1</dt><dd>primary MCP</dd></div>
        </dl>
      </div>
      <div className="hero-visual" aria-label="Skills and MCP reference map" role="img">
        <div className="visual-grid" aria-hidden="true"></div>
        <div className="orbit orbit-one" aria-hidden="true"></div>
        <div className="orbit orbit-two" aria-hidden="true"></div>
        <div className="core-node">
          <span className="node-kicker">skills</span>
          <strong>Foundation</strong>
          <span className="node-caption">apply in your workspace</span>
        </div>
        <span className="module-node node-app">codex<br />bootstrap</span>
        <span className="module-node node-design">design<br />system</span>
        <span className="module-node node-file">security</span>
        <span className="module-node node-nav">Xcode<br />BuildMCP</span>
        <span className="module-node node-form">SwiftUI</span>
        <span className="visual-note">consumer workspace<br />composition</span>
      </div>
    </section>
  );
}

function SignalStrip() {
  return (
    <section className="signal-strip" aria-label="Skills and MCP guarantees">
      <div className="shell signal-grid">
        <div><span className="signal-icon" aria-hidden="true">↳</span><span>Neutral reusable skills</span></div>
        <div><span className="signal-icon" aria-hidden="true">⌘</span><span>XcodeBuildMCP verification</span></div>
        <div><span className="signal-icon" aria-hidden="true">◌</span><span>Accessibility by default</span></div>
        <div><span className="signal-icon" aria-hidden="true">▱</span><span>Consumer app owns the domain</span></div>
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
        <h2>Install skills. Point Codex at your consumer workspace.</h2>
        <p>
          Symlink skills into your user scope, verify the manifest, then reference them in any Codex session.
          Start with <code>codex-bootstrap</code> for new iOS or macOS SwiftUI projects. See <code>MCP.md</code> in
          the repository for XcodeBuildMCP setup and copy-paste prompts.
        </p>
      </div>
      <div className="quick-grid">
        <CodeCard
          id="install-code"
          title="Install and verify"
          copyValue={installCopy}
          className="featured-code"
          caption="Run from the repository root. Skills apply to the app or package you are building."
        >
          .<span className="syntax-call">/Scripts/install-skills.sh</span>
.<span className="syntax-call">/Scripts/verify-skills.sh</span></CodeCard>
        <article className="principle-card">
          <span className="card-index">A /</span>
          <h3>Bootstrap in the consumer workspace.</h3>
          <p>Invoke <code>$codex-bootstrap</code> with the skills path, then verify builds with XcodeBuildMCP in the target project — not in this repo&apos;s archived package.</p>
          <a className="text-link" href="#apis">See MCP workflow <span aria-hidden="true">→</span></a>
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
          <p className="eyebrow">02 / skill inventory</p>
          <h2>Twelve focused skills. One consumer workspace.</h2>
        </div>
        <p>Each skill has a narrow job, explicit triggers, and documented exclusions. Invoke with <code>$skill-name</code> or name the skill in your request. Full inventory: <code>.agents/skills/README.md</code>.</p>
      </div>
      <div className="module-grid">
        {skills.map((skill) => (
          <article className={`module-card${skill.accent ? " module-accent" : ""}`} key={skill.number}>
            <span className="module-number">{skill.number}</span><span className="module-tag">{skill.tag}</span>
            <h3>{skill.name}</h3><p>{skill.description}</p>
            <code>{skill.code}</code>
          </article>
        ))}
      </div>
      <div className="section-intro split-intro" style={{ marginTop: "4rem" }}>
        <div>
          <p className="eyebrow">Archived / historical reference</p>
          <h2>Exploratory Swift package modules.</h2>
        </div>
        <p>
          The Swift package under <code>Sources/</code> is archived exploratory work — not the live product.
          See <code>ARCHIVE.md</code> and <code>Documentation/Modules.md</code> for historical module boundaries.
          Do not add this repository as a package dependency unless you are explicitly studying archived code.
        </p>
      </div>
      <div className="module-grid">
        {archivedModules.map((module) => (
          <article className={`module-card${module.accent ? " module-accent" : ""}`} key={`archived-${module.number}`}>
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
          <p className="eyebrow">03 / XcodeBuildMCP</p>
          <h2>Verify in the consumer project. Report context.</h2>
        </div>
        <p>Use XcodeBuildMCP instead of raw <code>xcodebuild</code>, <code>xcrun</code>, or <code>simctl</code> for build, test, simulator, and UI inspection. Full reference: <code>MCP.md</code>.</p>
      </div>
      <div className="api-layout">
        <div className="pattern-list" role="list" aria-label="MCP session workflow">
          {mcpWorkflow.map(([title, description], index) => (
            <article className={`pattern-item${index === 0 ? " active" : ""}`} role="listitem" key={title}>
              <span className="pattern-dot" aria-hidden="true"></span>
              <div><h3>{title}</h3><p>{description}</p></div>
            </article>
          ))}
        </div>
        <CodeCard
          id="api-code"
          title="Bootstrap prompt"
          copyValue={bootstrapPromptCopy}
          className="api-code"
          caption="Replace the skills path with your clone location. Verify with session_show_defaults and a simulator build."
        >
          <span className="syntax-key">Use the skills from</span> <span className="syntax-string">/path/to/AppleDevelopmentFoundation/.agents/skills</span>
<span className="syntax-key">— start with</span> <span className="syntax-call">codex-bootstrap</span><span className="syntax-key">.</span>

<span className="syntax-key">Bootstrap a new SwiftUI app using</span> $<span className="syntax-call">codex-bootstrap</span><span className="syntax-key">.</span>
<span className="syntax-key">Verify with XcodeBuildMCP.</span></CodeCard>
      </div>
      <div className="pattern-list" role="list" aria-label="Representative MCP tools" style={{ marginTop: "2rem" }}>
        {mcpTools.map(([title, description]) => (
          <article className="pattern-item" role="listitem" key={title}>
            <span className="pattern-dot" aria-hidden="true"></span>
            <div><h3>{title}</h3><p>{description}</p></div>
          </article>
        ))}
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
            <h2>What most strongly shapes an agent&apos;s next change?</h2>
          </div>
          <p>Repository instructions, skill triggers, and verification rules act as a behavioral contract. Skills apply to the consumer workspace — not this repo&apos;s archived package unless explicitly asked.</p>
        </div>
        <div className="agent-grid">
          <article className="agent-card agent-card-large"><span>01</span><h3>Repository instructions</h3><p><code>AGENTS.md</code> sets operating rules: Swift 6, native observation, initializer or environment injection, focused views, and no hidden network behavior.</p></article>
          <article className="agent-card"><span>02</span><h3>Skill invocation</h3><p>Use <code>$codex-bootstrap</code> for new projects, then layer design, component, and review skills. Skills target the active workspace, not archived <code>Sources/</code> here.</p></article>
          <article className="agent-card"><span>03</span><h3>Consumer workspace</h3><p>Build, test, and ship in the app or package the user is making. Do not expand this repository&apos;s archived modules without explicit request.</p></article>
          <article className="agent-card"><span>04</span><h3>Platform + accessibility</h3><p>iOS/macOS differences stay platform-specific. SwiftUI work must account for Dynamic Type, VoiceOver, keyboard access, contrast, and Reduce Motion.</p></article>
          <article className="agent-card agent-card-wide"><span>05</span><h3>Verification</h3><p>Run <code>./Scripts/verify-skills.sh</code> for skill changes. Use XcodeBuildMCP in the consumer project for build and test evidence. Apply review skills before shipping shared components.</p></article>
        </div>
      </div>
    </section>
  );
}

function Ownership() {
  return (
    <section id="ownership" className="section-shell section-block ownership-section">
      <div className="section-intro narrow-intro">
        <p className="eyebrow">05 / live vs archived</p>
        <h2>Skills and MCP are the product. The package is historical.</h2>
        <p>This repository ships reusable agent skills and command references. The exploratory Swift package is preserved for history — see <code>ARCHIVE.md</code>.</p>
      </div>
      <div className="ownership-grid">
        <div className="ownership-column owns"><div className="ownership-heading"><span aria-hidden="true">+</span><h3>Live product</h3></div><ul><li><code>.agents/skills/</code> — reusable Codex skills</li><li><code>MCP.md</code> — XcodeBuildMCP and prompts</li><li><code>README.md</code> and <code>AGENTS.md</code> — entry points</li><li><code>Documentation/SkillAuthoringGuide.md</code> — skill maintenance</li><li>Verification: <code>verify-skills.sh</code>, <code>test-install-skills.sh</code></li></ul></div>
        <div className="ownership-column app-owns"><div className="ownership-heading"><span aria-hidden="true">→</span><h3>Archived reference</h3></div><ul><li><code>Sources/</code>, <code>Tests/</code>, <code>Package.swift</code></li><li>Package-oriented <code>Documentation/</code> guides</li><li><code>Apps/</code>, <code>Examples/</code>, this website&apos;s package section</li><li><code>Scripts/verify.sh</code> — only when working on archived code</li><li>Do not add as a dependency without explicit intent</li></ul></div>
      </div>
    </section>
  );
}

function DocumentationLinks() {
  return (
    <section className="section-shell section-block docs-section">
      <div className="docs-card">
        <div><p className="eyebrow">Keep going</p><h2>Repository entry points.</h2><p>These files are authoritative in the clone. Open them in your editor or on GitHub.</p></div>
        <div className="docs-links">
          <span>README.md — install and skill inventory</span>
          <span>MCP.md — XcodeBuildMCP setup and prompts</span>
          <span>.agents/skills/ — live skill sources</span>
          <span>ARCHIVE.md — archived package inventory</span>
          <span>Documentation/SkillAuthoringGuide.md — maintain skills</span>
          <a href="#guide">Agent guide <span aria-hidden="true">↗</span></a>
        </div>
      </div>
    </section>
  );
}

function GuideCard({ label, title, children, className = "" }) {
  return (
    <article className={`guide-card ${className}`}>
      <span className="guide-card-label">{label}</span>
      <h3>{title}</h3>
      {children}
    </article>
  );
}

function AgentGuide() {
  const promptCopy = "Goal:\n[Describe the user-visible outcome]\n\nContext:\n[Point to the relevant skill, screen, or existing pattern in the consumer workspace]\n\nConstraints:\n[Name boundaries, platforms, accessibility, or security rules]\n\nAcceptance:\n[Describe the behavior and tests that prove it]\n\nBefore editing, inspect AGENTS.md and affected code in the consumer workspace. Then propose the smallest plan, implement it, run verification with XcodeBuildMCP or focused tests, and report changes, evidence, and remaining risks.";

  return (
    <div className="guide-page">
      <section id="guide" className="guide-hero section-shell">
        <div className="guide-hero-copy">
          <a className="back-link" href="#top">← Back to home</a>
          <p className="eyebrow"><span className="pulse" aria-hidden="true"></span> A field guide for systems thinkers</p>
          <h1>Hand the work to an agent. Keep the shape of the system.</h1>
          <p className="hero-lede">You do not need to read every line of Swift to direct a good change. You need a clear outcome, a map of the boundaries, and a way to tell whether the agent has earned your trust.</p>
          <div className="guide-hero-note"><span aria-hidden="true">↳</span><p><strong>Your role:</strong> choose the outcome, constraints, and tradeoffs. The agent&apos;s role is to inspect, implement, verify, and report.</p></div>
        </div>
        <div className="handoff-visual" aria-label="A handoff between a human and a coding agent" role="img">
          <div className="handoff-line" aria-hidden="true"><span></span><span></span><span></span></div>
          <div className="handoff-node human-node"><span className="node-kicker">you decide</span><strong>Human</strong><span>outcome<br />constraints</span></div>
          <div className="handoff-node agent-node"><span className="node-kicker">agent does</span><strong>Agent</strong><span>inspect<br />build · verify</span></div>
          <p className="handoff-caption">A useful handoff<br />is a small system.</p>
        </div>
      </section>

      <section className="guide-signal" aria-label="Agent guide principle">
        <div className="shell"><span className="guide-signal-mark" aria-hidden="true">01</span><p>Do not start with “write some code.” Start with “here is what should be true when we are done.”</p></div>
      </section>

      <section id="guide-start" className="section-shell section-block guide-section">
        <div className="section-intro split-intro">
          <div><p className="eyebrow">01 / start with the system</p><h2>Give the agent a map before you give it a mission.</h2></div>
          <p>Agents are fast at local decisions and unreliable when they must invent the surrounding system. Point them at <code>AGENTS.md</code>, the relevant skill, and the boundary that must not move in the consumer workspace.</p>
        </div>
        <div className="guide-grid guide-grid-three">
          <GuideCard label="Name the outcome" title="What should a person be able to do?"><p>Describe the behavior in user terms. “A person can import a photo and see a useful error when the file is too large” is more useful than “add an importer service.”</p></GuideCard>
          <GuideCard label="Name the boundary" title="Where does the decision belong?"><p>Say what shared skills or modules own versus what the host app owns. This keeps an agent from turning reusable guidance into product-specific framework code.</p></GuideCard>
          <GuideCard label="Name the proof" title="How will we know it works?"><p>Ask for focused tests, an XcodeBuildMCP build or test run, and a short handoff that names what changed, what was checked, and what remains manual.</p></GuideCard>
        </div>
      </section>

      <section className="guide-section guide-dark">
        <div className="shell section-block">
          <div className="section-intro split-intro light-intro"><div><p className="eyebrow">02 / use a reliable loop</p><h2>Five moves are enough for most tasks.</h2></div><p>Keep the agent moving through a visible loop. If it skips a move, ask it to return there instead of adding more instructions.</p></div>
          <div className="loop-grid">
            <div className="loop-item"><span>01</span><h3>Inspect</h3><p>Read instructions, nearby code, tests, and boundaries before proposing an edit.</p></div>
            <div className="loop-item"><span>02</span><h3>Plan</h3><p>State the smallest change, affected surfaces, risks, and how it will be verified.</p></div>
            <div className="loop-item"><span>03</span><h3>Change</h3><p>Implement only the agreed behavior. Preserve existing APIs unless a break is explicitly needed.</p></div>
            <div className="loop-item"><span>04</span><h3>Verify</h3><p>Run the narrowest relevant tests first, then XcodeBuildMCP or repository checks required by the change.</p></div>
            <div className="loop-item loop-item-accent"><span>05</span><h3>Report</h3><p>Return a plain-language summary, evidence, limitations, and the next decision for the human.</p></div>
          </div>
        </div>
      </section>

      <section id="handoff" className="section-shell section-block guide-section">
        <div className="section-intro narrow-intro"><p className="eyebrow">03 / read the handoff</p><h2>Review the shape of the work, not every character.</h2><p>A strong handoff lets you decide whether to continue without becoming the agent&apos;s debugger.</p></div>
        <div className="handoff-checklist">
          <div className="checklist-column"><h3><span aria-hidden="true">✓</span> Trust signals</h3><ul><li>The agent names the files and behavior it changed.</li><li>It explains why each change belongs in the right layer or skill scope.</li><li>Tests or checks are named with their result.</li><li>It calls out anything it could not verify.</li><li>It distinguishes implemented work from suggested next steps.</li></ul></div>
          <div className="checklist-column caution-column"><h3><span aria-hidden="true">!</span> Pause signals</h3><ul><li>It changed boundaries “for convenience.”</li><li>It added a dependency without a clear reason.</li><li>It says “it should work” without evidence.</li><li>It hides a failing test behind a workaround.</li><li>It cannot explain what the host app still owns.</li></ul></div>
        </div>
      </section>

      <section id="guide-template" className="section-shell section-block guide-template-section">
        <div className="template-card">
          <div className="template-intro"><p className="eyebrow">04 / copy the brief</p><h2>Give the agent enough shape to be useful.</h2><p>Replace the bracketed parts, then let the agent ask questions after it has inspected the repository.</p></div>
          <div className="guide-prompt"><div className="prompt-topline"><span>agent task brief</span><CopyButton targetId="guide-prompt-copy" copyValue={promptCopy} /></div><pre id="guide-prompt-copy"><code><span className="prompt-label">Goal:</span>
[Describe the user-visible outcome]

<span className="prompt-label">Context:</span>
[Point to the relevant skill, screen, or existing pattern in the consumer workspace]

<span className="prompt-label">Constraints:</span>
[Name boundaries, platforms, accessibility, or security rules]

<span className="prompt-label">Acceptance:</span>
[Describe the behavior and tests that prove it]

<span className="prompt-instruction">Before editing, inspect AGENTS.md and affected code in the consumer workspace.
Then propose the smallest plan, implement it, run verification with XcodeBuildMCP or focused tests,
and report changes, evidence, and remaining risks.</span></code></pre></div>
        </div>
      </section>
    </div>
  );
}

function Footer() {
  return (
    <footer className="site-footer">
      <div className="shell footer-inner">
        <div><Brand footer /><p>Reusable Codex skills and MCP references for Apple-platform agents.</p></div>
        <p className="footer-meta">Swift 6 · iOS 17+ · macOS 14+<br />Skills apply in your consumer workspace.</p>
      </div>
    </footer>
  );
}

export default function App() {
  const [menuOpen, setMenuOpen] = useState(false);
  const [guide, setGuide] = useState(() => window.location.hash === "#guide");

  useEffect(() => {
    const updatePage = () => {
      setGuide(window.location.hash === "#guide");
      setMenuOpen(false);
      window.scrollTo({ top: 0, behavior: "auto" });
    };
    window.addEventListener("hashchange", updatePage);
    return () => window.removeEventListener("hashchange", updatePage);
  }, []);

  return (
    <div className="min-h-screen">
      <a className="skip-link" href="#main-content">Skip to content</a>
      <SiteHeader menuOpen={menuOpen} setMenuOpen={setMenuOpen} guide={guide} />
      <main id="main-content">
        {guide ? <AgentGuide /> : <><Hero /><SignalStrip /><QuickStart /><ModulesSection /><ApiPatterns /><AgentBehavior /><Ownership /><DocumentationLinks /></>}
      </main>
      <Footer />
    </div>
  );
}
