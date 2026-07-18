import SwiftUI

/// A timer-free looping arrow indicator for the downloading panel.
struct DownloadingIndicatorView: View {
    let size: CGFloat
    let duration: TimeInterval
    let foregroundColor: Color
    let animate: Bool
    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let phase = animate && duration > 0 ? elapsed.truncatingRemainder(dividingBy: duration) / duration : 0
            let offset = animate ? -size + (size * 2 * phase) : 0

            ZStack {
                Circle()
                    .stroke(foregroundColor, style: StrokeStyle(lineWidth: 4))
                    .frame(width: size, height: size)
                Image(systemName: "arrow.down")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(foregroundColor)
                    .offset(y: offset)
                    .mask(Circle().frame(width: size, height: size))
            }
        }
        .accessibilityLabel("Downloading")
    }
}
