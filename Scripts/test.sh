#!/usr/bin/env bash
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd -P)"
command -v swift >/dev/null 2>&1 || { echo "Required command is unavailable: swift" >&2; exit 1; }
swift test
