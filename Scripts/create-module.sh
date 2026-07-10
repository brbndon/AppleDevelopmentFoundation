#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 1 && "$1" =~ ^[A-Z][A-Za-z0-9]*$ ]] || { echo "usage: $0 ModuleName" >&2; exit 2; }
root="$(cd "$(dirname "$0")/.." && pwd)"; name="$1"
for path in "$root/Sources/$name" "$root/Tests/${name}Tests"; do [[ ! -e "$path" ]] || { echo "Refusing to overwrite $path" >&2; exit 1; }; done
mkdir -p "$root/Sources/$name" "$root/Tests/${name}Tests"
cat > "$root/Sources/$name/$name.swift" <<EOF
/// Describe the reusable responsibility and platform constraints.
public enum $name { }
EOF
cat > "$root/Tests/${name}Tests/${name}Tests.swift" <<EOF
import $name
import XCTest

final class ${name}Tests: XCTestCase { }
EOF
echo "Created source and test directories. Add Package.swift targets, documentation, and a real API before committing."
