import DesignSystem
import SwiftUI

/// Provides a consistent instruction label and preview surface for shader demos.
public struct ShaderPreviewContainer<Content: View>: View {
    private let instruction: LocalizedStringKey
    private let content: Content

    /// Creates a shader preview container around arbitrary content.
    public init(
        instruction: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) {
        self.instruction = instruction
        self.content = content()
    }

    /// The shared shader preview layout.
    public var body: some View {
        PreviewSurface {
            VStack(spacing: FoundationTokens.Spacing.roomy) {
                Text(instruction)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                content
                    .clipShape(.rect(cornerRadius: FoundationTokens.Radius.control))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ShaderPreviewContainer(instruction: "Tap to apply an effect") {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue.gradient)
            .frame(width: 220, height: 180)
    }
}
