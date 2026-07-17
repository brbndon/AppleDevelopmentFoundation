import { defineComponents } from "blume";
import SkipBodyH1 from "./docs-components/SkipBodyH1.astro";

/**
 * MDX component overrides for this docs site.
 *
 * `h1` → {@link SkipBodyH1}: keep body `#` headings in source for authors and
 * agents, but do not render them (Blume already shows frontmatter `title` as H1).
 */
export default defineComponents({
  mdx: {
    h1: SkipBodyH1,
  },
});
