import DesignSystem
import FeedbackKit
import FormKit
import OnboardingKit
import SwiftUI

@main struct FoundationGalleryApp: App {
    var body: some Scene { WindowGroup { GalleryView() } }
}

private struct GalleryView: View {
    @State private var name = ""; @State private var showSuccess = false
    var body: some View { NavigationStack { ScrollView { VStack(alignment: .leading, spacing: 20) { SectionHeader("Components"); FoundationCard { VStack(alignment: .leading, spacing: 12) { Text("A neutral, accessible component gallery.").font(.title3); ValidatedTextField("Optional name", text: $name, validation: .init([.maximumLength(40)])); FoundationButton("Show Success") { showSuccess = true } } }; StateView(.empty(title: "No items", message: "An application supplies its own content.")); FlowContainer("Guided flow", progress: 0.5) { Text("Content remains application-owned.") } }.padding() }.navigationTitle("Foundation Gallery").sheet(isPresented: $showSuccess) { FeedbackBanner(message: .init(kind: .success, text: "The reusable feedback surface is working.")) } } }
}
