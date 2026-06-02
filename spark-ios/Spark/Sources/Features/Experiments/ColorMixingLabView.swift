import SwiftUI

struct ColorMixingLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void

    @State private var addedColors: [String] = []
    @State private var currentMix: MixResult?
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    @State private var isDragging = false

    // Magical mixing animation state
    @State private var dropEvents: [DropEvent] = []
    @State private var rippleEvents: [RippleEvent] = []
    @State private var sparks: [Spark] = []
    @State private var prevRGB: [Double] = [44, 32, 74]
    @State private var curRGB: [Double] = [44, 32, 74]
    @State private var mixStart: Date = .distantPast

    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }

    private let primaryColors = ["red", "yellow", "blue"]

    var body: some View {
        VStack(spacing: 20) {
            heroCompanionView

            if !hasPredicted && addedColors.isEmpty {
                predictionView
            }

            mixingCanvas

            colorPalette

            if let mix = currentMix {
                resultView(mix: mix)
            }

            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }

            if showReflection {
                reflectionView
            } else if currentMix != nil && discoveredEcho == nil {
                Button {
                    showReflection = true
                } label: {
                    Text("I noticed something")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 8)
            }

            Spacer(minLength: 20)
        }
        .padding(.horizontal, 20)
        .onChange(of: currentMix?.name) { _, newValue in
            if newValue != nil {
                HeroVoice.shared.speak(heroComment, as: hero.id)
            }
        }
    }

    // MARK: - Subviews

    private var heroCompanionView: some View {
        HStack(spacing: 12) {
            HeroCreatureView(heroID: hero.id, expression: currentMix != nil ? .happy : .idle, size: 48)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 5) {
                    Text(hero.name)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(hero.primaryColor)
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.caption2)
                        .foregroundStyle(hero.primaryColor.opacity(0.7))
                }

                Text(heroComment)
                    .font(.callout)
                    .foregroundStyle(Color.sparkTextSecondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .sparkCard(cornerRadius: 20)
        .onTapGesture { HeroVoice.shared.speak(heroComment, as: hero.id) }
    }

    private var heroComment: String {
        if let mix = currentMix {
            return heroReaction(for: mix)
        } else if hasPredicted {
            return "Let's see!"
        } else {
            return "Mix two colors!"
        }
    }

    private var predictionView: some View {
        VStack(spacing: 12) {
            Text("What will they make?")
                .font(.headline)
                .foregroundStyle(Color.sparkTextPrimary)

            HStack(spacing: 16) {
                predictionSwatch("Orange", "#E67E22")
                predictionSwatch("Green", "#27AE60")
                predictionSwatch("Purple", "#8E44AD")
                predictionSwatch("Brown", "#4A3728")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .sparkCard(cornerRadius: 20)
    }

    /// Picture-first prediction — kids tap a color, no reading required.
    private func predictionSwatch(_ name: String, _ hex: String) -> some View {
        let selected = prediction == name
        return Button {
            prediction = name
            hasPredicted = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Circle()
                .fill(Color(hex: hex))
                .frame(width: 52, height: 52)
                .overlay(Circle().stroke(.white.opacity(selected ? 0.9 : 0.15), lineWidth: selected ? 3 : 1))
                .sparkGlow(selected ? Color(hex: hex) : .clear, radius: 12, opacity: 0.8, y: 0)
                .scaleEffect(selected ? 1.08 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selected)
        }
    }

    private var mixingCanvas: some View {
        MixingWellCanvas(
            addedColors: addedColors,
            fromRGB: prevRGB,
            toRGB: curRGB,
            mixStart: mixStart,
            drops: dropEvents,
            ripples: rippleEvents,
            sparks: sparks
        )
        .frame(height: 240)
        .scaleEffect(isDragging ? 1.03 : 1.0)
        .animation(.spring(response: 0.3), value: isDragging)
        .dropDestination(for: String.self) { items, _ in
            guard let color = items.first else { return false }
            addColor(color)
            return true
        } isTargeted: { isDragging = $0 }
    }

    private var colorPalette: some View {
        HStack(spacing: 28) {
            ForEach(primaryColors, id: \.self) { colorKey in
                let isUsed = addedColors.contains(colorKey)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [mixDropColor(colorKey).opacity(0.95), mixDropColor(colorKey)],
                            center: UnitPoint(x: 0.38, y: 0.32), startRadius: 2, endRadius: 40
                        )
                    )
                    .frame(width: 72, height: 72)
                    .sparkGlow(mixDropColor(colorKey), radius: 14, opacity: 0.7, y: 0)
                    .opacity(isUsed ? 0.3 : 1.0)
                    .scaleEffect(isUsed ? 0.85 : 1.0)
                    .draggable(colorKey) {
                        Circle().fill(mixDropColor(colorKey)).frame(width: 60, height: 60)
                    }
                    .onTapGesture { addColor(colorKey) }
            }
        }
        .padding(.vertical, 12)
    }

    private func resultView(mix: MixResult) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: mix.colorHex))
                    .frame(width: 18, height: 18)
                    .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 1))
                Text(mix.name)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Color.sparkTextPrimary)
            }

            Text(mix.description)
                .font(.callout)
                .foregroundStyle(Color.sparkTextSecondary)
                .multilineTextAlignment(.center)

            if hasPredicted && !prediction.isEmpty {
                Text("Your prediction: \(prediction)")
                    .font(.caption)
                    .foregroundStyle(Color.sparkTextTertiary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .sparkCard(cornerRadius: 20)
    }

    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .prediction, .iteration]
            onComplete(currentMix?.name ?? "Something beautiful", dispositions, discoveredEcho)
        } label: {
            Text("I noticed something special")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    // MARK: - Interaction

    private func addColor(_ key: String) {
        guard !addedColors.contains(key), addedColors.count < 3 else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            addedColors.append(key)
        }

        let lane: CGFloat = key == "red" ? -1 : (key == "blue" ? 1 : 0)
        dropEvents.append(DropEvent(colorKey: key, start: Date(), lane: lane))
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        // The mixed color blooms when the drop lands.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            applyMix()
        }
    }

    private func applyMix() {
        let mix = calculateMix(addedColors)
        prevRGB = curRGB
        curRGB = rgb255(mix.colorHex)
        mixStart = Date()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            currentMix = mix
        }

        rippleEvents.append(RippleEvent(start: Date(), color: Color(hex: mix.colorHex)))
        let sparkColor = lightened(curRGB, 0.45)
        for _ in 0..<28 {
            sparks.append(Spark(start: Date(),
                                angle: Double.random(in: 0...(2 * .pi)),
                                speed: Double.random(in: 1.4...3.4),
                                color: sparkColor))
        }

        checkForEchoFragment()
        UINotificationFeedbackGenerator().notificationOccurred(.success)

        // Prune stale animation events
        let now = Date()
        dropEvents.removeAll { now.timeIntervalSince($0.start) > 0.7 }
        rippleEvents.removeAll { now.timeIntervalSince($0.start) > 2.2 }
        if sparks.count > 120 { sparks.removeFirst(sparks.count - 120) }
    }

    // MARK: - Logic

    private func calculateMix(_ colors: [String]) -> MixResult {
        let hasRed = colors.contains("red")
        let hasYellow = colors.contains("yellow")
        let hasBlue = colors.contains("blue")

        if hasRed && hasYellow && hasBlue {
            return MixResult(colorHex: "#4A3728", name: "Deep Earth Brown", description: "All three colors together create something rich and grounded.")
        }
        if hasRed && hasYellow {
            return MixResult(colorHex: "#E67E22", name: "Warm Orange", description: "Red and yellow dance together into a glowing orange.")
        }
        if hasYellow && hasBlue {
            return MixResult(colorHex: "#27AE60", name: "Living Green", description: "Yellow and blue create the color of growing things.")
        }
        if hasRed && hasBlue {
            return MixResult(colorHex: "#8E44AD", name: "Mysterious Purple", description: "Red and blue meet to make something deep and magical.")
        }

        if hasRed { return MixResult(colorHex: "#E74C3C", name: "Bold Red", description: "Just red, standing strong.") }
        if hasYellow { return MixResult(colorHex: "#F1C40F", name: "Sunny Yellow", description: "Bright and cheerful yellow.") }
        if hasBlue { return MixResult(colorHex: "#3498DB", name: "Calm Blue", description: "Cool, steady blue.") }

        return MixResult(colorHex: "#ECF0F1", name: "Nothing yet", description: "Add some colors to begin.")
    }

    private func heroReaction(for mix: MixResult) -> String {
        switch hero.id {
        case .flint: return "Whoa! \(mix.name)!"
        case .pebby: return "Ooh… \(mix.name)."
        case .lumi:  return "\(mix.name)… lovely."
        }
    }

    private func checkForEchoFragment() {
        guard let mix = currentMix else { return }

        if let echo = EchoService.echoForColorMix(colors: addedColors, resultName: mix.name) {
            if !profile.collectedEchoIDs.contains(echo.id) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    discoveredEcho = echo
                }
                profile.collectedEchoIDs.append(echo.id)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
    }

    private func echoFragmentCard(_ echo: EchoFragment) -> some View {
        VStack(spacing: 10) {
            Text("✨ Something special just happened")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor)

            Text(echo.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.sparkTextPrimary)

            Text(EchoService.reactionForEcho(echo, heroID: hero.id))
                .font(.callout)
                .foregroundStyle(Color.sparkTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .sparkCard(cornerRadius: 22, accentBorder: hero.primaryColor)
        .sparkGlow(hero.primaryColor, radius: 14, opacity: 0.4)
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Magical Mixing Well (Canvas + TimelineView)

private struct DropEvent: Identifiable {
    let id = UUID()
    let colorKey: String
    let start: Date
    let lane: CGFloat
}

private struct RippleEvent: Identifiable {
    let id = UUID()
    let start: Date
    let color: Color
}

private struct Spark: Identifiable {
    let id = UUID()
    let start: Date
    let angle: Double
    let speed: Double
    let color: Color
}

private struct MixingWellCanvas: View {
    let addedColors: [String]
    let fromRGB: [Double]
    let toRGB: [Double]
    let mixStart: Date
    let drops: [DropEvent]
    let ripples: [RippleEvent]
    let sparks: [Spark]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date
                let tt = now.timeIntervalSinceReferenceDate
                let cx = size.width / 2
                let cy = size.height * 0.46
                let baseR: CGFloat = 80

                // Well base
                let baseRect = CGRect(x: cx - (baseR + 46), y: cy - (baseR + 46), width: (baseR + 46) * 2, height: (baseR + 46) * 2)
                context.fill(
                    Path(ellipseIn: baseRect),
                    with: .radialGradient(Gradient(colors: [Color.white.opacity(0.05), .clear]),
                                          center: CGPoint(x: cx, y: cy), startRadius: 4, endRadius: baseR + 46)
                )
                context.stroke(
                    Path(ellipseIn: CGRect(x: cx - (baseR + 8), y: cy - (baseR + 8), width: (baseR + 8) * 2, height: (baseR + 8) * 2)),
                    with: .color(.white.opacity(0.08)), lineWidth: 1
                )

                if addedColors.isEmpty {
                    context.stroke(
                        Path(ellipseIn: CGRect(x: cx - baseR * 0.7, y: cy - baseR * 0.7, width: baseR * 1.4, height: baseR * 1.4)),
                        with: .color(.white.opacity(0.16)),
                        style: StrokeStyle(lineWidth: 1.5, dash: [4, 7])
                    )
                    // Looping "drop a color in here" cue — a visual instruction, no words.
                    let cyc = tt.truncatingRemainder(dividingBy: 1.8) / 1.8
                    if cyc < 0.72 {
                        let p = cyc / 0.72
                        let gy = -10 + (cy + 10) * (p * p)
                        context.drawLayer { layer in
                            layer.addFilter(.shadow(color: .white.opacity(0.5), radius: 10))
                            layer.fill(Path(ellipseIn: CGRect(x: cx - 8, y: gy - 8, width: 16, height: 16)),
                                       with: .color(.white.opacity((1 - p) * 0.55 + 0.15)))
                        }
                    }
                } else {
                    // Blob color (smoothly morphs after each mix)
                    let f = mixStart == .distantPast ? 1 : min(1, max(0, now.timeIntervalSince(mixStart) / 0.4))
                    let blobRGB = [
                        fromRGB[0] + (toRGB[0] - fromRGB[0]) * f,
                        fromRGB[1] + (toRGB[1] - fromRGB[1]) * f,
                        fromRGB[2] + (toRGB[2] - fromRGB[2]) * f
                    ]
                    let blob = colorRGB(blobRGB)

                    let pulse = 1 + 0.025 * sin(tt * 2.2)
                    let R = baseR * pulse
                    let blobRect = CGRect(x: cx - R, y: cy - R, width: R * 2, height: R * 2)

                    // Glowing body
                    context.drawLayer { layer in
                        layer.addFilter(.shadow(color: blob.opacity(0.85), radius: 50))
                        layer.fill(
                            Path(ellipseIn: blobRect),
                            with: .radialGradient(Gradient(colors: [lightened(blobRGB, 0.45), blob, blob.opacity(0.85)]),
                                                  center: CGPoint(x: cx - 12, y: cy - 14), startRadius: 6, endRadius: R)
                        )
                    }

                    // Swirling constituent wisps, clipped inside the blob (marbling)
                    context.drawLayer { layer in
                        layer.clip(to: Path(ellipseIn: blobRect.insetBy(dx: 2, dy: 2)))
                        layer.blendMode = .plusLighter
                        for (i, key) in addedColors.enumerated() {
                            let c = mixDropColor(key)
                            let sp = 0.7 + Double(i) * 0.35
                            let an = tt * sp * 1.1 + Double(i) * 2.1
                            let wr = R * 0.42
                            let x = cx + cos(an) * wr
                            let y = cy + sin(an * 1.1) * wr * 0.8
                            let wRect = CGRect(x: x - R * 0.6, y: y - R * 0.6, width: R * 1.2, height: R * 1.2)
                            layer.fill(
                                Path(ellipseIn: wRect),
                                with: .radialGradient(Gradient(colors: [c.opacity(0.5), c.opacity(0)]),
                                                      center: CGPoint(x: x, y: y), startRadius: 2, endRadius: R * 0.6)
                            )
                        }
                    }

                    // Rim highlight
                    var rim = Path()
                    rim.addArc(center: CGPoint(x: cx, y: cy), radius: R, startAngle: .degrees(-150), endAngle: .degrees(-30), clockwise: false)
                    context.stroke(rim, with: .color(.white.opacity(0.28)), lineWidth: 2)
                }

                // Ripples
                for rp in ripples {
                    let e = now.timeIntervalSince(rp.start)
                    if e < 0 || e > 1.8 { continue }
                    let r = 14 + e * 150
                    let a = max(0, 0.85 - e * 0.5)
                    context.stroke(
                        Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)),
                        with: .color(rp.color.opacity(a)), lineWidth: 2.5
                    )
                }

                // Falling drops
                for d in drops {
                    let e = now.timeIntervalSince(d.start)
                    if e < 0 || e > 0.5 { continue }
                    let p = min(1, e / 0.45)
                    let ease = p * p
                    let sx = cx + d.lane * 60
                    let x = sx + (cx - sx) * ease
                    let y = -16 + (cy + 16) * ease
                    let c = mixDropColor(d.colorKey)
                    context.drawLayer { layer in
                        layer.addFilter(.shadow(color: c.opacity(0.9), radius: 18))
                        layer.fill(Path(ellipseIn: CGRect(x: x - 9, y: y - 9, width: 18, height: 18)), with: .color(c))
                    }
                }

                // Sparkle burst (additive glow)
                context.drawLayer { layer in
                    layer.blendMode = .plusLighter
                    for s in sparks {
                        let e = now.timeIntervalSince(s.start)
                        if e < 0 || e > 1.6 { continue }
                        let life = max(0, 1 - e / 1.6)
                        let ee = min(e, 1.0)
                        let dist = s.speed * 46 * (1 - (1 - ee) * (1 - ee))
                        let x = cx + cos(s.angle) * dist
                        let y = cy + sin(s.angle) * dist
                        let rr = 2.4 * life
                        layer.fill(Path(ellipseIn: CGRect(x: x - rr, y: y - rr, width: rr * 2, height: rr * 2)),
                                   with: .color(s.color.opacity(life)))
                    }
                }
            }
        }
    }
}

// MARK: - Color helpers

private func mixDropColor(_ key: String) -> Color {
    switch key {
    case "red": return Color(hex: "#E74C3C")
    case "yellow": return Color(hex: "#F1C40F")
    case "blue": return Color(hex: "#3498DB")
    default: return .gray
    }
}

private func rgb255(_ hex: String) -> [Double] {
    let s = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
    var v: UInt64 = 0
    Scanner(string: s).scanHexInt64(&v)
    return [Double((v & 0xFF0000) >> 16), Double((v & 0x00FF00) >> 8), Double(v & 0x0000FF)]
}

private func colorRGB(_ rgb: [Double]) -> Color {
    Color(red: rgb[0] / 255, green: rgb[1] / 255, blue: rgb[2] / 255)
}

private func lightened(_ rgb: [Double], _ f: Double) -> Color {
    Color(red: (rgb[0] + (255 - rgb[0]) * f) / 255,
          green: (rgb[1] + (255 - rgb[1]) * f) / 255,
          blue: (rgb[2] + (255 - rgb[2]) * f) / 255)
}

struct MixResult {
    let colorHex: String
    let name: String
    let description: String
}

// Helper for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex.hasPrefix("#") ? String(hex.dropFirst()) : hex)

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
