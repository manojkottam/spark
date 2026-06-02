import SwiftUI
import SwiftData

struct MainAppView: View {
    let profile: ChildProfile

    @State private var heroDialogue: String = ""
    @State private var showDialogue = false
    @State private var pendingTrackRewards: [EchoFragment] = []
    @State private var showClimax = false
    @State private var showUnlockSheet = false   // One-time "buy to unlock all" flow

    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }

    private var progress: LearningProgress {
        LearningProgress(profile: profile)
    }

    private var echoCount: Int {
        profile.collectedEchoIDs.count
    }

    /// Major story echoes the child has created. These are the ones that truly move the ending forward.
    private var majorEchoes: [EchoFragment] {
        profile.collectedEchoIDs.compactMap { id in
            EchoFragment.all.first { $0.id == id && $0.isMajorStoryEcho }
        }
    }

    private var majorEchoCount: Int { majorEchoes.count }

    /// 0...1 — how much light has returned to the world (drives the background glow).
    private var worldBrightness: Double {
        let base = min(Double(echoCount) / 8.0, 1.0)
        return min(base + Double(majorEchoCount) * 0.12, 1.0)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SparkBackground(accent: hero.primaryColor, brightness: worldBrightness)

                ScrollView {
                    VStack(spacing: 28) {
                        // === ADVENTURE HUB HEADER ===
                        VStack(spacing: 8) {
                            Text("The Adventure Hub")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.sparkTextSecondary)
                                .tracking(1.5)

                            Text("Your Camp in the Story")
                                .font(.sparkTitle)
                                .foregroundStyle(Color.sparkTextPrimary)
                        }
                        .padding(.top, 16)

                        // === LIVING HERO (Game-like Companion) ===
                        AnimatedHeroView(
                            hero: hero,
                            echoCount: echoCount,
                            mood: HeroDialogueSystem.currentMood(
                                echoCount: echoCount,
                                recentlyCompletedTrack: false
                            )
                        ) {
                            triggerHeroDialogue()
                        }
                        .padding(.top, 8)

                        // Hero dialogue
                        if showDialogue {
                            Text(heroDialogue)
                                .font(.callout)
                                .foregroundStyle(Color.sparkTextPrimary)
                                .multilineTextAlignment(.center)
                                .padding(16)
                                .sparkCard(cornerRadius: 20)
                                .padding(.horizontal, 24)
                                .transition(.scale.combined(with: .opacity))
                                .onTapGesture {
                                    withAnimation(.spring) { showDialogue = false }
                                }
                        } else {
                            Button {
                                triggerHeroDialogue()
                            } label: {
                                Text("Talk to \(hero.name)")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(hero.primaryColor)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(hero.primaryColor.opacity(0.16))
                                    .clipShape(Capsule())
                            }
                        }

                        // === CURRENT JOURNEY / ACTIVE QUEST ===
                        currentJourneyCard

                        // === PRIMARY GAME ACTIONS ===
                        VStack(spacing: 12) {
                            if progress.strongestTracks.first != nil {
                                NavigationLink {
                                    ExperimentDiscoveryView(profile: profile)
                                } label: {
                                    HStack {
                                        Text("Continue Your Adventure")
                                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                                        Text("→")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(hero.primaryColor.sparkAccentGradient)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                                    .sparkGlow(hero.primaryColor, radius: 16, opacity: 0.5)
                                }
                            }

                            // Secondary actions
                            HStack(spacing: 12) {
                                NavigationLink {
                                    JourneyMapView(profile: profile)
                                } label: {
                                    hubTile("Journey Map", systemImage: "map")
                                }

                                NavigationLink {
                                    ExperimentDiscoveryView(profile: profile)
                                } label: {
                                    hubTile("All Labs", systemImage: "list.bullet")
                                }

                                NavigationLink {
                                    InsightsView(profile: profile)
                                } label: {
                                    hubTile("Journal", systemImage: "book")
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        Spacer(minLength: 40)

                        // === STORY / WORLD STATE (Tied to Ending) ===
                        storyWorldState

                        // Unlock teaser (only shown in free tier)
                        if !profile.hasFullUnlock {
                            Button {
                                showUnlockSheet = true
                            } label: {
                                VStack(spacing: 8) {
                                    Text("The full story of The Shimmer is waiting.")
                                        .font(.headline)
                                        .foregroundStyle(hero.primaryColor)
                                        .multilineTextAlignment(.center)

                                    Text("Unlock every lab and the complete ending with one purchase.")
                                        .font(.callout)
                                        .foregroundStyle(Color.sparkTextSecondary)
                                        .multilineTextAlignment(.center)

                                    Text("Unlock the Full Story →")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .padding(.top, 6)
                                        .foregroundStyle(hero.primaryColor)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 16)
                                .sparkCard(cornerRadius: 20, accentBorder: hero.primaryColor)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        }

                        // Teaser for the approaching climax.
                        if (majorEchoCount >= 1 && echoCount >= 5) || progress.strongestTracks.count >= 3 {
                            Button {
                                showClimax = true
                            } label: {
                                VStack(spacing: 4) {
                                    Text("The Shimmer Calls")
                                        .font(.headline)
                                        .foregroundStyle(hero.primaryColor)
                                    if majorEchoCount >= 2 {
                                        Text("The moments you created are ready to change everything.")
                                            .font(.caption)
                                            .foregroundStyle(Color.sparkTextSecondary)
                                    } else {
                                        Text("A final moment is approaching…")
                                            .font(.caption)
                                            .foregroundStyle(Color.sparkTextSecondary)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .sparkCard(cornerRadius: 18, accentBorder: hero.primaryColor)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        }

                        Spacer(minLength: 20)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                heroDialogue = getContextualDialogue()
                checkAndShowTrackCompletionCelebration()
            }
            .sheet(isPresented: Binding(
                get: { !pendingTrackRewards.isEmpty },
                set: { if !$0 { pendingTrackRewards = [] } }
            )) {
                TrackRewardCelebrationView(
                    rewards: pendingTrackRewards,
                    hero: hero,
                    onDismiss: { pendingTrackRewards = [] }
                )
            }
            .fullScreenCover(isPresented: $showClimax) {
                ClimaxView(profile: profile) {
                    showClimax = false
                }
            }
            .sheet(isPresented: $showUnlockSheet) {
                UnlockFullStoryView(profile: profile, hero: hero) {
                    showUnlockSheet = false

                    if profile.hasFullUnlock {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.spring) {
                                heroDialogue = HeroDialogueSystem.getFullUnlockLine(for: hero)
                                showDialogue = true
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Hub Tile

    private func hubTile(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.sparkTextPrimary)
            .symbolRenderingMode(.hierarchical)
            .tint(hero.primaryColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .sparkCard(cornerRadius: 18)
    }

    // MARK: - Current Journey Card (Strong Track Focus)

    private var currentJourneyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Current Journey")
                .font(.sparkCallout)
                .foregroundStyle(Color.sparkTextSecondary)
                .padding(.horizontal, 4)

            if let strongestTrack = progress.strongestTracks.first {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(strongestTrack.title)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(hero.primaryColor)

                        Spacer()

                        let trackProgress = progress.progress(for: strongestTrack)
                        Text("\(Int(trackProgress * 100))%")
                            .font(.caption.bold())
                            .foregroundStyle(hero.primaryColor)
                    }

                    ProgressView(value: progress.progress(for: strongestTrack))
                        .tint(hero.primaryColor)

                    Text(strongestTrack.subtitle)
                        .font(.callout)
                        .foregroundStyle(Color.sparkTextSecondary)
                }
                .padding(20)
                .sparkCard(cornerRadius: 22)
            } else {
                Text("Begin your first adventure to start your journey.")
                    .font(.callout)
                    .foregroundStyle(Color.sparkTextSecondary)
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Hero Interaction

    private func triggerHeroDialogue() {
        let majorLine = (majorEchoCount > 0) ? HeroDialogueSystem.getMajorEchoReferenceLine(hero: hero, majorEchoes: majorEchoes) : nil

        let newLine = majorLine ?? HeroDialogueSystem.getRandomTapLine(
            hero: hero,
            echoCount: echoCount,
            strongestTrack: progress.strongestTracks.first
        )

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            heroDialogue = newLine
            showDialogue = true
        }

        let hideDelay = (majorLine != nil || echoCount >= 5) ? 6.0 : 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + hideDelay) {
            withAnimation(.spring) { showDialogue = false }
        }
    }

    private func getContextualDialogue() -> String {
        let base = HeroDialogueSystem.getGreeting(
            for: profile,
            hero: hero,
            echoCount: echoCount,
            strongestTrack: progress.strongestTracks.first
        )

        if majorEchoCount > 0, let majorRef = HeroDialogueSystem.getMajorEchoReferenceLine(hero: hero, majorEchoes: majorEchoes) {
            return "\(base)\n\n\(majorRef)"
        }

        let tease = HeroDialogueSystem.getEndingTeaseLine(hero: hero, echoCount: echoCount)
        if echoCount >= 6 && !tease.isEmpty {
            return "\(base)\n\n\(tease)"
        }

        return base
    }

    // MARK: - Track Completion Celebration

    func checkAndShowTrackCompletionCelebration() {
        let newlyEarned = progress.checkForTrackCompletionRewards()
        guard !newlyEarned.isEmpty else { return }

        pendingTrackRewards = newlyEarned

        if let track = progress.strongestTracks.first {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                heroDialogue = HeroDialogueSystem.getTrackCompletionLine(for: track, hero: hero)
                showDialogue = true
            }
        }
    }

    // MARK: - Story / World State (Tied to Emotional Ending)

    private var storyWorldState: some View {
        VStack(spacing: 6) {
            Text(worldStateMessage(brightness: worldBrightness))
                .font(.caption)
                .foregroundStyle(Color.sparkTextSecondary)
                .multilineTextAlignment(.center)

            // Visual representation of The Shimmer's returning light
            HStack(spacing: 4) {
                ForEach(0..<8, id: \.self) { i in
                    let isLit = Double(i) < (worldBrightness * 8)
                    ZStack {
                        Circle()
                            .fill(isLit ? hero.primaryColor : Color.white.opacity(0.14))
                            .frame(width: 7, height: 7)
                            .sparkGlow(isLit ? hero.primaryColor : .clear, radius: 6, opacity: 0.9, y: 0)

                        if isLit && echoCount >= 6 {
                            CrystalSparkle(color: .white, size: 2.5, delay: Double(i) * 0.15)
                                .scaleEffect(0.6)
                        }
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .sparkCard(cornerRadius: 14)
        .padding(.horizontal, 24)
    }

    private func worldStateMessage(brightness: Double) -> String {
        if majorEchoCount >= 2 {
            return "The biggest lights are yours. The Shimmer is waiting for what you will do with them."
        } else if majorEchoCount == 1 {
            return "One of your moments was so strong the crystals are still echoing it. We are close now."
        }

        if brightness < 0.15 {
            return "The Shimmer is still dim, but every discovery brings a little more light."
        } else if brightness < 0.4 {
            return "A few small lights have begun to flicker again."
        } else if brightness < 0.7 {
            return "The crystals are starting to remember. The world feels a little more alive."
        } else if brightness < 0.9 {
            return "The Shimmer is brightening. Your wonder is making a real difference."
        } else {
            return "The light is returning in force. We are approaching something that will change everything."
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
