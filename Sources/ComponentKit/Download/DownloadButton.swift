import FeedbackKit
import Observation
import SwiftUI

/// A reusable slot-machine download button with idle, progress, and completion panels.
public struct DownloadButton: View {
    @State private var controller: DownloadController
    private let onStart: (() -> Void)?
    private let style: DownloadButtonStyle
    @State private var progress: CGFloat = 0
    @State private var idleOffset: CGFloat = 0
    @State private var downloadingOffset: CGFloat
    @State private var completedOffset: CGFloat

    /// Creates a download button backed by an observable controller.
    public init(
        controller: DownloadController = DownloadController(),
        onStart: (() -> Void)? = nil,
        style: DownloadButtonStyle = DownloadButtonStyle()
    ) {
        _controller = State(initialValue: controller)
        self.onStart = onStart
        self.style = style
        _downloadingOffset = State(initialValue: -style.height)
        _completedOffset = State(initialValue: -(style.height * 2))
    }

    /// The animated slot-machine button.
    public var body: some View {
        ZStack {
            DownloadStatePanel(phase: .completed, activePhase: controller.phase, progress: progress, style: style)
                .offset(y: completedOffset)
            DownloadStatePanel(phase: .downloading, activePhase: controller.phase, progress: progress, style: style)
                .offset(y: downloadingOffset)
            DownloadStatePanel(phase: .idle, activePhase: controller.phase, progress: progress, style: style)
                .offset(y: idleOffset)
        }
        .frame(width: style.width, height: style.height)
        .clipShape(.rect(cornerRadius: style.cornerRadius))
        .contentShape(.rect(cornerRadius: style.cornerRadius))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
        .overlay {
            Button(action: start) {
                Color.clear
            }
            .buttonStyle(.plain)
            .accessibilityLabel(controller.phase == .idle ? "Start download" : "Download status")
            .accessibilityValue(statusLabel)
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: controller.phase)
    }

    private var statusLabel: String {
        switch controller.phase {
        case .idle: "Ready"
        case .downloading: "Downloading"
        case .completed: "Finished"
        }
    }

    private func start() {
        guard controller.phase == .idle else { return }
        onStart?()
        controller.phase = .downloading
        progress = 0
        withAnimation(.easeOut(duration: style.transitionDuration)) {
            completedOffset = -style.height + 10
            idleOffset = style.height
            downloadingOffset = 0
        } completion: {
            withAnimation(.linear(duration: style.progressDuration)) {
                progress = 1
            } completion: {
                complete()
            }
        }
    }

    private func complete() {
        controller.phase = .completed
        withAnimation(.easeOut(duration: style.transitionDuration)) {
            downloadingOffset = style.height
            completedOffset = 0
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + style.completedDuration) {
                reset()
            }
        }
    }

    private func reset() {
        idleOffset = -style.height
        progress = 0
        controller.phase = .idle
        withAnimation(.easeOut(duration: style.transitionDuration)) {
            idleOffset = 0
        } completion: {
            downloadingOffset = -style.height
            completedOffset = -(style.height * 2)
        }
    }
}

#Preview {
    DownloadButton()
        .padding()
}
