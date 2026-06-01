import SwiftUI

/// Sketch of the emotional climax / Final Echo sequence.
/// This is intentionally a high-level prototype that can be expanded
/// with new labs, more story beats, and richer animations later.
struct ClimaxView: View {
    let profile: ChildProfile
    let onComplete: () -> Void   // Called when the player finishes the ending
    
    @State private var phase: ClimaxPhase = .revelation
    @State private var shimmerIntensity: Double = 0.3
    @State private var heroScale: CGFloat = 1.0
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var echoCount: Int {
        profile.collectedEchoIDs.count
    }
    
    /// All major story echoes the child has earned. These drive the emotional weight
    /// and visual intensity of the Light Returns sequence.
    private var majorEchoes: [EchoFragment] {
        profile.collectedEchoIDs.compactMap { id in
            EchoFragment.all.first { $0.id == id && $0.isMajorStoryEcho }
        }
    }
    
    private var majorEchoCount: Int { majorEchoes.count }
    
    /// The storyBeat keys the child has earned (used for hero lines + visual customization).
    private var earnedStoryBeats: Set<String> {
        Set(majorEchoes.compactMap { $0.storyBeat })
    }
    
    enum ClimaxPhase {
        case revelation          // Hero reveals why the child's Spark was special
        case finalEcho           // The moment the child helps create the big Echo
        case lightReturns        // Big visual transformation of the world
        case farewells           // Personal goodbyes from the heroes
        case bittersweetClose    // Hopeful ending + tease of future
    }
    
