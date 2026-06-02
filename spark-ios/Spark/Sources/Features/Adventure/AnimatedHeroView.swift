import SwiftUI

struct AnimatedHeroView: View {
    let hero: Hero
    let echoCount: Int
    let mood: HeroDialogueSystem.Mood
    let onTap: () -> Void

    @State private var isBreathing = false
    @State private var isGlowing = false

    private var worldBrightness: Double {
        min(Double(echoCount) / 8.0, 1.0)
    }

    private var breathingSpeed: Double {
        switch mood {
        case .excited, .hopeful: 1.6
        case .proud: 2.4
        default: 3.2
        }
    }

    private var glowIntensity: Double {
        switch mood {
        case .hopeful: 0.35
        case .excited, .proud: 0.25
        default: 0.18
        }
    }

    /// The creature's face reflects the hero's current mood.
    private var expression: HeroExpression {
        switch mood {
        case .excited: return .surprised
        case .hopeful, .proud: return .happy
        case .reflective, .curious: return .idle
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Halo / aura that grows with Echoes + mood
                Circle()
                    .fill(hero.primaryColor.opacity(0.12 + worldBrightness * glowIntensity))
                    .frame(width: 184, height: 184)
                    .scaleEffect(isGlowing ? 1.12 : 0.94)
                    .animation(
                        .easeInOut(duration: 2.2).repeatForever(autoreverses: true),
                        value: isGlowing
                    )

                // Soft inner disc
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 132, height: 132)
                    .overlay(Circle().stroke(hero.primaryColor.opacity(0.35), lineWidth: 1.5))

                // The living crystal creature
                HeroCreatureView(heroID: hero.id, expression: expression, size: 120)
                    .scaleEffect(isBreathing ? 1.03 : 0.97)
                    .animation(
                        .easeInOut(duration: breathingSpeed).repeatForever(autoreverses: true),
                        value: isBreathing
                    )

                // Shimmer particles when many echoes / hopeful mood
                if echoCount >= 4 || mood == .hopeful {
                    ForEach(0..<6, id: \.self) { i in
                        CrystalSparkle(
                            color: .white,
                            size: mood == .hopeful ? 4.0 : 3.5,
                            delay: Double(i) * 0.35
                        )
                        .offset(
                            x: CGFloat.random(in: -64...64),
                            y: CGFloat.random(in: -64...64)
                        )
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            isBreathing = true
            isGlowing = true
        }
    }
}
