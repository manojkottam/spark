import SwiftUI

// MARK: - Colors
extension Color {
    // Warm paper-like background used by the older (light) screens.
    // Kept for screens that haven't moved to the twilight theme yet.
    static let sparkBackground = Color(red: 0.95, green: 0.94, blue: 0.925)

    // Hero primary colors (matching the model)
    static let flint = Color(red: 1.0, green: 0.42, blue: 0.21)
    static let pebby = Color(red: 0.49, green: 0.23, blue: 0.93)
    static let lumi  = Color(red: 0.13, green: 0.83, blue: 0.91)

    // Soft tints for card backgrounds when selected
    static let flintTint = Color(red: 1.0, green: 0.95, blue: 0.90)
    static let pebbyTint = Color(red: 0.96, green: 0.93, blue: 1.0)
    static let lumiTint  = Color(red: 0.90, green: 0.97, blue: 0.98)

    // MARK: - Crystal Twilight Theme
    // The deep, luminous foundation that replaces the washed-out "paper" look.
    static let sparkTwilightTop    = Color(red: 0.11, green: 0.085, blue: 0.27)
    static let sparkTwilightBottom = Color(red: 0.04, green: 0.04, blue: 0.115)

    // Text on the twilight background. Explicit (not semantic) so these screens
    // stay readable regardless of the device's light/dark setting.
    static let sparkTextPrimary   = Color.white.opacity(0.96)
    static let sparkTextSecondary = Color.white.opacity(0.62)
    static let sparkTextTertiary  = Color.white.opacity(0.40)

    // Frosted card surfaces over the twilight background.
    static let sparkCardFill   = Color.white.opacity(0.07)
    static let sparkCardStroke = Color.white.opacity(0.13)
}

// MARK: - Typography
extension Font {
    static let sparkTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let sparkHeadline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let sparkBody = Font.system(size: 17, weight: .regular, design: .rounded)
    static let sparkCallout = Font.system(size: 15, weight: .medium, design: .rounded)
}

// MARK: - Corner Radius
extension CGFloat {
    static let cardCorner: CGFloat = 28
    static let buttonCorner: CGFloat = 22
}

// MARK: - Twilight Background
/// The shared crystal-twilight backdrop. A deep vertical gradient with a soft
/// radial glow at the top tinted by the chosen hero's color. `brightness`
/// (0...1) lets the world feel warmer as the child collects more Echoes.
struct SparkBackground: View {
    var accent: Color
    var brightness: Double = 0.0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.sparkTwilightTop, .sparkTwilightBottom],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [accent.opacity(0.26 + brightness * 0.16), .clear],
                center: UnitPoint(x: 0.5, y: -0.05),
                startRadius: 0,
                endRadius: 460
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Frosted Card + Glow Modifiers
private struct SparkCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var accent: Color?

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.sparkCardFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(accent?.opacity(0.35) ?? Color.sparkCardStroke, lineWidth: 1)
            )
    }
}

extension View {
    /// Frosted translucent card surface for the twilight theme.
    func sparkCard(cornerRadius: CGFloat = 22, accentBorder: Color? = nil) -> some View {
        modifier(SparkCardModifier(cornerRadius: cornerRadius, accent: accentBorder))
    }

    /// Soft colored glow, used on the hero accent CTAs and lit elements.
    func sparkGlow(_ color: Color, radius: CGFloat = 16, opacity: Double = 0.5, y: CGFloat = 6) -> some View {
        shadow(color: color.opacity(opacity), radius: radius, y: y)
    }
}

extension Color {
    /// Vertical gradient used to fill accent buttons.
    var sparkAccentGradient: LinearGradient {
        LinearGradient(
            colors: [self, self.opacity(0.78)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
