import Foundation

/// A small, poetic story moment the child can discover.
/// These are the "Echoes" in the background story "The Dimming Shimmer".
struct EchoFragment: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let rarity: Rarity
    
    /// Themes this fragment connects to (used for future personalization)
    let relatedTo: [String]
    
    // MARK: - Final / Major Story Echoes (for climax + world state)
    
    /// True for the rare, emotionally significant "Final Echo Moments" that visibly power the ending.
    /// These receive special treatment in ClimaxView, the hub, and parent Insights.
    let isMajorStoryEcho: Bool
    
    /// Optional machine-readable story beat key used by ClimaxView and HeroDialogueSystem
    /// to customize the Light Returns sequence and hero reactions (e.g. "harmony", "ancient_memory").
    /// Regular echoes leave this nil.
    let storyBeat: String?
}

extension EchoFragment {
    enum Rarity: String, CaseIterable {
        case common
        case uncommon
        case rare
        case legendary
    }
    
    /// All defined Echo Fragments in the current design
    static let all: [EchoFragment] = [
        EchoFragment(
            id: "echo_first_spark",
            title: "The First Spark",
            description: "That tiny moment when something suddenly makes sense. The Shimmer remembers these.",
            rarity: .common,
            relatedTo: ["curiosity", "aha"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_listening_stone",
            title: "A Listening Stone",
            description: "When you slow down and truly watch what happens. The crystals lean in closer.",
            rarity: .common,
            relatedTo: ["observation", "patience"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_two_lights",
            title: "Two Lights Touching",
            description: "When an idea from one place connects to an idea from somewhere else.",
            rarity: .uncommon,
            relatedTo: ["connection", "patterns"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_quiet_question",
            title: "The Quiet Question",
            description: "The soft wondering that comes after an experiment doesn’t go as expected.",
            rarity: .uncommon,
            relatedTo: ["wonder", "resilience"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_hand_held",
            title: "A Hand Held Out",
            description: "When you help someone else see what you saw. The light grows between you.",
            rarity: .uncommon,
            relatedTo: ["teaching", "generosity"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_hidden_glow",
            title: "The Hidden Glow",
            description: "Something that was always there, but only becomes visible when you look in just the right way.",
            rarity: .rare,
            relatedTo: ["discovery", "perspective"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_many_voices",
            title: "Many Voices, One Light",
            description: "When different ways of thinking come together and something new appears.",
            rarity: .rare,
            relatedTo: ["collaboration", "diversity"],
            isMajorStoryEcho: false,
            storyBeat: nil
        ),
        EchoFragment(
            id: "echo_ancient_memory",
            title: "An Ancient Memory",
            description: "A feeling that this pattern, this idea, this wonder… has existed for a very long time.",
            rarity: .legendary,
            relatedTo: ["deep_time", "belonging"],
            isMajorStoryEcho: true,
            storyBeat: "ancient_memory"
        ),
        
        // MARK: - Major Story Echoes (Final Echo Moments)
        // These power the emotional climax and receive special visual + narrative treatment.
        // See FINAL_ECHO_MOMENTS.md for full design, hero reactions, and extension strategy.
        
        EchoFragment(
            id: "echo_harmony_first_crystal",
            title: "The Harmony That Lit the First Crystal",
            description: "When sound and light finally heard each other. The Shimmer took its first real breath.",
            rarity: .legendary,
            relatedTo: ["harmony", "senses", "connection"],
            isMajorStoryEcho: true,
            storyBeat: "harmony"
        ),
        EchoFragment(
            id: "echo_threshold_courage_still",
            title: "The Edge Where Courage Met Stillness",
            description: "A moment of bold action followed by perfect, patient quiet. Both were needed.",
            rarity: .legendary,
            relatedTo: ["courage", "patience", "synthesis"],
            isMajorStoryEcho: true,
            storyBeat: "threshold"
        ),
        EchoFragment(
            id: "echo_seed_whispers_back",
            title: "The Seed That Whispered Back",
            description: "The living world noticed the child noticing it. Something answered.",
            rarity: .legendary,
            relatedTo: ["life", "reciprocity", "deep_observation"],
            isMajorStoryEcho: true,
            storyBeat: "seed_whisper"
        ),
        EchoFragment(
            id: "echo_light_knew_your_name",
            title: "The Light That Knew Your Name",
            description: "The particular quality of wonder the child brought was recognized from far away.",
            rarity: .legendary,
            relatedTo: ["spark", "personal", "chosen"],
            isMajorStoryEcho: true,
            storyBeat: "light_chose_you"
        )
    ]
}
