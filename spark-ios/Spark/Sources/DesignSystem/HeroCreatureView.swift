import SwiftUI

/// The three Spark heroes, drawn as cute crystal creatures in pure SwiftUI.
/// Flint (flame buddy), Pebby (stone buddy), Lumi (light wisp) — one cohesive
/// family, each themed to its hero color, with idle / happy / surprised faces.

enum HeroExpression {
    case idle
    case happy
    case surprised
}

// MARK: - Creature

struct HeroCreatureView: View {
    let heroID: HeroID
    var expression: HeroExpression = .idle
    var size: CGFloat = 120

    private let design: CGFloat = 120

    // Shared "ink" used for pupils, closed eyes and mouths.
    private let ink = Color(red: 0.10, green: 0.08, blue: 0.22)

    var body: some View {
        ZStack {
            crown
            creatureBody(for: heroID)
            cheeks
            eyes
            mouth
        }
        .frame(width: design, height: design)
        .scaleEffect(size / design)
        .frame(width: size, height: size)
    }

    // MARK: Body per hero

    @ViewBuilder
    private func creatureBody(for id: HeroID) -> some View {
        switch id {
        case .flint:
            Circle()
                .fill(bodyGradient)
                .frame(width: 64, height: 64)
                .overlay(Circle().stroke(Color.white.opacity(0.35), lineWidth: 1.5))
        case .pebby:
            Ellipse()
                .fill(bodyGradient)
                .frame(width: 68, height: 64)
                .overlay(Ellipse().stroke(Color.white.opacity(0.30), lineWidth: 1.5))
        case .lumi:
            TeardropShape()
                .fill(bodyGradient)
                .overlay(TeardropShape().stroke(Color.white.opacity(0.40), lineWidth: 1.2))
                .frame(width: 64, height: 88)
                .offset(y: 6)
        }
    }

    private var bodyGradient: RadialGradient {
        switch heroID {
        case .flint:
            return RadialGradient(
                colors: [Color(red: 1.0, green: 0.78, blue: 0.57), .flint, Color(red: 0.886, green: 0.275, blue: 0.106)],
                center: UnitPoint(x: 0.40, y: 0.34), startRadius: 1, endRadius: 40)
        case .pebby:
            return RadialGradient(
                colors: [Color(red: 0.80, green: 0.66, blue: 1.0), .pebby, Color(red: 0.43, green: 0.20, blue: 0.76)],
                center: UnitPoint(x: 0.40, y: 0.34), startRadius: 1, endRadius: 42)
        case .lumi:
            return RadialGradient(
                colors: [Color(red: 0.89, green: 0.98, blue: 1.0), .lumi, Color(red: 0.075, green: 0.60, blue: 0.69)],
                center: UnitPoint(x: 0.44, y: 0.32), startRadius: 1, endRadius: 48)
        }
    }

    // MARK: Crown per hero

    @ViewBuilder
    private var crown: some View {
        switch heroID {
        case .flint:
            ZStack {
                FlameShape()
                    .fill(LinearGradient(colors: [Color(red: 1.0, green: 0.91, blue: 0.63), Color(red: 1.0, green: 0.54, blue: 0.24)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 26, height: 36)
                FlameShape()
                    .fill(Color(red: 1.0, green: 0.91, blue: 0.60))
                    .frame(width: 13, height: 22)
                    .offset(y: 5)
            }
            .offset(y: -43)
        case .pebby:
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color.lumi.opacity(0.6), .clear], center: .center, startRadius: 1, endRadius: 16))
                    .frame(width: 30, height: 30)
                GemShape()
                    .fill(RadialGradient(colors: [.white, Color(red: 0.44, green: 0.90, blue: 0.95)], center: .center, startRadius: 1, endRadius: 12))
                    .frame(width: 18, height: 22)
            }
            .offset(y: -42)
        case .lumi:
            StarShape()
                .fill(Color(red: 0.92, green: 1.0, blue: 1.0))
                .frame(width: 22, height: 22)
                .offset(y: -50)
        }
    }

    // MARK: Cheeks

    private var cheeks: some View {
        let color: Color = {
            switch heroID {
            case .flint: return Color(red: 1.0, green: 0.62, blue: 0.37)
            case .pebby: return Color(red: 0.91, green: 0.61, blue: 0.82)
            case .lumi:  return Color(red: 0.56, green: 0.91, blue: 0.95)
            }
        }()
        let brighter = expression == .happy
        return HStack(spacing: 26) {
            Ellipse().fill(color).frame(width: 15, height: brighter ? 12 : 11)
            Ellipse().fill(color).frame(width: 15, height: brighter ? 12 : 11)
        }
        .opacity(brighter ? 0.85 : 0.7)
        .offset(y: 10)
    }

    // MARK: Eyes

    @ViewBuilder
    private var eyes: some View {
        let spacing: CGFloat = heroID == .lumi ? 24 : 26
        switch expression {
        case .happy:
            HStack(spacing: spacing) {
                ArcStroke(upward: true).stroke(ink, style: StrokeStyle(lineWidth: 3, lineCap: .round)).frame(width: 16, height: 9)
                ArcStroke(upward: true).stroke(ink, style: StrokeStyle(lineWidth: 3, lineCap: .round)).frame(width: 16, height: 9)
            }
            .offset(y: -4)
        case .idle:
            HStack(spacing: spacing) {
                openEye(wide: false)
                openEye(wide: false)
            }
            .offset(y: -4)
        case .surprised:
            HStack(spacing: spacing) {
                openEye(wide: true)
                openEye(wide: true)
            }
            .offset(y: -5)
        }
    }

    private func openEye(wide: Bool) -> some View {
        let w: CGFloat = wide ? 20 : 18
        let h: CGFloat = wide ? 25 : 22
        let pupil: CGFloat = wide ? 11 : 11
        let lookUp: CGFloat = heroID == .lumi ? 3 : 0
        return ZStack {
            Ellipse().fill(.white).frame(width: w, height: h)
            Circle().fill(ink).frame(width: pupil, height: pupil).offset(y: 2 - lookUp)
            Circle().fill(.white).frame(width: pupil * 0.46, height: pupil * 0.46)
                .offset(x: -pupil * 0.26, y: -pupil * 0.26 - lookUp)
        }
    }

    // MARK: Mouth

    @ViewBuilder
    private var mouth: some View {
        switch expression {
        case .surprised:
            Ellipse().fill(ink).frame(width: 9, height: 12).offset(y: 16)
        case .happy:
            ZStack {
                OpenSmileShape().fill(ink).frame(width: 20, height: 15)
                Ellipse().fill(Color(red: 1.0, green: 0.49, blue: 0.43)).frame(width: 9, height: 6).offset(y: 4)
            }
            .offset(y: 13)
        case .idle:
            ArcStroke(upward: false)
                .stroke(ink, style: StrokeStyle(lineWidth: 2.8, lineCap: .round))
                .frame(width: 15, height: 8)
                .offset(y: 14)
        }
    }
}

