import SwiftUI

public extension Color {
    /// Creates a color from RGB components expressed in the 0...255 range.
    init(r: Double, g: Double, b: Double, opacity: Double = 1) {
        self.init(
            red: Self.normalized(r),
            green: Self.normalized(g),
            blue: Self.normalized(b),
            opacity: opacity
        )
    }

    /// Creates a color from a six- or eight-digit hexadecimal string.
    ///
    /// The optional leading `#` and surrounding whitespace are ignored. An
    /// invalid value produces a clear color so callers do not receive a
    /// partially parsed color.
    init(hex: String) {
        let value = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        guard value.count == 6 || value.count == 8,
              let rawValue = UInt64(value, radix: 16)
        else {
            self = .clear
            return
        }

        if value.count == 6 {
            self.init(
                r: Double((rawValue >> 16) & 0xFF),
                g: Double((rawValue >> 8) & 0xFF),
                b: Double(rawValue & 0xFF)
            )
        } else {
            self.init(
                r: Double((rawValue >> 24) & 0xFF),
                g: Double((rawValue >> 16) & 0xFF),
                b: Double((rawValue >> 8) & 0xFF),
                opacity: Double(rawValue & 0xFF) / 255
            )
        }
    }

    private static func normalized(_ component: Double) -> Double {
        min(max(component / 255, 0), 1)
    }
}
