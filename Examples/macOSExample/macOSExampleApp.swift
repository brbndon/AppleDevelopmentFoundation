import AppShellKit
import DesignSystem
import SwiftUI

@main struct macOSExampleApp: App { var body: some Scene { WindowGroup { AdaptiveAppShell { Label("Overview", systemImage: "square.grid.2x2") } detail: { FoundationCard { VStack(alignment: .leading) { Text("macOS Example").font(.title.bold()); Text("The shell uses a native sidebar on macOS.") } }.padding() } }
    #if os(macOS)
    Settings { Text("Example settings belong to the application.").padding() }
    #endif
} }
