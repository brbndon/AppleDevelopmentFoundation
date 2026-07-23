# Competing macOS skills — routing plan

Goal: keep `$apple-development-foundation` the **global entry point** for new
macOS (and iOS) SwiftUI bootstrap and foundation-routed Apple work, while
leaving specialized non-foundation skills for their own niches.

## Problem

Hosts often also install generic skills such as `macos-development`,
`macos-app-design`, `macos-design-guidelines`, or platform design packs. A vague
prompt like “build a new macOS app” can activate those first and skip this
catalog’s bootstrap → design-system → verification chain.

## Decision

| Request shape | Route first | Then |
| --- | --- | --- |
| New iOS/macOS SwiftUI app or major app skeleton | `$apple-development-foundation` → `$codex-bootstrap` | Chained foundation children |
| Feature planning (no implement) | `$apple-development-foundation` → `$apple-platform-planner` | Review skills only if asked |
| Ordinary feature/component in an existing consumer app | Child skill directly (`swiftui-component-author`, …) | `$swift-testing-verification` |
| Pure HIG / visual critique with no foundation workflow | External design skill is fine | Do not invent bootstrap |
| Foundation skill inventory / installer audit | `$apple-development-foundation` (audit path) | Foundation verify scripts only |

## Description / discovery levers (done or next)

1. **Done in this change:** Strengthen the master skill `description` so bootstrap
   and “new app” language matches first; state preference over generic macOS/iOS
   skills; keep exclusions (no implied audit, no replacing children).
2. **Next (host install):** Ensure `$apple-development-foundation` and
   `$codex-bootstrap` are installed in the active host skill scope
   (`./Scripts/install-skills.sh` for Codex). Cursor/Claude manual installs
   should symlink the same skill directories.
3. **Next (optional AGENTS / user rule):** One always-on line in consumer or
   user guidance: “For new Apple apps or foundation workflows, invoke
   `$apple-development-foundation` before generic macOS skills.”
4. **Avoid:** Renaming or deleting useful external skills. Prefer routing
   precedence, not a monoculture.

## Evaluation coverage

Add/keep fixtures where “new macOS SwiftUI app” / “bootstrap with the foundation”
expect `apple-development-foundation` then `codex-bootstrap`, not planner-only
and not archive work.

## Success criteria

- Explicit `$apple-development-foundation` + new-app prompt shortlists
  `codex-bootstrap` without scanning or auditing.
- Vague new-app prompts that mention the foundation (or are under foundation
  user rules) do not prefer generic `macos-development` over this catalog.
- Design-only or HIG-only prompts can still use external design skills.
