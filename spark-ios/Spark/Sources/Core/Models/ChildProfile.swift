import Foundation
import SwiftData

/// Represents the child's profile and progress in the app.
@Model
final class ChildProfile {
    var id: UUID
    var name: String
    var grade: Grade
    var chosenHeroID: HeroID
    var createdAt: Date
    
    // For now we keep these as simple arrays/sets.
    // We can evolve the model later when we build the experiments.
    var discoveriesData: Data = Data()          // Encoded [Discovery] for simplicity
    var collectedEchoIDs: [String] = []
    
    /// Lightweight tracking of disposition strengths.
    /// Values are simple counts that we can later turn into more sophisticated scores.
    /// Key = rawValue of LearningDisposition
    var dispositionStrengths: [String: Int] = [:]
    
    init(
        id: UUID = UUID(),
        name: String,
        grade: Grade,
        chosenHeroID: HeroID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.grade = grade
        self.chosenHeroID = chosenHeroID
        self.createdAt = createdAt
    }
    
    // MARK: - Disposition Helpers (MVP)
    
    func recordStrength(_ disposition: LearningDisposition, amount: Int = 1) {
        let key = disposition.rawValue
        dispositionStrengths[key] = (dispositionStrengths[key] ?? 0) + amount
    }
    
    func strength(for disposition: LearningDisposition) -> Int {
        dispositionStrengths[disposition.rawValue] ?? 0
    }
    
    /// Returns the child's top 3 dispositions (for parent dashboard).
    var topDispositions: [LearningDisposition] {
        LearningDisposition.allCases
            .sorted { strength(for: $0) > strength(for: $1) }
            .prefix(3)
            .map { $0 }
    }
}

enum Grade: String, CaseIterable, Codable {
    case kindergarten = "Kindergarten"
    case first = "1st Grade"
    case second = "2nd Grade"
    case third = "3rd Grade"
    case fourth = "4th Grade"
    case fifth = "5th Grade"
}
