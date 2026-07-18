#!/usr/bin/env bash
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd -P)"
for command in swift xcrun python3; do
  command -v "$command" >/dev/null 2>&1 || { echo "Required command is unavailable: $command" >&2; exit 1; }
done
./Scripts/verify-skills.sh
./Scripts/install-skills.sh --dry-run
./Scripts/test-install-skills.sh
swift package describe >/dev/null
swift build
swift build -Xswiftc -strict-concurrency=complete
swift build --target FoundationGallery --triple arm64-apple-ios17.0-simulator --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift build --target iOSExample --triple arm64-apple-ios17.0-simulator --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift build --target LoggingKit --triple arm64-apple-ios17.0-simulator --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift test
python3 - <<'PY'
import pathlib, re, sys
for path in pathlib.Path('.').glob('**/*.md'):
    if any(part in path.parts for part in ['node_modules', '.build', '.git']):
        continue
    text = path.read_text()
    for link in re.findall(r'\[[^]]+\]\(([^)#]+)', text):
        if '://' not in link and not (path.parent / link).exists():
            raise SystemExit(f'broken documentation link in {path}: {link}')
print('validated documentation links')
PY
echo 'verification complete'
