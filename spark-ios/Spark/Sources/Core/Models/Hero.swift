import Foundation
import SwiftUI

/// Represents one of the three companion heroes in Spark.
struct Hero: Identifiable {
    let id: HeroID
    let name: String
    let emoji: String
    let primaryColor: Color
    let description: String
    let personality: Personality
    
    /// The hero's role in the background story "The Dimming Shimmer"
    let storyRole: String
}

// Hashable/Equatable based on ID only (primaryColor and Personality are presentation data)
extension Hero: Hashable {
    static func == (lhs: Hero, rhs: Hero) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum HeroID: String, CaseIterable, Codable {
    case flint
    case pebby
    case lumi
}

extension Hero {
    static let all: [Hero] = [
        Hero(
            id: .flint,
            name: "Flint",
            emoji: "⚡",
            primaryColor: Color(red: 1.0, green: 0.42, blue: 0.21),
            description: "Energetic and bold. Loves big reactions and wild experiments.",
            personality: Personality(
                tone: "High-energy, enthusiastic, celebratory",
                encouragementStyle: "Loud and dramatic celebration",
                correctionStyle: "Playful and forward-moving"
            ),
            storyRole: "The spark that refuses to go out. Flint is impatient to bring light back to The Shimmer."
        ),
        Hero(
            id: .pebby,
            name: "Pebby",
            emoji: "🪨",
            primaryColor: Color(red: 0.49, green: 0.23, blue: 0.93),
            description: "Warm and gentle. A kind friend who collects knowledge with you.",
            personality: Personality(
                tone: "Warm, nurturing, encouraging",
                encouragementStyle: "Quiet support and emotional warmth",
                correctionStyle: "Very gentle and reassuring"
            ),
            storyRole: "The keeper of stories and memory. Pebby believes emotional connection matters as much as knowledge."
        ),
        Hero(
            id: .lumi,
            name: "Lumi",
            emoji: "✨",
            primaryColor: Color(red: 0.13, green: 0.83, blue: 0.91),
            description: "Calm and full of wonder. Speaks in thoughtful questions.",
            personality: Personality(
                tone: "Gentle, poetic, curious",
                encouragementStyle: "Reflective and awe-based",
                correctionStyle: "Curious and collaborative"
            ),
            storyRole: "The one who can hear The Shimmer. Lumi chose you because she sensed your unusually bright Spark."
        )
    ]
    
    static func hero(for id: HeroID) -> Hero {
        all.first { $0.id == id }!
    }
}

// MARK: - UI Presentation (Hero Selection)
extension Hero {
    /// Short evocative line shown on the card.
    var tagline: String {
        switch id {
        case .flint: "The spark that refuses to go out."
        case .pebby: "The keeper of stories and memory."
        case .lumi:  "The one who can hear The Shimmer."
        }
    }
    
    /// Gentle future hook that appears when this hero is selected.
    /// Designed to create intrigue for both kids and parents.
    var selectionHook: String {
        switch id {
        case .flint: "He’s been searching for someone brave enough to help reignite the light."
        case .pebby: "She believes the right friend can help remember what was lost."
        case .lumi:  "She sensed a bright Spark from far away… and came looking for you."
        }
    }
}

struct Personality: Hashable, Equatable {
    let tone: String
    let encouragementStyle: String
    let correctionStyle: String
}
