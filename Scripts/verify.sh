#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
./Scripts/verify-skills.sh
./Scripts/install-skills.sh --dry-run
swift package describe >/dev/null
swift build
swift build --target FoundationGallery --triple arm64-apple-ios17.0-simulator --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift build --target iOSExample --triple arm64-apple-ios17.0-simulator --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift build --target LoggingKit --triple arm64-apple-ios17.0-simulator --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift test
python3 - <<'PY'
import pathlib, re, sys
for path in pathlib.Path('.').glob('**/*.md'):
    text = path.read_text()
    for link in re.findall(r'\[[^]]+\]\(([^)#]+)', text):
        if '://' not in link and not (path.parent / link).exists():
            raise SystemExit(f'broken documentation link in {path}: {link}')
print('validated documentation links')
PY
echo 'verification complete'
