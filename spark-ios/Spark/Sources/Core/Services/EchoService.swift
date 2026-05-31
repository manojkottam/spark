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
}
