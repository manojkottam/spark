import Foundation

struct EchoService {
    
    /// Returns the Echo Fragment (if any) that should be triggered for a given mix in the Color Mixing Lab.
    static func echoForColorMix(colors: [String], resultName: String) -> EchoFragment? {
        let hasRed = colors.contains("red")
        let hasYellow = colors.contains("yellow")
        let hasBlue = colors.contains("blue")
        
        if hasRed && hasBlue && resultName.contains("Purple") {
            return EchoFragment.all.first { $0.id == "echo_two_lights" }
        }
        
        if hasYellow && hasBlue && resultName.contains("Green") {
            return EchoFragment.all.first { $0.id == "echo_listening_stone" }
        }
        
        if hasRed && hasYellow && hasBlue {
            return EchoFragment.all.first { $0.id == "echo_hidden_glow" }
        }
        
        if hasRed && hasYellow && resultName.contains("Orange") {
            // Orange is common but special — we can return a common one or none
            return nil
        }
        
        return nil
    }
    
    /// Returns the Echo Fragment (if any) that should be triggered in Ramp Runners.
    static func echoForRampRunners(angle: Double, distance: Double) -> EchoFragment? {
        // Very steep ramp with long distance (dramatic success)
        if angle > 38 && distance > 95 {
            return EchoFragment.all.first { $0.id == "echo_two_lights" }
        }
        
        // Very gentle ramp where it still moves a surprising amount (patience + observation)
        if angle < 18 && distance > 45 {
            return EchoFragment.all.first { $0.id == "echo_listening_stone" }
        }
        
        // Perfect "just right" zone with very consistent result (hidden pattern)
        if angle > 24 && angle < 28 && distance > 70 && distance < 85 {
            return EchoFragment.all.first { $0.id == "echo_hidden_glow" }
        }
        
        return nil
    }
    
    /// Returns a hero-flavored reaction when an Echo Fragment is discovered.
    static func reactionForEcho(_ fragment: EchoFragment, heroID: HeroID) -> String {
        let reactions: [HeroID: [String: String]] = [
            .flint: [
                "echo_two_lights": "Whoa… those two colors just made something brand new! Did you feel that spark?",
                "echo_listening_stone": "That green… it feels alive. Like the colors are talking to each other!",
                "echo_hidden_glow": "All three together made something dark and rich. That was special, wasn’t it?"
            ],
            .pebby: [
                "echo_two_lights": "Friend… when red and blue met, they created something neither of them could make alone. That’s beautiful.",
                "echo_listening_stone": "Yellow and blue together made green, like new leaves. The colors were listening to each other.",
                "echo_hidden_glow": "When all the colors came together… it felt like they were remembering something old and important."
            ],
            .lumi: [
                "echo_two_lights": "Two different lights touched and became something neither expected. The Shimmer noticed.",
                "echo_listening_stone": "Yellow and blue didn’t argue. They listened… and green appeared.",
                "echo_hidden_glow": "When everything mixed, something quiet and deep was revealed. Can you still feel it?"
            ]
        ]
        
        // Add ramp-specific reactions
        let rampReactions: [HeroID: [String: String]] = [
            .flint: [
                "echo_two_lights": "Whoa! When it was super steep it flew! That was a huge discovery!",
                "echo_listening_stone": "Even on the tiny slope it still moved… that’s kind of amazing if you think about it.",
                "echo_hidden_glow": "Right in that sweet spot it went perfectly. I felt something click."
            ],
            .pebby: [
                "echo_two_lights": "The steeper it got, the braver it became. Like the ramp was encouraging it.",
                "echo_listening_stone": "Even when the ramp was almost flat… it still wanted to move. So gentle.",
                "echo_hidden_glow": "There’s a perfect angle where everything feels just right. Did you feel it too?"
            ],
            .lumi: [
                "echo_two_lights": "The steeper the hill, the farther the journey. Some things only reveal themselves at the edge.",
                "echo_listening_stone": "Even the smallest slope can carry something forward, if you’re patient enough to watch.",
                "echo_hidden_glow": "In that narrow band of angles… everything aligned. The Shimmer remembers angles like that."
            ]
        ]
        
        if let rampReaction = rampReactions[heroID]?[fragment.id] {
            return rampReaction
        }
        
        return reactions[heroID]?[fragment.id] ?? fragment.description
    }

