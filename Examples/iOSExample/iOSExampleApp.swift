import DesignSystem
import FormKit
import SwiftUI

@main struct iOSExampleApp: App { var body: some Scene { WindowGroup { ExampleContent(platform: "iOS") } } }

private struct ExampleContent: View { let platform: String; @State private var value = ""; var body: some View { NavigationStack { VStack(spacing: 16) { Text("\(platform) Example").font(.title.bold()); ValidatedTextField("A short value", text: $value, validation: .init([.maximumLength(20)])); StateView(.loading) }.padding().navigationTitle("Foundation") } } }
