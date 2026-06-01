import SwiftUI
import SwiftData

struct InsightsView: View {
    let profile: ChildProfile
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var collectedEchoes: [EchoFragment] {
        EchoFragment.all.filter { profile.collectedEchoIDs.contains($0.id) }
    }
    
    private var allDispositions: [LearningDisposition] {
        LearningDisposition.allCases
    }
    
    var body: some View {
        ZStack {
            Color.sparkBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerSection
                    
                    // Learning Tracks Progress
                    tracksProgressSection
                    
                    // Strengths Section
                    strengthsSection
                    
                    // Echoes Collected Section
                    echoesSection
                    
                    // Explanation
                    explanationSection
                    
                    // Quick access to the unlock experience (for testing)
                    #if DEBUG
                    Button {
                        // Present the real polished unlock sheet
                        // In a real app this would be triggered from the Hub or locked content
                    } label: {
                        Text(profile.hasFullUnlock ? "✓ Full Story Unlocked" : "Try the Unlock Full Story Sheet")
                            .font(.callout.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(profile.hasFullUnlock ? Color.green.opacity(0.15) : hero.primaryColor.opacity(0.1))
                            .foregroundStyle(profile.hasFullUnlock ? .green : hero.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(profile.hasFullUnlock)
                    #endif
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Insights")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Insights for \(profile.name)")
                .font(.sparkTitle)
            
            HStack(spacing: 6) {
                Text(hero.emoji)
                Text("Exploring with \(hero.name)")
                    .font(.sparkHeadline)
                    .foregroundStyle(hero.primaryColor)
            }
        }
        .padding(.bottom, 8)
    }
    
    private var tracksProgressSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Learning Tracks")
                .font(.sparkHeadline)
                .padding(.horizontal, 4)
            
            ForEach(LearningTrack.all) { track in
                let progress = LearningProgress(profile: profile).progress(for: track)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(track.title)
                            .font(.callout.weight(.semibold))
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    
                    ProgressView(value: progress)
                        .tint(hero.primaryColor)
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var strengthsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("What \(profile.name) is developing")
                    .font(.sparkHeadline)
                
                Text("These are the ways of thinking and noticing your child is strengthening through their experiments.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 14) {
                ForEach(allDispositions, id: \.self) { disposition in
                    StrengthRow(
                        disposition: disposition,
                        count: profile.strength(for: disposition),
                        accentColor: hero.primaryColor
                    )
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var echoesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Echoes collected")
                    .font(.sparkHeadline)
                
                Text("\(collectedEchoes.count) of \(EchoFragment.all.count) moments discovered")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            if collectedEchoes.isEmpty {
                emptyEchoesView
            } else {
                VStack(spacing: 12) {
                    ForEach(collectedEchoes) { echo in
                        EchoRow(echo: echo, accentColor: hero.primaryColor)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var emptyEchoesView: some View {
        VStack(spacing: 8) {
            Text("🌱")
                .font(.largeTitle)
            Text("No echoes yet")
                .font(.headline)
            Text("As \(profile.name) explores, they'll discover special moments from the story.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
    
    private var explanationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How this works")
                .font(.callout.weight(.semibold))
            
            Text("Every time your child engages deeply in an experiment, they strengthen certain ways of thinking. These small moments also sometimes reveal gentle echoes from the story of The Dimming Shimmer.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(Color.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Supporting Views

struct StrengthRow: View {
    let disposition: LearningDisposition
    let count: Int
    let accentColor: Color
    
    private var progress: Double {
        // Simple visual scaling — we can improve this later with better normalization
        min(Double(count) / 12.0, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(disposition.shortLabel)
                    .font(.callout.weight(.semibold))
                
                Spacer()
                
                Text("\(count)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(accentColor)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            Text(disposition.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

struct EchoRow: View {
    let echo: EchoFragment
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(rarityEmoji)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(echo.title)
                    .font(.callout.weight(.semibold))
                
                Text(echo.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(12)
        .background(accentColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var rarityEmoji: String {
        if echo.isMajorStoryEcho {
            return "🌟🌌"   // Major Final Echo Moments get special double treatment in the parent journal
        }
        switch echo.rarity {
        case .common: return "✨"
        case .uncommon: return "🌟"
        case .rare: return "💎"
        case .legendary: return "🌌"
        }
    }
}


