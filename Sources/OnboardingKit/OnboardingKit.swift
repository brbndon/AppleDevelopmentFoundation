import AppFoundation
import DesignSystem
import SwiftUI

/// A platform-neutral definition for one step in a guided flow.
public struct FlowStep<ID: Hashable & Sendable>: Identifiable, Sendable {
    public let id: ID; public let isOptional: Bool; public let isIncluded: @Sendable () -> Bool; public let validate: @Sendable () -> String?
    public init(id: ID, isOptional: Bool = false, isIncluded: @escaping @Sendable () -> Bool = { true }, validate: @escaping @Sendable () -> String? = { nil }) { self.id = id; self.isOptional = isOptional; self.isIncluded = isIncluded; self.validate = validate }
}

/// Owns progression only; an app owns its content and persistence strategy.
public struct FlowProgression<ID: Hashable & Sendable>: Sendable {
    public private(set) var steps: [FlowStep<ID>]; public private(set) var currentIndex: Int
    public init(steps: [FlowStep<ID>], restoredStepID: ID? = nil) { let includedSteps = steps.filter { $0.isIncluded() }; self.steps = includedSteps; currentIndex = restoredStepID.flatMap { id in includedSteps.firstIndex { $0.id == id } } ?? 0 }
    public var currentStep: FlowStep<ID>? { steps.indices.contains(currentIndex) ? steps[currentIndex] : nil }
    public var progress: Double { steps.isEmpty ? 1 : Double(currentIndex) / Double(steps.count) }
    public mutating func advance() -> String? { guard let step = currentStep else { return nil }; if let error = step.validate(), !step.isOptional { return error }; currentIndex = min(currentIndex + 1, steps.count); return nil }
    public mutating func goBack() { currentIndex = max(0, currentIndex - 1) }
}

public struct FlowContainer<Content: View>: View {
    public let title: LocalizedStringKey; public let progress: Double; private let content: Content
    public init(_ title: LocalizedStringKey, progress: Double, @ViewBuilder content: () -> Content) { self.title = title; self.progress = progress; self.content = content() }
    public var body: some View { VStack(alignment: .leading, spacing: FoundationTokens.Spacing.roomy) { Text(title).font(.title2.bold()); ProgressView(value: progress).accessibilityLabel("Progress").accessibilityValue(progress.formatted(.percent)); content }.padding() }
}
