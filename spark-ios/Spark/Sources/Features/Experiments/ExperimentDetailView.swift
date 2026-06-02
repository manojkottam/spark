import SwiftUI

struct ExperimentDetailView: View {
    let experiment: Experiment
    let profile: ChildProfile

    @State private var hasStartedExperiment = false
    @State private var newlyEarnedTrackRewards: [EchoFragment] = []

    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }

    var body: some View {
        ZStack {
            SparkBackground(accent: hero.primaryColor)

            ScrollView {
                VStack(spacing: 24) {
                    // A short, spoken intro — then the lab owns the experience.
                    heroGreetingSection

                    experimentOverviewSection

                    labPlaceholderSection
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle(experiment.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: Binding(
            get: { !newlyEarnedTrackRewards.isEmpty },
            set: { if !$0 { newlyEarnedTrackRewards = [] } }
        )) {
            TrackRewardCelebrationView(
                rewards: newlyEarnedTrackRewards,
                hero: hero,
                onDismiss: { newlyEarnedTrackRewards = [] }
            )
        }
    }

    // MARK: - Sections

    private var heroGreetingSection: some View {
        VStack(spacing: 12) {
            HeroOrbView(heroID: hero.id, accent: hero.primaryColor, expression: .happy, size: 104)
                .onTapGesture { HeroVoice.shared.speak(heroGreeting, as: hero.id) }

            HStack(spacing: 6) {
                Text(heroGreeting)
                    .font(.sparkHeadline)
                    .foregroundStyle(Color.sparkTextPrimary)
                    .multilineTextAlignment(.center)
                Image(systemName: "speaker.wave.2.fill")
                    .font(.caption)
                    .foregroundStyle(hero.primaryColor.opacity(0.8))
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 12)
        .onAppear { HeroVoice.shared.speak(heroGreeting, as: hero.id) }
    }

    /// Short, spoken greeting in the hero's voice. Parent-facing detail lives in the Insights screen.
    private var heroGreeting: String {
        switch hero.id {
        case .flint: return "Hi \(profile.name)! Ready? Let's go!"
        case .pebby: return "Hi \(profile.name). Let's look together."
        case .lumi:  return "Hi \(profile.name). Let's notice something."
        }
    }

    private var experimentOverviewSection: some View {
        VStack(spacing: 6) {
            Text(experiment.domain.emoji)
                .font(.system(size: 44))

            Text(experiment.title)
                .font(.sparkTitle)
                .foregroundStyle(Color.sparkTextPrimary)
                .multilineTextAlignment(.center)

            if let subtitle = experiment.subtitle {
                Text(subtitle)
                    .font(.sparkHeadline)
                    .foregroundStyle(hero.primaryColor)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .sparkCard(cornerRadius: 24)
    }

    // MARK: - Completion Handler

    private func handleLabCompletion(resultName: String, dispositions: [LearningDisposition], echo: EchoFragment?) {
        hasStartedExperiment = true

        // Record dispositions
        for disposition in dispositions {
            profile.recordStrength(disposition, amount: 1)
        }

        // Mark experiment as completed (for track progress & branching)
        profile.markExperimentCompleted(experiment.id)

        // Record regular echo if one was discovered
        if let echo = echo, !profile.collectedEchoIDs.contains(echo.id) {
            profile.collectedEchoIDs.append(echo.id)
        }

        // MAJOR STORY ECHO CHECK (fallback). The interactive labs drive most major
        // echoes themselves with richer context; this catches any path that reaches here.
        let majorContext = EchoService.MajorEchoContext(
            experimentID: experiment.id,
            wasPerfectSynthesis: false,
            secondaryScore: 0.6
        )
        if let majorEcho = EchoService.majorEchoForCompletion(context: majorContext, profile: profile),
           !profile.collectedEchoIDs.contains(majorEcho.id) {
            profile.collectedEchoIDs.append(majorEcho.id)
        }

        // Check for track completion rewards
        let progress = LearningProgress(profile: profile)
        let newlyEarnedRewards = progress.checkForTrackCompletionRewards()

        if !newlyEarnedRewards.isEmpty {
            newlyEarnedTrackRewards = newlyEarnedRewards
        }
    }

    @ViewBuilder
    private var labPlaceholderSection: some View {
        // Route each experiment to its interactive lab. Every lab reports back through
        // handleLabCompletion, which records dispositions, marks the experiment complete,
        // and checks for track-completion rewards + major story echoes.
        switch experiment.id {
        case "color-mixing":
            ColorMixingLabView(profile: profile, onComplete: handleLabCompletion)
        case "ramp-runners":
            RampRunnersLabView(profile: profile, onComplete: handleLabCompletion)
        case "sound-garden":
            SoundGardenLabView(profile: profile, onComplete: handleLabCompletion)
        case "pattern-garden":
            PatternGardenLabView(profile: profile, onComplete: handleLabCompletion)
        case "mirror-worlds":
            MirrorWorldsLabView(profile: profile, onComplete: handleLabCompletion)
        case "pouring-lab":
            PouringLabView(profile: profile, onComplete: handleLabCompletion)
        case "shadow-play":
            ShadowPlayLabView(profile: profile, onComplete: handleLabCompletion)
        case "balancing-act":
            BalancingActLabView(profile: profile, onComplete: handleLabCompletion)
        case "growing-secrets":
            GrowingSecretsLabView(profile: profile, onComplete: handleLabCompletion)
        case "attribute-detectives":
            AttributeDetectivesLabView(profile: profile, onComplete: handleLabCompletion)
        default:
            // Fallback for any experiment id that doesn't yet have a bespoke lab view.
            VStack(spacing: 16) {
                Text("The Experiment")
                    .font(.sparkHeadline)
                    .foregroundStyle(Color.sparkTextPrimary)

                VStack(spacing: 12) {
                    Text("🧪")
                        .font(.system(size: 48))

                    Text("This is where the magic happens.")
                        .font(.callout)
                        .foregroundStyle(Color.sparkTextSecondary)

                    Text("The interactive experience for this lab will be built here.")
                        .font(.caption)
                        .foregroundStyle(Color.sparkTextTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .sparkCard(cornerRadius: 24)

                Button {
                    hasStartedExperiment = true
                } label: {
                    Text(hasStartedExperiment ? "Return to the Lab" : "Begin the Experiment")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
    }

}

#Preview {
    let profile = ChildProfile(
        name: "Leo",
        grade: .third,
        chosenHeroID: .flint
    )

    NavigationStack {
        ExperimentDetailView(
            experiment: Experiment.all.first { $0.id == "ramp-runners" }!,
            profile: profile
        )
    }
}
