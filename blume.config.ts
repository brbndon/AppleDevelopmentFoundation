import { defineConfig } from "blume";

export default defineConfig({
  title: "Apple Development Foundation",
  description:
    "Agent playbook for Codex skills, XcodeBuildMCP, Maestro, and verification workflows for iOS 17+ and macOS 14+.",
  github: {
    owner: "brbndon",
    repo: "AppleDevelopmentFoundation",
    branch: "main",
  },
  content: {
    root: "docs",
  },
  theme: {
    accent: "blue",
    radius: "md",
    mode: "system",
  },
  ai: {
    llmsTxt: true,
  },
  deployment: {
    output: "static",
    site: "https://brbndon.github.io",
    base: "/AppleDevelopmentFoundation",
  },
});