// MARK: - Glowing Orb Wrapper

/// The hero presence as it appears on the Hub: a soft accent glow, a faint
/// disc, and the creature inside. Gentle breathing by default.
struct HeroOrbView: View {
    let heroID: HeroID
    var accent: Color
    var expression: HeroExpression = .idle
    var size: CGFloat = 120
    var breathing: Bool = true

    @State private var breathe = false

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [accent.opacity(0.45), .clear], center: .center, startRadius: 2, endRadius: size * 0.62))
                .frame(width: size * 1.6, height: size * 1.6)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: size * 0.98, height: size * 0.98)
                .overlay(Circle().stroke(accent.opacity(0.35), lineWidth: 1.5))

            HeroCreatureView(heroID: heroID, expression: expression, size: size * 0.86)
        }
        .scaleEffect(breathe ? 1.03 : 0.98)
        .animation(breathing ? .easeInOut(duration: 3).repeatForever(autoreverses: true) : .default, value: breathe)
        .onAppear { if breathing { breathe = true } }
    }
}

// MARK: - Shapes

struct FlameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let midX = rect.midX
        p.move(to: CGPoint(x: midX, y: rect.minY))
        p.addCurve(to: CGPoint(x: midX, y: rect.maxY),
                   control1: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.42),
                   control2: CGPoint(x: midX + rect.width * 0.18, y: rect.maxY))
        p.addCurve(to: CGPoint(x: midX, y: rect.minY),
                   control1: CGPoint(x: midX - rect.width * 0.18, y: rect.maxY),
                   control2: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.42))
        p.closeSubpath()
        return p
    }
}

struct GemShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.38))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.38))
        p.closeSubpath()
        return p
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let ro = min(rect.width, rect.height) / 2
        let ri = ro * 0.34
        p.move(to: CGPoint(x: cx, y: cy - ro))
        p.addLine(to: CGPoint(x: cx + ri, y: cy - ri))
        p.addLine(to: CGPoint(x: cx + ro, y: cy))
        p.addLine(to: CGPoint(x: cx + ri, y: cy + ri))
        p.addLine(to: CGPoint(x: cx, y: cy + ro))
        p.addLine(to: CGPoint(x: cx - ri, y: cy + ri))
        p.addLine(to: CGPoint(x: cx - ro, y: cy))
        p.addLine(to: CGPoint(x: cx - ri, y: cy - ri))
        p.closeSubpath()
        return p
    }
}

struct TeardropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let midX = rect.midX
        p.move(to: CGPoint(x: midX, y: rect.minY))
        p.addCurve(to: CGPoint(x: midX, y: rect.maxY),
                   control1: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.40),
                   control2: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.maxY))
        p.addCurve(to: CGPoint(x: midX, y: rect.minY),
                   control1: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.maxY),
                   control2: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.40))
        p.closeSubpath()
        return p
    }
}

/// Stroked arc. `upward` arches up (happy closed eye); otherwise dips down (smile).
struct ArcStroke: Shape {
    var upward: Bool
    func path(in rect: CGRect) -> Path {
        var p = Path()
        if upward {
            p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                           control: CGPoint(x: rect.midX, y: rect.minY))
        } else {
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                           control: CGPoint(x: rect.midX, y: rect.maxY))
        }
        return p
    }
}

/// Filled open smile (a downward half-disc) for the happy mouth.
struct OpenSmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY),
                       control: CGPoint(x: rect.midX, y: rect.maxY * 1.6))
        p.closeSubpath()
        return p
    }
}

#Preview {
    ZStack {
        SparkBackground(accent: .lumi)
        HStack(spacing: 8) {
            HeroCreatureView(heroID: .flint, expression: .happy, size: 110)
            HeroCreatureView(heroID: .pebby, expression: .idle, size: 110)
            HeroCreatureView(heroID: .lumi, expression: .surprised, size: 110)
        }
    }
}
