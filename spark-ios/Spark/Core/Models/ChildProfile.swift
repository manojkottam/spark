import Foundation

/// Represents the child's profile and progress in the app.
struct ChildProfile: Identifiable {
    let id: UUID
    var name: String
    var grade: Grade
    var chosenHeroID: HeroID
    var createdAt: Date
    
    /// Simple in-memory discoveries for now. Will move to SwiftData later.
    var discoveries: [Discovery] = []
    
    /// Collected Echo Fragments (story moments)
    var collectedEchoIDs: Set<String> = []
}

enum Grade: String, CaseIterable, Codable {
    case kindergarten = "Kindergarten"
    case first = "1st Grade"
    case second = "2nd Grade"
    case third = "3rd Grade"
    case fourth = "4th Grade"
    case fifth = "5th Grade"
}
