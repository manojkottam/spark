import Foundation

/// Core dispositions we develop through experiments.
/// These form the basis for:
/// - Personalization (hero reactions, difficulty, prompts)
/// - Light knowledge/insight checks
/// - Parent dashboard showing strength areas
enum LearningDisposition: String, CaseIterable, Codable, Hashable {
    /// Noticing fine details, changes, and subtle phenomena
    case observation = "Observation"
    
    /// Forming thoughtful predictions and "I wonder..." questions before acting
    case prediction = "Prediction & Wondering"
    
    /// Trying things, adjusting based on results, and persisting through iteration
    case iteration = "Experimentation & Iteration"
    
    /// Spotting relationships, sequences, and repeating structures
    case patterns = "Pattern Recognition"
    
    /// Working with numbers, measurement, comparison, and quantity
    case quantitative = "Quantitative Thinking"
    
    /// Making connections between ideas, across domains, and to the bigger story
    case connection = "Wonder & Connection"
    
    var description: String {
        switch self {
        case .observation:
            return "Noticing details and changes that others might miss."
        case .prediction:
            return "Forming thoughtful expectations and asking curious questions."
        case .iteration:
            return "Trying, adjusting, and learning from what happens."
        case .patterns:
            return "Discovering relationships and structures in the world."
        case .quantitative:
            return "Thinking with numbers, measurement, and comparison."
        case .connection:
            return "Linking ideas together and seeing the bigger picture."
        }
    }
    
    /// Short label suitable for parent dashboard chips
    var shortLabel: String {
        switch self {
        case .observation: "Observation"
        case .prediction: "Prediction"
        case .iteration: "Iteration"
        case .patterns: "Patterns"
        case .quantitative: "Numbers"
        case .connection: "Connections"
        }
    }
}
