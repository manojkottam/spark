import SwiftUI

struct TrackSection: View {
    let track: LearningTrack
    let profile: ChildProfile
    let hero: Hero

    private var progress: Double {
        LearningProgress(profile: profile).progress(for: track)
    }

    private var trackExperiments: [Experiment] {
        track.experiments
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Track Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .font(.headline)
                        .foregroundStyle(Color.sparkTextPrimary)
                    Text(track.subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.sparkTextSecondary)
                }

                Spacer()

                // Progress indicator
                if progress > 0.05 {
                    Text("\(Int(progress * 100))%")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(hero.primaryColor)
                }
            }
            .padding(.horizontal, 24)

            // Track description (subtle)
            Text(track.description)
                .font(.caption)
                .foregroundStyle(Color.sparkTextSecondary)
                .lineLimit(2)
                .padding(.horizontal, 24)

            // Experiments in track
            VStack(spacing: 10) {
                ForEach(trackExperiments) { experiment in
                    let progress = LearningProgress(profile: profile)
                    let hasAccess = progress.canAccess(experiment)

                    if hasAccess {
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
                    } else {
                        // Locked state for monetization ("Free play then buy to unlock all")
                        ExperimentCard(
                            experiment: experiment,
                            hero: hero,
                            isRecommended: false
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.sparkTwilightBottom.opacity(0.6))
                        )
                        .overlay(
                            VStack(spacing: 6) {
                                Image(systemName: "lock.fill")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                Text("Unlock Full Story")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text("Available in the Adventure Hub")
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.55))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        )
                        .saturation(0.55)
                        .onTapGesture {
                            // Future: Present purchase flow / "Unlock Full Adventure" sheet
                            print("User tapped locked lab — should show purchase UI for full unlock")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .sparkCard(cornerRadius: 20)
        .padding(.horizontal, 4)
    }
}
