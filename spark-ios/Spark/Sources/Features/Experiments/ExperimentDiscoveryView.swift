import SwiftUI

struct ExperimentDiscoveryView: View {
    let profile: ChildProfile
    
    @State private var searchText = ""
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var progress: LearningProgress {
        LearningProgress(profile: profile)
    }
    
    private var recommended: [Experiment] {
        progress.recommendedExperiments(from: Experiment.all)
    }
    
    private var otherExperiments: [Experiment] {
        let recommendedIDs = Set(recommended.map { $0.id })
        return Experiment.all.filter { !recommendedIDs.contains($0.id) }
    }
    
    var body: some View {
        ZStack {
            Color.sparkBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What shall we explore today?")
                            .font(.sparkTitle)
                        
                        Text("\(hero.name) has a few ideas for you.")
                            .font(.sparkBody)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    // Note: Free vs Full Unlock model
                    // Free labs (isFree == true) are always available.
                    // Everything else requires the one-time "Unlock Full Story" purchase
                    // (simulated via the toggle in Insights for now).
                    
                    // Recommended Section (only show accessible / free content unless fully unlocked)
                    let accessibleRecommended = recommended.filter { LearningProgress(profile: profile).canAccess($0) }
                    if !accessibleRecommended.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Recommended for you")
                                .font(.sparkHeadline)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 14) {
                                ForEach(accessibleRecommended) { experiment in
                                    NavigationLink {
                                        ExperimentDetailView(experiment: experiment, profile: profile)
                                    } label: {
                                        ExperimentCard(
                                            experiment: experiment,
                                            hero: hero,
                                            isRecommended: true
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    
                    // Learning Tracks
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Learning Tracks")
                            .font(.sparkHeadline)
                            .padding(.horizontal, 24)
                        
                        ForEach(LearningTrack.all) { track in
                            TrackSection(
                                track: track,
                                profile: profile,
                                hero: hero
                            )
                        }
                    }
                    
                    Spacer(minLength: 60)
                }
            }
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let profile = ChildProfile(
        name: "Maya",
        grade: .second,
        chosenHeroID: .lumi
    )
    
    NavigationStack {
        ExperimentDiscoveryView(profile: profile)
    }
}