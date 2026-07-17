#!/usr/bin/env bash
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd -P)"
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
    if 'Inputs:' not in text or 'Output:' not in text: raise SystemExit(f'missing semantic contract: {path}')
    if '[TODO' in text: raise SystemExit(f'unresolved TODO: {path}')
    for link in re.findall(r'\[[^]]+\]\(([^)#]+)', text):
        if '://' not in link and not (path.parent / link).is_file():
            raise SystemExit(f'broken skill reference: {path}: {link}')
skill_paths = {path.parent.name for path in root.glob('*/SKILL.md')}
if skill_paths != {item['path'] for item in manifest['skills']}:
    raise SystemExit('manifest and skill directories differ')
print(f'validated {len(names)} skills')
PY
