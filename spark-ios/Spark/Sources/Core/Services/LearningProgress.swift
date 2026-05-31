import Foundation

/// Lightweight service for working with a child's learning progress.
/// This will grow as we add more experiments and insight checks.
struct LearningProgress {
    let profile: ChildProfile
    
    /// Returns a simple summary suitable for the parent dashboard.
    var strengthSummary: [LearningDisposition: Int] {
        var result: [LearningDisposition: Int] = [:]
        for disposition in LearningDisposition.allCases {
            result[disposition] = profile.strength(for: disposition)
        }
        return result
    }
    
    /// Very simple recommendation logic for the MVP.
    /// Later this will become much smarter (hero affinity + recent activity + grade).
    func recommendedExperiments(from allExperiments: [Experiment], limit: Int = 3) -> [Experiment] {
        let hero = Hero.hero(for: profile.chosenHeroID)
        
        // For now: prefer experiments that align with the hero's natural strengths + child's grade
        let heroPreferred: Set<LearningDisposition> = switch hero.id {
        case .flint:  [.iteration, .prediction]
        case .pebby:  [.observation, .connection]
        case .lumi:   [.observation, .patterns, .connection]
        }
        
        let gradeValue = gradeToInt(profile.grade)
        
        let scored = allExperiments.map { experiment -> (Experiment, Int) in
            var score = 0
            
            // Hero affinity
            for disp in experiment.primaryDispositions where heroPreferred.contains(disp) {
                score += 3
            }
            
            // Grade appropriateness (prefer experiments near the child's level)
            if experiment.suggestedGradeRange.contains(gradeValue) {
                score += 5
            } else if abs(gradeValue - experiment.suggestedGradeRange.lowerBound) <= 1 ||
                      abs(gradeValue - experiment.suggestedGradeRange.upperBound) <= 1 {
                score += 2
            }
            
            // Slight boost for experiments that support story moments
            if experiment.supportsEchoFragments {
                score += 1
            }
            
            return (experiment, score)
        }
        
        return scored
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { $0.0 }
    }
    
    private func gradeToInt(_ grade: Grade) -> Int {
        switch grade {
        case .kindergarten: 0
        case .first: 1
        case .second: 2
        case .third: 3
        case .fourth: 4
        case .fifth: 5
        }
    }
}
