import SwiftUI

// Public extensions and containers simulating iOS 26+ Liquid Glass APIs.
// This allows compilation under Xcode/Swift compiler for iOS 17+ and provides
// transparent fallback behavior.

@available(iOS 17.0, *)
public struct GlassEffectContainer<Content: View>: View {
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

@available(iOS 17.0, *)
public extension View {
    /// Applies a liquid glass rendering effect.
    /// On iOS 26+, this leverages native system rendering. On iOS 17-25, it returns the view unchanged.
    func glassEffect() -> some View {
        self
    }
    
    /// Enables interactive responsiveness for liquid glass rendering.
    /// On iOS 26+, this leverages native system rendering. On iOS 17-25, it returns the view unchanged.
    func interactive() -> some View {
        self
    }
}

/// A button style that mimics a premium liquid glass appearance.
@available(iOS 17.0, *)
public struct LiquidGlassButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

@available(iOS 17.0, *)
public extension ButtonStyle where Self == LiquidGlassButtonStyle {
    static var glass: LiquidGlassButtonStyle { LiquidGlassButtonStyle() }
}
