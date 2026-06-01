import SwiftUI
import SwiftData

struct MainAppView: View {
    let profile: ChildProfile
    
    @State private var heroDialogue: String = ""
    @State private var showDialogue = false
    @State private var isHeroBreathing = false
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
    
    var body: some View {
        ZStack {
            // Dynamic background that brightens with Echoes
            Color.sparkBackground.ignoresSafeArea()
            
            // Subtle world shimmer layer
            // Major story echoes carry extra visual weight — they are the ones that truly move the ending.
            if echoCount > 0 {
                let base = min(Double(echoCount) / 8.0, 1.0)
                let majorBonus = Double(majorEchoCount) * 0.12
                let brightness = min(base + majorBonus, 1.0)
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.03 * brightness),
                        Color.clear,
                        Color.white.opacity(0.02 * brightness)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            ScrollView {
                VStack(spacing: 28) {
                    // === ADVENTURE HUB HEADER ===
                    VStack(spacing: 8) {
                        Text("The Adventure Hub")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .tracking(1.5)
                        
                        Text("Your Camp in the Story")
                            .font(.sparkTitle)
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
                    
                    // Hero dialogue - more prominent and game-like
                    if showDialogue {
                        Text(heroDialogue)
                            .font(.callout)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 12, y: 4)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
                            )
                            .transition(.scale.combined(with: .opacity))
                            .onTapGesture {
                                withAnimation(.spring) {
                                    showDialogue = false
                                }
                            }
                    } else {
                        Button {
                            triggerHeroDialogue()
                        } label: {
                            Text("Talk to \(hero.name)")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(hero.primaryColor.opacity(0.8))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(hero.primaryColor.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                    
                    // === CURRENT JOURNEY / ACTIVE QUEST ===
                    currentJourneyCard
                    
                    // === PRIMARY GAME ACTIONS ===
                    VStack(spacing: 12) {
                        // Main "Continue Adventure" button
                        if let strongestTrack = progress.strongestTracks.first {
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
                                .background(hero.primaryColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                                .shadow(color: hero.primaryColor.opacity(0.35), radius: 14, y: 6)
                            }
                        }
                        
                        // Secondary actions
                        HStack(spacing: 12) {
                            NavigationLink {
                                JourneyMapView(profile: profile)
                            } label: {
                                Label("Journey Map", systemImage: "map")
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            
                            NavigationLink {
                                ExperimentDiscoveryView(profile: profile)
                            } label: {
                                Label("All Labs", systemImage: "list.bullet")
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            
                            NavigationLink {
                                InsightsView(profile: profile)
                            } label: {
                                Label("Journal", systemImage: "book")
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 60)
                    
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
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Text("Unlock the Full Story →")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .padding(.top, 6)
                                    .foregroundStyle(hero.primaryColor)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(hero.primaryColor.opacity(0.25), lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    }
                    
                    // Teaser for the approaching climax.
                    // Now gated more meaningfully on major story echoes (the "final echo moments")
                    // plus overall journey progress. This is the narrative signal that the ending is near.
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
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("A final moment is approaching…")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .onAppear {
            // Set initial contextual dialogue
            heroDialogue = getContextualDialogue()
            
            // Check if we just completed something meaningful
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
                // In the future we can return to a post-ending hub state here
            }
        }
        .sheet(isPresented: $showUnlockSheet) {
            UnlockFullStoryView(profile: profile, hero: hero) {
                showUnlockSheet = false
                
                if profile.hasFullUnlock {
                    // Hero reaction to unlocking the full story
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
    
    // MARK: - Current Journey Card (Strong Track Focus)
    
    private var currentJourneyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Current Journey")
                .font(.sparkCallout)
                .foregroundStyle(.secondary)
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
                        .foregroundStyle(.secondary)
                }
                .padding(20)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
            } else {
                Text("Begin your first adventure to start your journey.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Hero Interaction
    
    private func triggerHeroDialogue() {
        // If the child has earned major story echoes, the hero occasionally references them directly.
        // This makes the companion feel like they remember the child's specific journey.
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
        
        // Auto-hide after a few seconds (longer for special lines)
        let hideDelay = (majorLine != nil || echoCount >= 5) ? 6.0 : 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + hideDelay) {
            withAnimation(.spring) {
                showDialogue = false
            }
        }
    }
    
    private func getContextualDialogue() -> String {
        let base = HeroDialogueSystem.getGreeting(
            for: profile,
            hero: hero,
            echoCount: echoCount,
            strongestTrack: progress.strongestTracks.first
        )
        
        // Late game: prefer a direct reference to a major story echo the child actually earned.
        if majorEchoCount > 0, let majorRef = HeroDialogueSystem.getMajorEchoReferenceLine(hero: hero, majorEchoes: majorEchoes) {
            return "\(base)\n\n\(majorRef)"
        }
        
        // Occasionally add an ending tease when very close to the climax
        let tease = HeroDialogueSystem.getEndingTeaseLine(hero: hero, echoCount: echoCount)
        if echoCount >= 6 && !tease.isEmpty {
            return "\(base)\n\n\(tease)"
        }
        
        return base
    }
    
    // MARK: - Track Completion Celebration (More Visual & Special)
    
    func checkAndShowTrackCompletionCelebration() {
        let newlyEarned = progress.checkForTrackCompletionRewards()
        guard !newlyEarned.isEmpty else { return }
        
        // Present the full beautiful celebration sheet
        pendingTrackRewards = newlyEarned
        
        // Also show a quick hero line on the hub
        if let track = progress.strongestTracks.first {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                heroDialogue = HeroDialogueSystem.getTrackCompletionLine(for: track, hero: hero)
                showDialogue = true
            }
        }
    }
    
    // MARK: - Story / World State (Tied to Emotional Ending)
    
    private var storyWorldState: some View {
        VStack(spacing: 8) {
            let base = min(Double(echoCount) / 8.0, 1.0)
            let majorBonus = Double(majorEchoCount) * 0.12
            let brightness = min(base + majorBonus, 1.0)
            
            VStack(spacing: 6) {
                Text(worldStateMessage(brightness: brightness))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                // Visual representation of The Shimmer's returning light
                HStack(spacing: 3) {
                    ForEach(0..<8, id: \.self) { i in
                        let isLit = Double(i) < (brightness * 8)
                        ZStack {
                            Circle()
                                .fill(isLit ? hero.primaryColor : Color.gray.opacity(0.12))
                                .frame(width: 6, height: 6)
                            
                            if isLit && echoCount >= 6 {
                                CrystalSparkle(color: .white, size: 2.5, delay: Double(i) * 0.15)
                                    .scaleEffect(0.6)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, 24)
    }
    
    private func worldStateMessage(brightness: Double) -> String {
        // When the child has created major story echoes, the world state language becomes
        // more personal and urgent — these are the moments the Shimmer itself remembers.
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
