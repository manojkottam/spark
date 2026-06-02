import SwiftUI

/// Visual "map" of the journey through The Shimmer.
/// Shows all tracks as connected paths of glowing crystal labs.
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

    private var worldBrightness: Double {
        min(Double(profile.collectedEchoIDs.count) / 8.0, 1.0)
    }

    var body: some View {
        ZStack {
            SparkBackground(accent: hero.primaryColor, brightness: worldBrightness)

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("The Shimmer")
                            .font(.sparkTitle)
                            .foregroundStyle(Color.sparkTextPrimary)

                        Text("Your journey through the crystal world")
                            .font(.sparkBody)
                            .foregroundStyle(Color.sparkTextSecondary)

                        if !profile.hasFullUnlock {
                            Text("Free labs are open. Unlock the full story to explore every path.")
                                .font(.callout)
                                .foregroundStyle(hero.primaryColor)
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
                        .foregroundStyle(Color.sparkTextSecondary)
                }

                Spacer()

                let trackProgress = progress.progress(for: track)
                if trackProgress > 0.05 {
                    Text("\(Int(trackProgress * 100))%")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(hero.primaryColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)

            // Horizontal path of labs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(track.experiments) { experiment in
                        mapNode(for: experiment, in: track)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
        }
        .padding(.vertical, 10)
        .sparkCard(cornerRadius: 20)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func mapNode(for experiment: Experiment, in track: LearningTrack) -> some View {
        let hasAccess = progress.canAccess(experiment)
        let isCompleted = profile.hasCompleted(experiment.id)

        VStack(spacing: 8) {
            ZStack {
                // Node crystal
                Circle()
                    .fill(hasAccess ? hero.primaryColor.opacity(0.18) : Color.white.opacity(0.05))
                    .frame(width: 68, height: 68)
                    .overlay(
                        Circle()
                            .stroke(hasAccess ? hero.primaryColor : Color.white.opacity(0.15), lineWidth: 2)
                    )
                    .sparkGlow(hasAccess ? hero.primaryColor : .clear, radius: 12, opacity: 0.6, y: 0)

                if hasAccess {
                    Text(experiment.domain.emoji)
                        .font(.title)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.4))
                }

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(hero.primaryColor)
                        .background(Circle().fill(Color.sparkTwilightBottom))
                        .offset(x: 24, y: -24)
                }
            }
            .scaleEffect(hasAccess ? 1.0 : 0.92)

            // Title (short)
            Text(experiment.title)
                .font(.caption.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
                .foregroundStyle(hasAccess ? Color.sparkTextPrimary : Color.sparkTextTertiary)

            // Status
            if !hasAccess {
                Button {
                    showUnlockSheet = true
                } label: {
                    Text("Unlock")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(hero.primaryColor.opacity(0.18))
                        .foregroundStyle(hero.primaryColor)
                        .clipShape(Capsule())
                }
            } else if isCompleted {
                Text("Complete")
                    .font(.caption2)
                    .foregroundStyle(Color.sparkTextSecondary)
            } else {
                Text("Open")
                    .font(.caption2)
                    .foregroundStyle(hero.primaryColor)
            }
        }
        .frame(width: 90)
        .onTapGesture {
            if !hasAccess {
                showUnlockSheet = true
            }
            // Accessible nodes are visual for now; navigation can be wired later.
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