    // MARK: - Mirror Worlds Echo Triggers
    static func echoForMirrorWorlds(hasSymmetry: Bool, complexity: Int) -> EchoFragment? {
        if hasSymmetry && complexity >= 5 {
            return EchoFragment.all.first { $0.id == "echo_many_voices" }
        }
        if hasSymmetry && complexity >= 3 {
            return EchoFragment.all.first { $0.id == "echo_two_lights" }
        }
        return nil
    }

    // MARK: - Pouring Lab Echo Triggers
    static func echoForPouringLab(surprise: Bool, accuracy: Double) -> EchoFragment? {
        if surprise && accuracy > 0.85 {
            return EchoFragment.all.first { $0.id == "echo_hidden_glow" }
        }
        if accuracy > 0.9 {
            return EchoFragment.all.first { $0.id == "echo_listening_stone" }
        }
        return nil
    }

    // MARK: - Shadow Play Echo Triggers
    static func echoForShadowPlay(perfectEdge: Bool, multipleLights: Bool) -> EchoFragment? {
        if perfectEdge && multipleLights {
            return EchoFragment.all.first { $0.id == "echo_hidden_glow" }
        }
        if perfectEdge {
            return EchoFragment.all.first { $0.id == "echo_listening_stone" }
        }
        return nil
    }

    // MARK: - Balancing Act Echo Triggers
    static func echoForBalancingAct(perfectBalance: Bool, surprisingLightObject: Bool) -> EchoFragment? {
        if perfectBalance {
            return EchoFragment.all.first { $0.id == "echo_two_lights" }
        }
        if surprisingLightObject {
            return EchoFragment.all.first { $0.id == "echo_hidden_glow" }
        }
        return nil
    }

    // MARK: - Growing Secrets Echo Triggers
    static func echoForGrowingSecrets(consistentCare: Bool, surprisingGrowth: Bool) -> EchoFragment? {
        if consistentCare && surprisingGrowth {
            return EchoFragment.all.first { $0.id == "echo_hidden_glow" }
        }
        if consistentCare {
            return EchoFragment.all.first { $0.id == "echo_listening_stone" }
        }
        return nil
    }

    // MARK: - Attribute Detectives Echo Triggers
    static func echoForAttributeDetectives(clearRule: Bool, elegantRule: Bool) -> EchoFragment? {
        if clearRule && elegantRule {
            return EchoFragment.all.first { $0.id == "echo_many_voices" }
        }
        if clearRule {
            return EchoFragment.all.first { $0.id == "echo_two_lights" }
        }
        return nil
    }
    
    // MARK: - Major Story Echo (Final Echo Moments) Support
    //
    // These are the high-stakes, story-significant echoes that power the climax.
    // See FINAL_ECHO_MOMENTS.md for the full design and emotional mapping.
    // New labs plug in here via additional cases or a future MajorEchoService.
    
    /// Lightweight context passed from a lab on completion so major echo logic
    /// can consider both the immediate result and the child's broader journey.
    struct MajorEchoContext {
        let experimentID: String
        /// True when the child achieved something especially elegant, balanced, or surprising
        /// inside this lab (exact meaning is lab-specific).
        let wasPerfectSynthesis: Bool
        /// 0.0–1.0 score of "how special / deep" this particular run felt.
        let secondaryScore: Double
    }
    
