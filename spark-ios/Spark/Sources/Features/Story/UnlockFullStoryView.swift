import SwiftUI

/// Beautiful one-time unlock sheet for the "Free play then buy to unlock all" model.
/// Keeps the magical, non-pushy tone of the app while clearly offering the full experience.
struct UnlockFullStoryView: View {
    let profile: ChildProfile
    let hero: Hero
    let onDismiss: () -> Void
    
    @State private var isPurchasing = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            Color.sparkBackground.ignoresSafeArea()
            
            // Soft shimmering background (same language as climax / major moments)
            LinearGradient(
                colors: [
                    hero.primaryColor.opacity(0.08),
                    Color.clear,
                    hero.primaryColor.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Hero + Title
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(hero.primaryColor.opacity(0.15))
                                .frame(width: 120, height: 120)
                            
                            Text(hero.emoji)
                                .font(.system(size: 72))
                        }
                        
                        Text("The Full Story Awaits")
                            .font(.sparkTitle)
                            .multilineTextAlignment(.center)
                        
                        Text("You’ve seen the beginning.\nUnlock every lab, every track, and the complete ending of The Dimming Shimmer.")
                            .font(.sparkBody)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 40)
                    
                    // What you get
                    VStack(alignment: .leading, spacing: 18) {
                        Text("With the full story you’ll get:")
                            .font(.sparkHeadline)
                            .padding(.horizontal, 24)
                        
                        VStack(alignment: .leading, spacing: 14) {
                            benefitRow(icon: "🔬", text: "All 10 interactive labs across Science and Math")
                            benefitRow(icon: "🗺️", text: "The complete journey through every Learning Track")
                            benefitRow(icon: "🌌", text: "Major Final Echo Moments that power the ending")
                            benefitRow(icon: "✨", text: "The full emotional climax and personalized farewells")
                            benefitRow(icon: "📖", text: "Every Echo Fragment and the complete parent journal")
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Price / CTA
                    VStack(spacing: 12) {
                        Button {
                            simulatePurchase()
                        } label: {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Unlock the Full Story")
                                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(hero.primaryColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                            .shadow(color: hero.primaryColor.opacity(0.35), radius: 10, y: 4)
                        }
                        .disabled(isPurchasing)
                        .padding(.horizontal, 32)
                        
                        Text("One-time purchase • No subscription")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("$4.99")   // Placeholder price — replace with real pricing later
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(hero.primaryColor)
                    }
                    .padding(.top, 8)
                    
                    // Gentle close
                    Button {
                        onDismiss()
                    } label: {
                        Text("Maybe later")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onChange(of: showSuccess) { _, newValue in
            if newValue {
                // Auto-dismiss after success animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    onDismiss()
                }
            }
        }
        .overlay {
            if showSuccess {
                successOverlay
            }
        }
    }
    
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title3)
            Text(text)
                .font(.callout)
            Spacer()
        }
    }
    
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(hero.emoji)
                    .font(.system(size: 80))
                
                Text("Thank you!")
                    .font(.sparkTitle)
                    .foregroundStyle(.white)
                
                Text("The full story of The Shimmer is now yours.")
                    .font(.sparkBody)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .transition(.opacity)
    }
    
    private func simulatePurchase() {
        withAnimation(.spring(response: 0.4)) {
            isPurchasing = true
        }
        
        // Simulate network / purchase delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.spring(response: 0.5)) {
                profile.hasFullUnlock = true
                isPurchasing = false
                showSuccess = true
            }
            
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
}

#Preview {
    let profile = ChildProfile(
        name: "Alex",
        grade: .third,
        chosenHeroID: .lumi
    )
    
    UnlockFullStoryView(
        profile: profile,
        hero: Hero.hero(for: .lumi)
    ) {
        print("Sheet dismissed")
    }
}