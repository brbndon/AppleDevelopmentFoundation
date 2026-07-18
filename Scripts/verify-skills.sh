#!/usr/bin/env bash
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd -P)"

./Scripts/generate-skill-catalog.py --check
./Scripts/validate-skill-evaluations.py

python3 - <<'PY'
import json
import pathlib
import re

root = pathlib.Path('.agents/skills')
manifest = json.loads((root / 'manifest.json').read_text(encoding='utf-8'))
manifest_paths = set()

for item in manifest['skills']:
    name = item['name']
    relative_path = item['path']
    path = root / relative_path / 'SKILL.md'
    manifest_paths.add(relative_path)
    if not path.is_file():
        raise SystemExit(f'missing SKILL.md: {path}')

    text = path.read_text(encoding='utf-8')
    frontmatter = re.match(r'^---\n(?P<body>.*?)\n---\n', text, re.DOTALL)
    if not frontmatter:
        raise SystemExit(f'invalid frontmatter: {path}')
    fields = {}
    for line in frontmatter.group('body').splitlines():
        if ':' not in line:
            raise SystemExit(f'invalid frontmatter line: {path}: {line}')
        key, value = line.split(':', 1)
        fields[key.strip()] = value.strip()
    if fields.get('name') != name:
        raise SystemExit(f'frontmatter name differs from manifest: {path}')
    if fields.get('description') != item['description']:
        raise SystemExit(f'frontmatter description differs from manifest: {path}')
    if 'Inputs:' not in text or 'Output:' not in text:
        raise SystemExit(f'missing semantic contract: {path}')
    if '[TODO' in text:
        raise SystemExit(f'unresolved TODO: {path}')
    for link in re.findall(r'\[[^]]+\]\(([^)#]+)', text):
        if '://' not in link and not (path.parent / link).is_file():
            raise SystemExit(f'broken skill reference: {path}: {link}')

skill_paths = {path.parent.name for path in root.glob('*/SKILL.md')}
missing = sorted(manifest_paths - skill_paths)
extra = sorted(skill_paths - manifest_paths)
if missing or extra:
    details = []
    if missing:
        details.append(f'missing skill directories: {", ".join(missing)}')
    if extra:
        details.append(f'extra skill directories: {", ".join(extra)}')
    raise SystemExit('; '.join(details))

print(f'validated {len(manifest_paths)} skills')
PY
