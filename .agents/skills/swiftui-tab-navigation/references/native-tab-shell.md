# Native tab shell reference

Use the simplest API supported by the consumer app's deployment target. A standard `TabView` using `tabItem` works on older supported iOS versions and receives the current system tab-bar appearance when run on newer versions.

```swift
import SwiftUI

private enum AppTab: Hashable {
    case home
    case settings
}

struct AppTabShell: View {
    @State private var selection: AppTab

    init(initialSelection: AppTab = .home) {
        _selection = State(initialValue: initialSelection)
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(AppTab.home)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(AppTab.settings)
        }
    }
}
```

Do not add a custom tab-bar background or call `glassEffect` on this shell merely to obtain Liquid Glass. Let the operating system own shape, material, selected state, safe-area behavior, pointer/keyboard interaction, and appearance evolution.

## Routing boundaries

- Render loading, onboarding, and fatal recovery states before constructing the tab shell.
- Keep each tab's drill-down destinations inside that tab's `NavigationStack`.
- Initialize selection from an inspection or deep-link destination only when needed.
- Preserve direct detail inspection routes when screenshot or UI-test fixtures intentionally bypass the normal root.
- Keep tabs limited to persistent peer destinations; use buttons, sheets, or navigation destinations for actions and transient flows.

## UI automation

Inspect the running hierarchy because the tab buttons are synthesized by SwiftUI. If an inner tab-label identifier is absent from the generated button, query its accessibility label instead of adding a custom tab bar solely for testability.

```swift
let settingsTab = app.tabBars.buttons["Settings"]
XCTAssertTrue(settingsTab.waitForExistence(timeout: 2))
settingsTab.tap()
```

For Maestro, prefer a confirmed identifier; otherwise target the same visible label after hierarchy inspection:

```yaml
- tapOn: Settings
- assertVisible:
    id: settings.root
```

Verify selection, tab switching after model updates, nested navigation, reset/onboarding transitions, Dynamic Type, VoiceOver labels, keyboard or pointer interaction where applicable, and the rendered appearance on the newest supported OS.
