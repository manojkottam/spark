import SwiftUI

struct TrackRewardCelebrationView: View {
    let rewards: [EchoFragment]
    let hero: Hero
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            SparkBackground(accent: hero.primaryColor)
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("🌟")
                        .font(.system(size: 64))
                    
                    Text("A Track Complete!")
                        .font(.sparkTitle)
                        .foregroundStyle(hero.primaryColor)
                    
                    Text("You've earned something special from the story.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Rewards
                VStack(spacing: 20) {
                    ForEach(rewards) { echo in
                        VStack(spacing: 12) {
                            HStack {
                                Text(rarityEmoji(for: echo.rarity))
                                    .font(.largeTitle)
                                Text(echo.title)
                                    .font(.title2.weight(.semibold))
                            }
                            
                            Text(echo.description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                            
                            Text(heroReaction(for: echo))
                                .font(.callout.italic())
                                .foregroundStyle(hero.primaryColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.sparkCardFill)
                                .shadow(color: hero.primaryColor.opacity(0.15), radius: 12, y: 4)
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Text("Keep Exploring")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .padding(.top, 40)
        }
    }
    
    private func rarityEmoji(for rarity: EchoFragment.Rarity) -> String {
        switch rarity {
        case .common: "✨"
        case .uncommon: "🌟"
        case .rare: "💎"
        case .legendary: "🌌"
        }
    }
    
    private func heroReaction(for echo: EchoFragment) -> String {
        // Reuse the same logic as EchoService for consistency
        return EchoService.reactionForEcho(echo, heroID: hero.id)
    }
}