    var body: some View {
        ZStack {
            // Dynamic background that dramatically brightens during the climax
            Color.sparkBackground.ignoresSafeArea()
            
            // The Shimmer's returning light effect (will become much richer later)
            LinearGradient(
                colors: [
                    Color.white.opacity(0.08 * shimmerIntensity),
                    Color.clear,
                    Color.white.opacity(0.05 * shimmerIntensity)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Lots of shimmer particles during the big moments (expand this heavily with new labs)
            // Intensity scales with major story echoes earned — each one adds "weight" to the restoration.
            if phase == .lightReturns || phase == .farewells {
                let particleCount = 12 + min(majorEchoCount * 4, 16)
                ForEach(0..<particleCount, id: \.self) { i in
                    CrystalSparkle(
                        color: hero.primaryColor,
                        size: CGFloat.random(in: 3.5...5.5),
                        delay: Double(i) * 0.12
                    )
                    .offset(
                        x: CGFloat.random(in: -220...220),
                        y: CGFloat.random(in: -340...340)
                    )
                    .opacity(0.65 + Double.random(in: 0...0.35))
                }
            }
            
            VStack(spacing: 28) {
                // Hero presence (larger and more emotional during climax)
                ZStack {
                    Circle()
                        .fill(hero.primaryColor.opacity(0.15 + shimmerIntensity * 0.25))
                        .frame(width: 160, height: 160)
                        .scaleEffect(heroScale)
                    
                    Text(hero.emoji)
                        .font(.system(size: 92))
                        .scaleEffect(heroScale)
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: heroScale)
                
                // Phase-specific content
                Group {
                    switch phase {
                    case .revelation:
                        revelationPhase
                    case .finalEcho:
                        finalEchoPhase
                    case .lightReturns:
                        lightReturnsPhase
                    case .farewells:
                        farewellsPhase
                    case .bittersweetClose:
                        bittersweetClosePhase
                    }
                }
                .transition(.opacity.combined(with: .scale))
                
                Spacer()
                
                // Progression button (will become more contextual per phase)
                Button {
                    advancePhase()
                } label: {
                    Text(phaseButtonTitle)
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .padding(.top, 60)
        }
    }
    
    // MARK: - Phase Views
    
    private var revelationPhase: some View {
        VStack(spacing: 16) {
            Text("The Revelation")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor.opacity(0.7))
            
            Text(heroRevelationText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Text("Your way of seeing the world… it has always been special.")
                .font(.callout.italic())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var finalEchoPhase: some View {
        VStack(spacing: 16) {
            Text("The Final Echo")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor.opacity(0.7))
            
            Text(finalEchoNarrativeText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            if !majorEchoes.isEmpty {
                Text("Because of the moments you created, the light has a chance to return.")
                    .font(.callout.italic())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            } else {
                Text("Your strongest way of seeing is what the Shimmer needed most.")
                    .font(.callout.italic())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    /// Narrative text for the Final Echo phase that acknowledges specific major echoes when present.
    private var finalEchoNarrativeText: String {
        if earnedStoryBeats.contains("light_chose_you") {
            return "Everything you’ve noticed, everything you’ve wondered… the light itself was waiting for exactly your way of seeing."
        } else if earnedStoryBeats.contains("seed_whisper") {
            return "You didn’t just help the world grow. Something living answered you back. That changed everything."
        } else if earnedStoryBeats.contains("harmony") {
            return "When sound and light touched because of you, the Shimmer remembered it had a voice."
        } else if earnedStoryBeats.contains("threshold") {
            return "You showed both courage at the edge and perfect stillness. The crystals needed someone who could do both."
        } else if earnedStoryBeats.contains("ancient_memory") {
            return "You found a pattern so old and true that it recognized itself in your hands."
        } else {
            return "Everything you’ve noticed, everything you’ve wondered, every time you tried again… it all led here."
        }
    }
    
    private var lightReturnsPhase: some View {
        VStack(spacing: 16) {
            Text("The Light Returns")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor.opacity(0.7))
            
            Text(lightReturnsNarrativeText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            // Dynamic visual intensity based on major echoes earned.
            // Each major echo adds distinct personality to the transformation.
            ZStack {
                // Base shimmer burst
                Text(majorEchoCount >= 3 ? "✨🌟✨" : majorEchoCount >= 1 ? "✨🌟" : "✨")
                    .font(.system(size: 68))
                    .padding(.vertical, 12)
                
                // Future hook: different particle styles per storyBeat
                // e.g. "harmony" could add soft resonant rings, "seed_whisper" living green growth,
                // "threshold" a bright flash that slowly sustains, etc.
                if earnedStoryBeats.contains("seed_whisper") {
                    Text("🌱")
                        .font(.system(size: 42))
                        .offset(y: 30)
                        .opacity(0.9)
                }
                if earnedStoryBeats.contains("harmony") {
                    Text("🎵")
                        .font(.system(size: 32))
                        .offset(x: -60, y: -20)
                        .opacity(0.7)
                }
            }
            
            if majorEchoCount > 0 {
                Text("\(majorEchoCount) major moments you created are helping the world remember.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var lightReturnsNarrativeText: String {
        if majorEchoCount >= 3 {
            return "Because of the moments you created — the harmony, the courage, the living answer — the light is returning in force."
        } else if earnedStoryBeats.contains("light_chose_you") {
            return "The particular light you brought was the one the Shimmer had been missing. It is coming home."
        } else if earnedStoryBeats.contains("seed_whisper") {
            return "Because something living whispered back to you, the crystals are remembering how to grow again."
        } else if earnedStoryBeats.contains("harmony") {
            return "Sound and light have found each other again because you listened for both."
        } else {
            return "Because of you, the crystals are remembering how to shine."
        }
    }
    
    private var farewellsPhase: some View {
        VStack(spacing: 16) {
            Text("A Personal Goodbye")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor.opacity(0.7))
            
            Text(heroFarewellText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private var bittersweetClosePhase: some View {
        VStack(spacing: 16) {
            Text("The Story Continues")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor.opacity(0.7))
            
            Text("The Shimmer is brighter because of you. But there is still wonder left in the world to find… and new tracks waiting to be explored.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Text("The light remembers your name.")
                .font(.callout.italic())
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Hero Text (Personalized)
    
    private var heroRevelationText: String {
        // When the child earned the most personal major echo, make the revelation hit harder.
        if earnedStoryBeats.contains("light_chose_you") {
            switch hero.id {
            case .lumi:
                return "I didn’t come looking for any child. I came looking for the one whose Spark burned with a very particular kind of wonder. That Spark was yours, \(profile.name). I felt it from the very beginning."
            case .flint:
                return "We didn’t just need a brave question-asker. We needed the one who could make light want to stay. That was always you."
            case .pebby:
                return "I came looking for the child who would notice the quiet things so gently that the world would answer back. That kindness was yours."
            }
        }
        
        switch hero.id {
        case .flint:
            return "I came looking for someone brave enough to keep asking big questions even when things got hard. That was always you, \(profile.name)."
        case .pebby:
            return "I came looking for someone who would notice the quiet, gentle things. The kindness between ideas. That was you."
        case .lumi:
            return "I didn’t come looking for any child. I came looking for the one whose Spark burned with a very particular kind of wonder. That Spark was yours."
        }
    }
    
    private var heroFarewellText: String {
        // Prefer a personalized reference if the child earned a particularly meaningful major echo for this hero.
        if earnedStoryBeats.contains("light_chose_you") && hero.id == .lumi {
            return "Your way of seeing was the map. Because of you, the light knows it is allowed to return. I will never forget."
        }
        if earnedStoryBeats.contains("seed_whisper") && hero.id == .pebby {
            return "You made the living world feel seen. I will carry that answer with me forever. Thank you, friend."
        }
        if earnedStoryBeats.contains("threshold") && hero.id == .flint {
            return "You ran to the edge and then made everything perfectly still. That courage and that quiet — both changed the story."
        }
        
        switch hero.id {
        case .flint:
            return "You never stopped trying. That courage changed everything. The Shimmer will always carry your fire."
        case .pebby:
            return "You saw the small, beautiful connections. I will carry every single one with me. Thank you for being my friend."
        case .lumi:
            return "You listened when the world was loud. Because of you, the crystals remember how to sing. I will never forget."
        }
    }
    
    // MARK: - Flow
    
    private var phaseButtonTitle: String {
        switch phase {
        case .revelation: "I’m listening…"
        case .finalEcho: "I’m ready"
        case .lightReturns: "Watch the light return"
        case .farewells: "Hear their goodbyes"
        case .bittersweetClose: "The story continues…"
        }
    }
    
    private func advancePhase() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
            switch phase {
            case .revelation:
                phase = .finalEcho
                heroScale = 1.08
            case .finalEcho:
                phase = .lightReturns
                shimmerIntensity = 0.9
                heroScale = 1.0
            case .lightReturns:
                phase = .farewells
                shimmerIntensity = 1.0
            case .farewells:
                phase = .bittersweetClose
            case .bittersweetClose:
                onComplete()
            }
        }
    }
    
}

// MARK: - Future Expansion Notes (for new labs & story)
//
// This file is intentionally designed to become richer as more Final Echo Moments are added.
// See FINAL_ECHO_MOMENTS.md for the complete design philosophy and trigger strategy.
//
// HOW TO ADD A NEW MAJOR ECHO FROM A FUTURE LAB:
// 1. Define the new EchoFragment in EchoFragment.swift with isMajorStoryEcho = true + a storyBeat.
// 2. Add hero reactions in EchoService.reactionForMajorEcho (or the lab itself).
// 3. Add a trigger case inside EchoService.majorEchoForCompletion (or a future MajorEchoService).
// 4. (Optional but powerful) Add a small visual customization in lightReturnsPhase or a new
//    "storyBeatVisuals" view that reacts to the new beat (e.g. "fractal_memory" adds recursive sparkle patterns).
// 5. Add 1–2 late-game references in HeroDialogueSystem.
// 6. The climax, hub world state, and parent journal automatically become more meaningful.
//
// PLANNED RICHES (leave room):
// - Different climax paths based on the child's strongest disposition
//   (e.g., a "Flint-heavy" ending feels more explosive and courageous,
//    a "Lumi-heavy" ending feels more quiet and profound).
// - An interactive "Final Echo" creation moment inside this view itself
//   (child combines symbols from their earned major echoes to create one ultimate restoration echo).
// - Per-major-echo particle systems / color shifts / subtle sound layers (when audio is added).
// - A post-climax "The Shimmer Remembers" gallery in the hub that replays the child's major moments
//   with the exact hero reaction they received at the time.
//
// The emotional core stays the same: the child's unique way of seeing was the missing piece.

#Preview {
    let profile = ChildProfile(
        name: "Alex",
        grade: .fourth,
        chosenHeroID: .lumi
    )
    
    ClimaxView(profile: profile) {
        print("Climax completed – future content would go here")
    }
}
