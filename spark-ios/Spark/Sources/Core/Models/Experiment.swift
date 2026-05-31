import Foundation

/// Represents a single interactive learning experience (a "Lab").
/// This is the core content unit that will scale across Science and Math.
struct Experiment: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String?
    
    /// A short, warm description of what the child will actually do and explore.
    let description: String
    
    /// Primary domain. We may allow secondary domains later.
    let domain: LearningDomain
    
    /// Suggested starting grade. The actual experience can adapt via the Hero + Grade lens.
    let suggestedGradeRange: ClosedRange<Int> // 0 = Kindergarten, 1 = 1st, etc.
    
    /// Which core dispositions this experiment primarily develops.
    /// Used for personalization, recommendations, and parent insights.
    let primaryDispositions: [LearningDisposition]
    
    /// Optional secondary dispositions.
    let secondaryDispositions: [LearningDisposition]
    
    /// Short poetic or intriguing description shown in discovery surfaces.
    let hook: String
    
    /// Whether this experiment has meaningful story integration (Echo Fragments).
    let supportsEchoFragments: Bool
    
    /// Rough complexity level (can be used for adaptive difficulty).
    let baseComplexity: Int // 1–5
    
    /// Optional notes on how each hero tends to approach this experiment.
    /// This helps writers and designers when creating hero-specific dialogue and prompts.
    let heroApproachNotes: [HeroID: String]?
}

/// High-level learning domains we currently support.
enum LearningDomain: String, CaseIterable, Codable, Hashable {
    case science = "Science"
    case math = "Math"
    
    var emoji: String {
        switch self {
        case .science: "🔬"
        case .math: "🔢"
        }
    }
}

