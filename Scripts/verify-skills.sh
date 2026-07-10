#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import json, pathlib, re, sys
root = pathlib.Path('.agents/skills')
manifest = json.loads((root / 'manifest.json').read_text())
names = set()
for item in manifest['skills']:
    name, path = item['name'], root / item['path'] / 'SKILL.md'
    if name in names or not path.is_file(): raise SystemExit(f'invalid skill: {name}')
    names.add(name)
    text = path.read_text()
    if not re.match(r'^---\nname: ' + re.escape(name) + r'\ndescription: .+\n---\n', text, re.S): raise SystemExit(f'invalid frontmatter: {path}')
print(f'validated {len(names)} skills')
PY
