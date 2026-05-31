import SwiftUI
import SwiftData

struct MainAppView: View {
    let profile: ChildProfile
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var progress: LearningProgress {
        LearningProgress(profile: profile)
    }
    
    var body: some View {
        ZStack {
            Color.sparkBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 36) {
                    // Hero greeting
                    VStack(spacing: 12) {
                        Text(hero.emoji)
                            .font(.system(size: 72))
                        
                        Text("Welcome back, \(profile.name)!")
                            .font(.sparkTitle)
                            .foregroundStyle(.primary)
                        
                        Text("Your companion today is \(hero.name).")
                            .font(.sparkHeadline)
                            .foregroundStyle(hero.primaryColor)
                    }
                    .padding(.top, 24)
                    
                    // Gentle strength hint (very early parent/insight surface)
                    if !profile.topDispositions.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("What you've been noticing lately")
                                .font(.sparkCallout)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 8) {
                                ForEach(profile.topDispositions, id: \.self) { disposition in
                                    Text(disposition.shortLabel)
                                        .font(.caption.weight(.medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(hero.primaryColor.opacity(0.12))
                                        .foregroundStyle(hero.primaryColor)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 32)
                    }
                    
                    // Experiments entry point
                    VStack(spacing: 16) {
                        NavigationLink {
                            ExperimentDiscoveryView(profile: profile)
                        } label: {
                            HStack {
                                Text("🔍")
                                Text("Explore Experiments")
                                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(hero.primaryColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                            .shadow(color: hero.primaryColor.opacity(0.3), radius: 12, y: 6)
                        }
                        
                        Text("\(Experiment.all.count) experiments available")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer(minLength: 60)
                }
            }
        }
    }
}

#Preview {
    let profile = ChildProfile(
        name: "Alex",
        grade: .third,
        chosenHeroID: .lumi
    )
    MainAppView(profile: profile)
}
