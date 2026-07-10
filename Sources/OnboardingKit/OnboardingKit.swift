import DesignSystem
import SwiftUI

/// A platform-neutral definition for one step in a guided flow.
public struct FlowStep<ID: Hashable & Sendable>: Identifiable, Sendable {
    /// The stable application-owned identifier for this step.
    public let id: ID

    /// Whether a validation message should not block progression.
    public let isOptional: Bool

    /// Whether this step belongs in this flow instance.
    public let isIncluded: @Sendable () -> Bool

    /// Returns a user-presentable validation message, or `nil` when valid.
    public let validate: @Sendable () -> String?

    /// Creates a flow step with optional inclusion and validation behavior.
    public init(
        id: ID,
        isOptional: Bool = false,
        isIncluded: @escaping @Sendable () -> Bool = { true },
        validate: @escaping @Sendable () -> String? = { nil }
    ) {
        self.id = id
        self.isOptional = isOptional
        self.isIncluded = isIncluded
        self.validate = validate
    }
}

/// Owns progression only; an app owns its content and persistence strategy.
public struct FlowProgression<ID: Hashable & Sendable>: Sendable {
    /// The included steps captured when this progression was initialized.
    public private(set) var steps: [FlowStep<ID>]

    /// The zero-based index of the current step, or `steps.count` after completion.
    public private(set) var currentIndex: Int

    /// Whether the application cancelled the flow.
    public private(set) var isCancelled = false

    /// Creates a progression, restoring an included step when its identifier is present.
    ///
    /// An unknown or excluded restored identifier starts the flow at the first included step.
    public init(steps: [FlowStep<ID>], restoredStepID: ID? = nil) {
        let includedSteps = steps.filter { $0.isIncluded() }
        self.steps = includedSteps
        currentIndex = restoredStepID.flatMap { id in
            includedSteps.firstIndex { $0.id == id }
        } ?? 0
    }

    /// The current included step, or `nil` after completion or cancellation.
    public var currentStep: FlowStep<ID>? {
        guard !isCancelled, steps.indices.contains(currentIndex) else { return nil }
        return steps[currentIndex]
    }

    /// Whether all included steps have completed.
    public var isComplete: Bool { !isCancelled && currentIndex >= steps.count }

    /// The completed proportion of included steps, from `0` through `1`.
    public var progress: Double {
        steps.isEmpty ? 1 : Double(currentIndex) / Double(steps.count)
    }

    /// Validates and advances the current required step.
    ///
    /// Returns a validation message when progression is blocked. Optional steps advance even when
    /// their validation closure returns a message. Calling this after completion or cancellation is a no-op.
    public mutating func advance() -> String? {
        guard let step = currentStep else { return nil }
        if let error = step.validate(), !step.isOptional { return error }
        currentIndex = min(currentIndex + 1, steps.count)
        return nil
    }

    /// Moves to the preceding included step unless the flow has completed or been cancelled.
    public mutating func goBack() {
        guard !isCancelled else { return }
        currentIndex = max(0, currentIndex - 1)
    }

    /// Cancels the flow and clears the current step without treating it as completion.
    public mutating func cancel() { isCancelled = true }
}

public struct FlowContainer<Content: View>: View {
    /// The visible flow title.
    public let title: LocalizedStringKey

    /// The completed progress, expected to be in the `0...1` range.
    public let progress: Double

    private let content: Content

    /// Creates a platform-neutral flow container.
    public init(
        _ title: LocalizedStringKey,
        progress: Double,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.progress = progress
        self.content = content()
    }

    /// The accessible flow layout.
    public var body: some View {
        VStack(alignment: .leading, spacing: FoundationTokens.Spacing.roomy) {
            Text(title).font(.title2.bold())
            ProgressView(value: progress)
                .accessibilityLabel("Progress")
                .accessibilityValue(progress.formatted(.percent))
            content
        }
        .padding()
    }
}