    /// Returns a major story EchoFragment (if any) for this lab completion.
    /// This is the primary extension point for "final echo moments".
    /// Call this *after* regular echo checks and track reward checks.
    static func majorEchoForCompletion(
        context: MajorEchoContext,
        profile: ChildProfile
    ) -> EchoFragment? {
        
        let completed = Set(profile.completedExperimentIDs)
        let hasLightTrack = completed.contains("color-mixing") || completed.contains("shadow-play")
        let hasPatternStrength = profile.strength(for: .patterns) + profile.strength(for: .observation) >= 6
        
        // 1. Harmony That Lit the First Crystal (Sound Garden + prior Light work)
        if context.experimentID == "sound-garden",
           context.wasPerfectSynthesis,
           context.secondaryScore > 0.75,
           hasLightTrack {
            return EchoFragment.all.first { $0.id == "echo_harmony_first_crystal" }
        }
        
        // 2. Ancient Memory (deep pattern synthesis) — promote existing legendary
        // Triggered by high elegance in Pattern Garden or Mirror Worlds when pattern strength is strong.
        if (context.experimentID == "pattern-garden" || context.experimentID == "mirror-worlds"),
           context.wasPerfectSynthesis,
           hasPatternStrength {
            // Avoid duplicates
            if !profile.collectedEchoIDs.contains("echo_ancient_memory") {
                return EchoFragment.all.first { $0.id == "echo_ancient_memory" }
            }
        }
        
        // 3. Threshold (Courage + Stillness) — Forces & Motion synthesis
        // Requires both ramp success (brave) and balancing perfection (still) in journey
        let hasRampProgress = completed.contains("ramp-runners") || context.experimentID == "ramp-runners"
        let hasBalance = completed.contains("balancing-act") || context.experimentID == "balancing-act"
        if (context.experimentID == "ramp-runners" || context.experimentID == "balancing-act"),
           context.wasPerfectSynthesis,
           hasRampProgress && hasBalance,
           context.secondaryScore > 0.7 {
            return EchoFragment.all.first { $0.id == "echo_threshold_courage_still" }
        }
        
        // 4. Seed That Whispered Back (Growing Secrets + prior deep observation)
        let hasObservationDepth = profile.strength(for: .observation) >= 4
        if context.experimentID == "growing-secrets",
           context.wasPerfectSynthesis,
           context.secondaryScore > 0.8,
           hasObservationDepth {
            return EchoFragment.all.first { $0.id == "echo_seed_whispers_back" }
        }
        
        // 5. The Light That Knew Your Name (most personal — high cross-track observation + prediction synthesis)
        // This one is intentionally harder and more personal. It is the direct narrative bridge into the Revelation.
        let strongObservationPrediction = profile.strength(for: .observation) + profile.strength(for: .prediction) >= 7
        let hasMultipleTracks = completed.count >= 4
        if context.wasPerfectSynthesis,
           strongObservationPrediction,
           hasMultipleTracks,
           (context.experimentID == "pattern-garden" || context.experimentID == "shadow-play" || context.experimentID == "color-mixing") {
            // Only award once
            if !profile.collectedEchoIDs.contains("echo_light_knew_your_name") {
                return EchoFragment.all.first { $0.id == "echo_light_knew_your_name" }
            }
        }
        
        return nil
    }
    
    /// Hero-flavored reaction for a *major* story echo. Falls back to the echo description.
    /// These lines are more emotional and reference the child's journey.
    static func reactionForMajorEcho(_ fragment: EchoFragment, heroID: HeroID) -> String {
        guard fragment.isMajorStoryEcho, let beat = fragment.storyBeat else {
            return fragment.description
        }
        
        let reactions: [String: [HeroID: String]] = [
            "harmony": [
                .flint: "That sound… it felt like it wanted to be seen. Like the light was answering back!",
                .pebby: "The three notes held each other so gently. I think the Shimmer just took its first real breath in a long time.",
                .lumi: "You didn’t just make sound. You made the air remember color."
            ],
            "ancient_memory": [
                .flint: "It kept going and going and then… it looked back at us. That was huge.",
                .pebby: "I felt like the beads and the mirrors were telling an old story, and you were the one who could hear the ending.",
                .lumi: "This pattern… it has been waiting for someone to see it this way. It knows your name now."
            ],
            "threshold": [
                .flint: "You weren’t afraid to go all the way to the edge… and then you made everything perfectly quiet. That’s real power.",
                .pebby: "The fast run was exciting. But the moment it just… stayed? That’s what the Shimmer needed most from you.",
                .lumi: "Courage and stillness are not opposites. You showed the crystals both in one afternoon."
            ],
            "seed_whisper": [
                .flint: "It grew because you believed it would. That’s the best kind of experiment.",
                .pebby: "You treated the seed like a friend who was sleeping. And it woke up because it felt you there.",
                .lumi: "The root pushed upward exactly when you were watching most quietly. It was answering you."
            ],
            "light_chose_you": [
                .flint: "You didn’t just play with light. You made it want to stay. That’s why we came.",
                .pebby: "Every quiet question you asked the colors and the shadows… the Shimmer was listening too. It remembered who asked.",
                .lumi: "I felt this exact quality of light from very far away. It was you, all along. Your way of noticing was the map."
            ]
        ]
        
        return reactions[beat]?[heroID] ?? fragment.description
    }
}
