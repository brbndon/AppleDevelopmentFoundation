#!/usr/bin/env bash
set -euo pipefail

cat >&2 <<'EOF'
install-global-instructions.sh is retired and never modifies global Codex instructions.

Initialize an explicitly selected consumer repository instead:
  ./Scripts/init-consumer-guidance.sh --target /path/to/consumer --dry-run
  ./Scripts/init-consumer-guidance.sh --target /path/to/consumer

The replacement refuses an existing AGENTS.md; review and merge the template manually.
EOF
exit 2