// MARK: - Sample Data (for early development & previews)
extension Experiment {
    static let all: [Experiment] = [
        // Existing
        Experiment(
            id: "color-mixing",
            title: "Color Mixing Lab",
            subtitle: "What happens when colors meet?",
            description: "Children mix primary colors using their hands or droppers and observe what new colors appear. Strong focus on careful observation and making predictions before mixing.",
            domain: .science,
            suggestedGradeRange: 0...5,
            primaryDispositions: [.observation, .prediction, .iteration],
            secondaryDispositions: [.patterns, .connection],
            hook: "Mix colors with your hands and discover what they become.",
            supportsEchoFragments: true,
            baseComplexity: 2,
            heroApproachNotes: [
                .flint: "Loves big, surprising reactions. Encourages bold mixing and celebrating dramatic color changes.",
                .pebby: "Notices the quiet beauty in how colors 'meet' each other. Asks gentle questions about what the colors might be feeling.",
                .lumi: "Draws attention to subtle shifts and the 'in-between' moments. Asks poetic questions like 'What do you think the colors are whispering?'"
            ]
        ),
        
        Experiment(
            id: "balancing-act",
            title: "The Balancing Act",
            subtitle: "Can you make it stand?",
            description: "Children explore balance using blocks, natural materials, and simple platforms. They predict what will stay up, test their ideas, and iterate when things fall.",
            domain: .math,
            suggestedGradeRange: 1...5,
            primaryDispositions: [.prediction, .iteration, .quantitative],
            secondaryDispositions: [.patterns, .observation],
            hook: "Explore balance, weight, and symmetry through building.",
            supportsEchoFragments: true,
            baseComplexity: 3,
            heroApproachNotes: [
                .flint: "Treats it like a daring construction challenge. Celebrates dramatic collapses as exciting experiments.",
                .pebby: "Focuses on patience and gentle adjustments. Notices when something feels 'just right'.",
                .lumi: "Sees beauty in symmetry and the quiet moment when everything becomes perfectly still."
            ]
        ),
        
        Experiment(
            id: "shadow-play",
            title: "Shadow Play",
            subtitle: "Where does the darkness come from?",
            description: "Using light sources and objects, children investigate how shadows are made, how they change size and shape, and what happens when multiple lights or objects interact.",
            domain: .science,
            suggestedGradeRange: 0...4,
            primaryDispositions: [.observation, .patterns, .connection],
            secondaryDispositions: [.prediction],
            hook: "Play with light and discover the secret rules of shadows.",
            supportsEchoFragments: true,
            baseComplexity: 2,
            heroApproachNotes: [
                .flint: "Wants to make the biggest, scariest, or funniest shadows possible.",
                .pebby: "Notices how shadows can look like animals or stories. Collects 'shadow friends'.",
                .lumi: "Obsessed with the edge where light meets dark. Asks deep questions about where shadows go when the light leaves."
            ]
        ),
        
        // New experiments
        
        Experiment(
            id: "ramp-runners",
            title: "Ramp Runners",
            subtitle: "How fast will it go?",
            description: "Children build ramps of different heights and angles, then test how far and fast different objects roll or slide. Strong emphasis on changing one variable at a time and making predictions.",
            domain: .science,
            suggestedGradeRange: 1...5,
            primaryDispositions: [.prediction, .iteration, .quantitative],
            secondaryDispositions: [.observation, .patterns],
            hook: "Build ramps and discover what makes things go faster or slower.",
            supportsEchoFragments: true,
            baseComplexity: 3,
            heroApproachNotes: [
                .flint: "Wants to make things go as fast as possible. Loves dramatic crashes at the bottom.",
                .pebby: "Notices which objects feel 'brave' or 'shy' on the ramp. Enjoys gentle, careful testing.",
                .lumi: "Becomes fascinated by the moment an object is about to move. Asks 'What is the ramp whispering to the ball?'"
            ]
        ),
        
        Experiment(
            id: "sound-garden",
            title: "The Sound Garden",
            subtitle: "What does this material sing?",
            description: "Using simple shakers, strings, tubes, and natural materials, children explore how different objects create different sounds and vibrations. They predict what will be loud or quiet, high or low.",
            domain: .science,
            suggestedGradeRange: 0...4,
            primaryDispositions: [.observation, .prediction, .patterns],
            secondaryDispositions: [.connection],
            hook: "Make sounds with everyday objects and discover their hidden voices.",
            supportsEchoFragments: true,
            baseComplexity: 2,
            heroApproachNotes: [
                .flint: "Loves making the loudest, wildest sounds. Turns it into a sound explosion experiment.",
                .pebby: "Listens for soft, gentle sounds. Tries to make sounds that feel like a lullaby or a story.",
                .lumi: "Hears the 'personality' in each material. Asks children to close their eyes and describe what the sound feels like inside their body."
            ]
        ),
        
        Experiment(
            id: "pattern-garden",
            title: "Pattern Garden",
            subtitle: "What comes next?",
            description: "Children create, extend, and invent repeating and growing patterns using blocks, beads, natural objects, and their own bodies. Bridges concrete math patterns with creative expression.",
            domain: .math,
            suggestedGradeRange: 0...5,
            primaryDispositions: [.patterns, .observation, .prediction],
            secondaryDispositions: [.connection, .iteration],
            hook: "Build beautiful patterns and discover the secret rules hiding inside them.",
            supportsEchoFragments: true,
            baseComplexity: 2,
            heroApproachNotes: [
                .flint: "Loves breaking patterns in surprising ways and then fixing them dramatically.",
                .pebby: "Sees patterns as stories or friendships between objects. 'These two always sit together.'",
                .lumi: "Finds poetry in growing patterns. Notices when a pattern feels 'alive' or 'breathing'."
            ]
        ),
        
        Experiment(
            id: "mirror-worlds",
            title: "Mirror Worlds",
            subtitle: "What stays the same when everything flips?",
            description: "Using mirrors, children explore symmetry, reflection, and spatial relationships. They predict what a shape or drawing will look like in a mirror, then test and adjust their thinking.",
            domain: .math,
            suggestedGradeRange: 1...5,
            primaryDispositions: [.observation, .patterns, .quantitative],
            secondaryDispositions: [.prediction, .connection],
            hook: "Look into mirrors and discover what the world looks like when it’s flipped.",
            supportsEchoFragments: true,
            baseComplexity: 3,
            heroApproachNotes: [
                .flint: "Wants to make the silliest, most chaotic mirror faces and drawings possible.",
                .pebby: "Notices when things look 'lonely' without their mirror twin. Enjoys making gentle, matching patterns.",
                .lumi: "Becomes enchanted by the idea of a secret twin world inside the mirror. Asks deep questions about what the mirror sees."
            ]
        ),
        
        // Additional experiments
        
        Experiment(
            id: "growing-secrets",
            title: "Growing Secrets",
            subtitle: "What does a seed need to wake up?",
            description: "Children plant quick-growing seeds (like beans or radishes) in different conditions and observe what helps them grow over several days. Combines long-term observation with prediction and pattern tracking.",
            domain: .science,
            suggestedGradeRange: 0...5,
            primaryDispositions: [.observation, .prediction, .patterns],
            secondaryDispositions: [.iteration, .connection],
            hook: "Plant seeds and discover what helps living things grow strong.",
            supportsEchoFragments: true,
            baseComplexity: 2,
            heroApproachNotes: [
                .flint: "Gets excited when things sprout quickly. Wants to try wild experiments (\"What if we sing to them?!\").",
                .pebby: "Treats the seeds like little friends. Notices when one seed is growing faster and worries about the others.",
                .lumi: "Talks about the seed 'dreaming' underground. Asks the child to imagine what the seed is feeling as it pushes upward."
            ]
        ),
        
        Experiment(
            id: "attribute-detectives",
            title: "Attribute Detectives",
            subtitle: "How are these things the same? How are they different?",
            description: "Children sort, group, and classify everyday objects (and later more abstract items) based on multiple attributes. They create their own sorting rules and try to guess each other’s rules.",
            domain: .math,
            suggestedGradeRange: 1...5,
            primaryDispositions: [.observation, .patterns, .quantitative],
            secondaryDispositions: [.prediction, .connection],
            hook: "Become a detective and discover the hidden rules that group the world together.",
            supportsEchoFragments: true,
            baseComplexity: 3,
            heroApproachNotes: [
                .flint: "Loves creating the most chaotic or surprising sorting rules possible. Enjoys when rules get broken dramatically.",
                .pebby: "Creates gentle, story-based categories (\"These feel like friends\", \"These are the quiet ones\").",
                .lumi: "Finds poetic or emotional attributes (\"These are the ones that look like they’re listening\"). Asks beautiful 'why' questions."
            ]
        ),
        
        Experiment(
            id: "pouring-lab",
            title: "The Pouring Lab",
            subtitle: "How much can this hold?",
            description: "Children explore volume, capacity, and conservation using different containers and pouring materials (water, rice, sand). They predict which container holds more, test their ideas, and confront common misconceptions.",
            domain: .math,
            suggestedGradeRange: 0...4,
            primaryDispositions: [.prediction, .quantitative, .iteration],
            secondaryDispositions: [.observation, .patterns],
            hook: "Pour, measure, and discover that things aren’t always what they seem.",
            supportsEchoFragments: true,
            baseComplexity: 2,
            heroApproachNotes: [
                .flint: "Wants to make big splashes and dramatic pours. Loves when the 'wrong' container actually holds more.",
                .pebby: "Notices when water 'feels tired' of being poured. Enjoys careful, patient filling.",
                .lumi: "Becomes fascinated by the idea that the same amount of water can look completely different. Asks philosophical questions about 'more' and 'less'."
            ]
        )
    ]
    
    static func experiment(for id: String) -> Experiment? {
        all.first { $0.id == id }
    }
}
