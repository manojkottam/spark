import SwiftUI

struct HeroCard: View {
    let hero: Hero
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isBreathing = false
    
    // Sparkle configuration for when selected
    private let sparklePositions: [(x: CGFloat, y: CGFloat, delay: Double, size: CGFloat)] = [
        (x: -38, y: -32, delay: 0.0, size: 4.5),
        (x:  36, y: -28, delay: 0.35, size: 3.5),
        (x: -30, y:  38, delay: 0.7,  size: 4.0),
        (x:  32, y:  34, delay: 0.2,  size: 3.0),
        (x:   0, y: -44, delay: 0.55, size: 3.8),
    ]
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Avatar with living crystal effects
                ZStack {
                    // Soft colored halo
                    Circle()
                        .fill(hero.primaryColor.opacity(0.15))
                        .frame(width: 92, height: 92)
                        .scaleEffect(isBreathing ? 1.04 : 0.96)
                        .animation(
                            .easeInOut(duration: 2.8)
                                .repeatForever(autoreverses: true),
                            value: isBreathing
                        )
                    
                    // Shimmering outer glow when selected (crystalline light)
                    if isSelected {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        hero.primaryColor.opacity(0.0),
                                        hero.primaryColor.opacity(0.45),
                                        hero.primaryColor.opacity(0.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 8
                            )
                            .frame(width: 108, height: 108)
                            .blur(radius: 6)
                            .opacity(0.6)
                            .scaleEffect(1.0)
                            .animation(
                                .easeInOut(duration: 1.8).repeatForever(autoreverses: true),
                                value: isSelected
                            )
                    }
                    
                    // Emoji
                    Text(hero.emoji)
                        .font(.system(size: 52))
                        .scaleEffect(isSelected ? 1.08 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isSelected)
                    
                    // Crystal sparkles around the avatar when selected
                    if isSelected {
                        ForEach(Array(sparklePositions.enumerated()), id: \.offset) { _, pos in
                            CrystalSparkle(
                                color: hero.primaryColor.opacity(0.85),
                                size: pos.size,
                                delay: pos.delay
                            )
                            .offset(x: pos.x, y: pos.y)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .frame(width: 92, height: 92)
                
                // Name
                Text(hero.name)
                    .font(.sparkHeadline)
                    .foregroundStyle(hero.primaryColor)
                
                // Short tagline
                Text(hero.tagline)
                    .font(.sparkCallout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 4)
                
                // Future hook — only visible when selected
                if isSelected {
                    Text(hero.selectionHook)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(hero.primaryColor.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, minHeight: 280)
            .background(
                RoundedRectangle(cornerRadius: .cardCorner, style: .continuous)
                    .fill(isSelected ? heroTint : Color.white)
                    .shadow(
                        color: isSelected ? hero.primaryColor.opacity(0.22) : .black.opacity(0.06),
                        radius: isSelected ? 24 : 8,
                        x: 0,
                        y: isSelected ? 12 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: .cardCorner, style: .continuous)
                    .strokeBorder(
                        isSelected ? hero.primaryColor : Color.black.opacity(0.06),
                        lineWidth: isSelected ? 3.5 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onAppear {
            // Start gentle breathing animation
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
    }
    
    private var heroTint: Color {
        switch hero.id {
        case .flint: .flintTint
        case .pebby: .pebbyTint
        case .lumi:  .lumiTint
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        HeroCard(hero: Hero.all[0], isSelected: true) {}
        HeroCard(hero: Hero.all[1], isSelected: false) {}
    }
    .padding()
    .background(Color.sparkBackground)
}
