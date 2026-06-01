import SwiftUI

/// A cinematic, full-screen celebration for Major Story Echoes (Final Echo Moments).
/// These are the rare, emotionally significant echoes that directly power the ending.
/// Presented as a takeover moment so the child feels the Shimmer reacting to them.
struct MajorEchoMomentView: View {
    let echo: EchoFragment
    let hero: Hero
    let onDismiss: () -> Void
    
    @State private var heroScale: CGFloat = 0.7
    @State private var contentOpacity: Double = 0.0
    @State private var sparkleIntensity: Double = 0.0
    @State private var showBadge = false
    
    var body: some View {
        ZStack {
            // Atmospheric background — deeper than usual, with hero-colored light returning
            Color.sparkBackground.ignoresSafeArea()
            
            // Strong shimmering world light layer (feels like the Shimmer reacting)
            LinearGradient(
                colors: [
                    hero.primaryColor.opacity(0.12),
                    Color.white.opacity(0.06),
                    hero.primaryColor.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(0.6 + sparkleIntensity * 0.4)
            
            // Abundant crystal sparkles — more and brighter than regular echoes
            ForEach(0..<26, id: \.self) { i in
                CrystalSparkle(
                    color: i % 3 == 0 ? .white : hero.primaryColor,
                    size: CGFloat.random(in: 3...7),
                    delay: Double(i) * 0.07
                )
                .offset(
                    x: CGFloat.random(in: -220...220),
                    y: CGFloat.random(in: -380...380)
                )
                .opacity(0.4 + Double.random(in: 0...0.5))
                .scaleEffect(0.6 + sparkleIntensity * 0.5)
            }
            
            VStack(spacing: 28) {
                Spacer(minLength: 40)
                
                // Hero presence — large, glowing, breathing companion
                ZStack {
                    // Strong glowing halo
                    Circle()
                        .fill(hero.primaryColor.opacity(0.18))
                        .frame(width: 210, height: 210)
                        .scaleEffect(heroScale * 1.05)
                        .blur(radius: 20)
                    
                    Circle()
                        .fill(hero.primaryColor.opacity(0.12))
                        .frame(width: 170, height: 170)
                        .scaleEffect(heroScale)
                    
                    Text(hero.emoji)
                        .font(.system(size: 96))
                        .scaleEffect(heroScale)
                }
                .animation(.spring(response: 1.1, dampingFraction: 0.55), value: heroScale)
                
                // The moment header
                VStack(spacing: 10) {
                    if showBadge {
                        Text("THE SHIMMER NOTICED")
                            .font(.caption.weight(.semibold))
                            .tracking(2.5)
                            .foregroundStyle(hero.primaryColor.opacity(0.85))
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    Text(echo.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .transition(.opacity)
                }
                
                // The emotional hero reaction — the heart of the moment
                VStack(spacing: 12) {
                    Text(EchoService.reactionForMajorEcho(echo, heroID: hero.id))
                        .font(.system(size: 19, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .lineSpacing(4)
                    
                    // Story context line based on the beat
                    if let storyLine = storyContextLine {
                        Text(storyLine)
                            .font(.callout.italic())
                            .foregroundStyle(hero.primaryColor.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding(.top, 4)
                    }
                }
                .opacity(contentOpacity)
                
                Spacer()
                
                // Gentle call to continue
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        onDismiss()
                    }
                } label: {
                    Text("The light remembers this")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                        .shadow(color: hero.primaryColor.opacity(0.3), radius: 10, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            // Cinematic entrance sequence
            withAnimation(.spring(response: 0.9, dampingFraction: 0.6)) {
                heroScale = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeOut(duration: 0.7)) {
                    contentOpacity = 1.0
                    sparkleIntensity = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showBadge = true
                }
            }
            
            // Haptics timed to the reveal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }
    }
    
    private var storyContextLine: String? {
        guard let beat = echo.storyBeat else { return nil }
        
        switch beat {
        case "harmony":
            return "Sound and light found each other because of you."
        case "ancient_memory":
            return "Something very old just recognized itself in your hands."
        case "threshold":
            return "You showed both fire and perfect quiet. The crystals needed both."
        case "seed_whisper":
            return "The living world answered the child who was truly watching."
        case "light_chose_you":
            return "This is why we came. Your way of seeing was the missing piece."
        default:
            return "This moment will help the light return."
        }
    }
}

#Preview {
    MajorEchoMomentView(
        echo: EchoFragment.all.first { $0.isMajorStoryEcho }!,
        hero: Hero.hero(for: .lumi)
    ) {
        print("Dismissed cinematic major echo moment")
    }
}