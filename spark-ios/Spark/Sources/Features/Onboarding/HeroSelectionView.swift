import SwiftUI

struct HeroSelectionView: View {
    @Binding var path: NavigationPath

    @State private var selectedHero: Hero?
    @State private var cardsAppeared = false

    private var backgroundAccent: Color {
        selectedHero?.primaryColor ?? .lumi
    }

    var body: some View {
        ZStack {
            SparkBackground(accent: backgroundAccent)

            ScrollView {
                VStack(spacing: 32) {
                    // Header with subtle crystal shimmer
                    VStack(spacing: 14) {
                        ZStack {
                            HeaderSparkles()

                            Text("Who would you like\nto explore with?")
                                .font(.sparkTitle)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.sparkTextPrimary)
                        }

                        Text("Three companions from a fading crystal world are searching for a Spark like yours.")
                            .font(.sparkBody)
                            .foregroundStyle(Color.sparkTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 20)

                    // Three Hero Cards with staggered entrance
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(Array(Hero.all.enumerated()), id: \.element.id) { index, hero in
                            HeroCard(
                                hero: hero,
                                isSelected: selectedHero?.id == hero.id
                            ) {
                                withAnimation(.spring(response: 0.42, dampingFraction: 0.68)) {
                                    selectedHero = hero
                                }

                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            }
                            .opacity(cardsAppeared ? 1 : 0)
                            .offset(y: cardsAppeared ? 0 : 30)
                            .animation(
                                .spring(response: 0.55, dampingFraction: 0.72)
                                    .delay(Double(index) * 0.12),
                                value: cardsAppeared
                            )
                        }
                    }
                    .padding(.horizontal, 16)

                    // Continue Button — becomes lively when a hero is chosen
                    Button {
                        guard let hero = selectedHero else { return }
                        path.append(hero)
                    } label: {
                        HStack(spacing: 8) {
                            if let hero = selectedHero {
                                HeroCreatureView(heroID: hero.id, expression: .happy, size: 30)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            Text(selectedHero != nil ? "Continue with \(selectedHero!.name)" : "Choose a companion")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            selectedHero != nil
                            ? AnyShapeStyle(selectedHero!.primaryColor.sparkAccentGradient)
                            : AnyShapeStyle(Color.white.opacity(0.12))
                        )
                        .foregroundStyle(selectedHero != nil ? .white : Color.sparkTextSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                        .shadow(
                            color: selectedHero?.primaryColor.opacity(0.4) ?? .clear,
                            radius: selectedHero != nil ? 16 : 0,
                            y: selectedHero != nil ? 8 : 0
                        )
                        .scaleEffect(selectedHero != nil ? 1.0 : 0.98)
                    }
                    .disabled(selectedHero == nil)
                    .padding(.horizontal, 32)
                    .padding(.top, 12)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: selectedHero?.id)

                    // Gentle reassurance
                    Text("You can always change your companion later.")
                        .font(.caption)
                        .foregroundStyle(Color.sparkTextTertiary)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation {
                cardsAppeared = true
            }
        }
    }
}

// Subtle crystal sparkles behind the header for a magical touch
private struct HeaderSparkles: View {
    var body: some View {
        ZStack {
            CrystalSparkle(color: .white, size: 3.5, delay: 0.0)
                .offset(x: -68, y: -18)
            CrystalSparkle(color: .white, size: 2.8, delay: 0.6)
                .offset(x: 52, y: -24)
            CrystalSparkle(color: Color(red: 0.7, green: 0.85, blue: 1.0), size: 3.2, delay: 1.1)
                .offset(x: -22, y: 14)
            CrystalSparkle(color: .white, size: 2.5, delay: 0.35)
                .offset(x: 78, y: 8)
            CrystalSparkle(color: Color(red: 1.0, green: 0.95, blue: 0.7), size: 3.8, delay: 0.9)
                .offset(x: 18, y: -32)
        }
        .opacity(0.6)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    HeroSelectionView(path: $path)
}
