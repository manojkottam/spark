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
                    
                    // Recommended Section
                    if !recommended.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Recommended for you")
                                .font(.sparkHeadline)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 14) {
                                ForEach(recommended) { experiment in
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
                    
                    // All Experiments
                    VStack(alignment: .leading, spacing: 14) {
                        Text("All Experiments")
                            .font(.sparkHeadline)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 14) {
                            ForEach(otherExperiments) { experiment in
                                NavigationLink {
                                    ExperimentDetailView(experiment: experiment, profile: profile)
                                } label: {
                                    ExperimentCard(
                                        experiment: experiment,
                                        hero: hero,
                                        isRecommended: false
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 20)
                            }
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