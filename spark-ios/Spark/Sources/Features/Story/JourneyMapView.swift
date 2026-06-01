import SwiftUI

/// Visual "map" of the journey through The Shimmer.
/// Shows all tracks as connected paths.
/// Free labs are fully accessible. Everything else requires the one-time Full Unlock.
struct JourneyMapView: View {
    let profile: ChildProfile
    
    @State private var showUnlockSheet = false
    
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
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("The Shimmer")
                            .font(.sparkTitle)
                        
                        Text("Your journey through the crystal world")
                            .font(.sparkBody)
                            .foregroundStyle(.secondary)
                        
                        if !profile.hasFullUnlock {
                            Text("Free labs are open. Unlock the full story to explore every path.")
                                .font(.callout)
                                .foregroundStyle(hero.primaryColor.opacity(0.8))
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    // Tracks as paths on the map
                    ForEach(LearningTrack.all) { track in
                        trackPathSection(track)
                    }
                    
                    Spacer(minLength: 60)
                }
            }
        }
        .navigationTitle("Journey Map")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showUnlockSheet) {
            UnlockFullStoryView(profile: profile, hero: hero) {
                showUnlockSheet = false
            }
        }
    }
    
    private func trackPathSection(_ track: LearningTrack) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Track header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .font(.headline)
                        .foregroundStyle(hero.primaryColor)
                    Text(track.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                let trackProgress = progress.progress(for: track)
                if trackProgress > 0.05 {
                    Text("\(Int(trackProgress * 100))%")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(hero.primaryColor)
                }
            }
            .padding(.horizontal, 24)
            
            // Horizontal path of labs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(track.experiments) { experiment in
                        mapNode(for: experiment, in: track)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }
        }
        .padding(.vertical, 8)
        // Stronger background + subtle border for better separation on bright iPad screens
        .background(Color.white.opacity(0.85))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func mapNode(for experiment: Experiment, in track: LearningTrack) -> some View {
        let hasAccess = progress.canAccess(experiment)
        let isCompleted = profile.hasCompleted(experiment.id)
        
        VStack(spacing: 8) {
            ZStack {
                // Node circle
                Circle()
                    .fill(hasAccess ? hero.primaryColor.opacity(0.15) : Color.gray.opacity(0.15))
                    .frame(width: 68, height: 68)
                    .overlay(
                        Circle()
                            .stroke(hasAccess ? hero.primaryColor : Color.gray.opacity(0.4), lineWidth: 2)
                    )
                
                Text(experiment.domain.emoji)
                    .font(.title)
                    .opacity(hasAccess ? 1.0 : 0.5)
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(hero.primaryColor)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .clipShape(Circle())
                        .font(.caption)
                        .offset(x: 22, y: -22)
                }
            }
            .scaleEffect(hasAccess ? 1.0 : 0.9)
            .saturation(hasAccess ? 1.0 : 0.4)
            
            // Title (short)
            Text(experiment.title)
                .font(.caption.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
                .foregroundStyle(hasAccess ? .primary : .secondary)
            
            // Status
            if !hasAccess {
                Button {
                    showUnlockSheet = true
                } label: {
                    Text("Unlock")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(hero.primaryColor.opacity(0.15))
                        .foregroundStyle(hero.primaryColor)
                        .clipShape(Capsule())
                }
            } else if isCompleted {
                Text("Complete")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Text("Open")
                    .font(.caption2)
                    .foregroundStyle(hero.primaryColor)
            }
        }
        .frame(width: 90)
        .opacity(hasAccess ? 1.0 : 0.7)
        .onTapGesture {
            if hasAccess {
                // Navigate to the lab (we'd need a navigation path in real use)
                // For now this is visual — tapping opens detail if we wire navigation later
            } else {
                showUnlockSheet = true
            }
        }
    }
}

#Preview {
    let profile = ChildProfile(
        name: "Maya",
        grade: .third,
        chosenHeroID: .lumi
    )
    
    NavigationStack {
        JourneyMapView(profile: profile)
    }
}