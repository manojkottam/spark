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
            relatedTo: ["curiosity", "aha"]
        ),
        EchoFragment(
            id: "echo_listening_stone",
            title: "A Listening Stone",
            description: "When you slow down and truly watch what happens. The crystals lean in closer.",
            rarity: .common,
            relatedTo: ["observation", "patience"]
        ),
        EchoFragment(
            id: "echo_two_lights",
            title: "Two Lights Touching",
            description: "When an idea from one place connects to an idea from somewhere else.",
            rarity: .uncommon,
            relatedTo: ["connection", "patterns"]
        ),
        EchoFragment(
            id: "echo_quiet_question",
            title: "The Quiet Question",
            description: "The soft wondering that comes after an experiment doesn’t go as expected.",
            rarity: .uncommon,
            relatedTo: ["wonder", "resilience"]
        ),
        EchoFragment(
            id: "echo_hand_held",
            title: "A Hand Held Out",
            description: "When you help someone else see what you saw. The light grows between you.",
            rarity: .uncommon,
            relatedTo: ["teaching", "generosity"]
        ),
        EchoFragment(
            id: "echo_hidden_glow",
            title: "The Hidden Glow",
            description: "Something that was always there, but only becomes visible when you look in just the right way.",
            rarity: .rare,
            relatedTo: ["discovery", "perspective"]
        ),
        EchoFragment(
            id: "echo_many_voices",
            title: "Many Voices, One Light",
            description: "When different ways of thinking come together and something new appears.",
            rarity: .rare,
            relatedTo: ["collaboration", "diversity"]
        ),
        EchoFragment(
            id: "echo_ancient_memory",
            title: "An Ancient Memory",
            description: "A feeling that this pattern, this idea, this wonder… has existed for a very long time.",
            rarity: .legendary,
            relatedTo: ["deep_time", "belonging"]
        )
    ]
}
