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
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Halo / Aura that grows with Echoes + mood
                Circle()
                    .fill(hero.primaryColor.opacity(0.12 + worldBrightness * glowIntensity))
                    .frame(width: 170, height: 170)
                    .scaleEffect(isGlowing ? 1.15 : 0.95)
                    .animation(
                        .easeInOut(duration: 2.2)
                            .repeatForever(autoreverses: true),
                        value: isGlowing
                    )
                
                // Main Hero Circle with mood-reactive breathing
                Circle()
                    .fill(hero.primaryColor.opacity(0.18))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isBreathing ? 1.04 : 0.96)
                    .animation(
                        .easeInOut(duration: breathingSpeed)
                            .repeatForever(autoreverses: true),
                        value: isBreathing
                    )
                
                // Emoji
                Text(hero.emoji)
                    .font(.system(size: 78))
                    .scaleEffect(isBreathing ? 1.02 : 0.98)
                    .animation(
                        .easeInOut(duration: breathingSpeed * 0.9)
                            .repeatForever(autoreverses: true),
                        value: isBreathing
                    )
                
                // Enhanced shimmer particles when many echoes + hopeful mood
                if echoCount >= 4 || mood == .hopeful {
                    ForEach(0..<6, id: \.self) { i in
                        CrystalSparkle(
                            color: .white,
                            size: mood == .hopeful ? 4.0 : 3.5,
                            delay: Double(i) * 0.35
                        )
                        .offset(
                            x: CGFloat.random(in: -60...60),
                            y: CGFloat.random(in: -60...60)
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
