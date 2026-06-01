import Foundation

/// A thematic collection of experiments that form a "Learning Track".
/// Tracks give structure and narrative to exploration while still allowing open discovery.
struct LearningTrack: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let description: String
    let domain: LearningDomain?          // nil = mixed Science + Math
    let primaryDispositions: [LearningDisposition]
    
    /// Ordered list of experiment IDs that belong to this track.
    /// The order suggests a gentle progression, but children can explore in any order.
    let experimentIDs: [String]
    
    /// Hero that has a natural affinity with this track (used for recommendations).
    let signatureHero: HeroID?
}

/// All defined Learning Tracks in the Spark experience.
extension LearningTrack {
    static let all: [LearningTrack] = [
        LearningTrack(
            id: "light-and-color",
            title: "The Language of Light",
            subtitle: "How do colors and shadows speak?",
            description: "Explore how light interacts with the world — mixing colors, casting shadows, and discovering hidden rules of illumination.",
            domain: .science,
            primaryDispositions: [.observation, .prediction, .patterns],
            experimentIDs: ["color-mixing", "shadow-play"],
            signatureHero: .lumi
        ),
        
        LearningTrack(
            id: "forces-and-motion",
            title: "How Things Move",
            subtitle: "What makes things go, stop, or stay balanced?",
            description: "Investigate ramps, gravity, balance, and the surprising ways objects behave when forces act on them.",
            domain: .science,
            primaryDispositions: [.prediction, .iteration, .quantitative],
            experimentIDs: ["ramp-runners", "balancing-act"],
            signatureHero: .flint
        ),
        
        LearningTrack(
            id: "sound-and-vibration",
            title: "The Music of Materials",
            subtitle: "What stories do sounds tell?",
            description: "Discover how different materials vibrate and sing. Listen carefully and create your own sound landscapes.",
            domain: .science,
            primaryDispositions: [.observation, .patterns, .connection],
            experimentIDs: ["sound-garden"],
            signatureHero: .pebby
        ),
        
        LearningTrack(
            id: "patterns-and-structure",
            title: "Finding Patterns",
            subtitle: "What repeats, grows, and mirrors in the world?",
            description: "Build patterns with blocks, explore symmetry with mirrors, and become a detective of hidden rules and structures.",
            domain: nil, // Math + Science crossover
            primaryDispositions: [.patterns, .observation, .prediction],
            experimentIDs: ["pattern-garden", "mirror-worlds", "attribute-detectives"],
            signatureHero: .lumi
        ),
        
        LearningTrack(
            id: "measuring-our-world",
            title: "Measuring Our World",
            subtitle: "How much? How far? How full?",
            description: "Play with volume, weight, distance, and conservation. Discover that things aren't always what they seem at first glance.",
            domain: .math,
            primaryDispositions: [.quantitative, .prediction, .iteration],
            experimentIDs: ["pouring-lab", "balancing-act"],
            signatureHero: .pebby
        ),
        
        LearningTrack(
            id: "watch-it-grow",
            title: "Watch It Grow",
            subtitle: "What does life need to thrive?",
            description: "Observe living things over time. Experiment with what helps seeds wake up and grow strong.",
            domain: .science,
            primaryDispositions: [.observation, .patterns, .connection],
            experimentIDs: ["growing-secrets"],
            signatureHero: .pebby
        )
    ]
    
    static func track(for id: String) -> LearningTrack? {
        all.first { $0.id == id }
    }
    
    /// Returns all experiments that belong to this track.
    var experiments: [Experiment] {
        experimentIDs.compactMap { Experiment.experiment(for: $0) }
    }
}