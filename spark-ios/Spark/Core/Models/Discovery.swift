import Foundation

/// Something the child noticed and chose to save during an activity.
struct Discovery: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let timestamp: Date
    let relatedActivity: String?
    let heroID: HeroID?
}
