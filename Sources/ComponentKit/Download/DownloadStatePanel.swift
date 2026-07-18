import ShapeKit
import SwiftUI

struct DownloadStatePanel: View {
    let phase: DownloadPhase
    let activePhase: DownloadPhase
    let progress: CGFloat
    let style: DownloadButtonStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(background)
            HStack(spacing: 14) {
                supportingView
                Text(label)
                    .font(.title2.weight(.bold))
                Spacer(minLength: 0)
            }
            .foregroundStyle(style.foregroundColor)
            .padding(.horizontal, 22)
            .opacity(activePhase == phase ? 1 : 0)

            if phase == .downloading {
                Capsule()
                    .trim(from: 0, to: progress / 2)
                    .stroke(style.progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(180))
                    .frame(width: style.width, height: 12)
                    .offset(y: style.height / 2 + 4)
                    .opacity(activePhase == phase ? 1 : 0)
            }
        }
        .frame(width: style.width, height: style.height)
        .animation(.easeOut(duration: style.transitionDuration / 2), value: activePhase)
    }

    private var label: String {
        switch phase {
        case .idle: "Download"
        case .downloading: "Downloading"
        case .completed: "Finished"
        }
    }

    private var background: Color {
        switch phase {
        case .idle: style.idleColor
        case .downloading: style.downloadingColor
        case .completed: style.completedColor
        }
    }

    @ViewBuilder
    private var supportingView: some View {
        switch phase {
        case .idle:
            Image(systemName: "arrow.down.circle")
                .font(.title2)
        case .downloading:
            DownloadingIndicatorView(
                size: min(style.height * 0.5, 38),
                duration: 0.5,
                foregroundColor: style.foregroundColor,
                animate: true
            )
        case .completed:
            CircleTickShape(circleSize: min(style.height * 0.65, 52), scaleFactor: 0.3)
                .trim(from: 0, to: activePhase == .completed ? 1 : 0)
                .stroke(style.foregroundColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: style.height * 0.65, height: style.height * 0.65)
        }
    }
}
