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
    
    /// Returns the tracks the child has made the most progress in.
    var strongestTracks: [LearningTrack] {
        let trackScores = LearningTrack.all.map { track -> (LearningTrack, Int) in
            let score = track.experiments.reduce(0) { total, exp in
                total + exp.primaryDispositions.reduce(0) { sum, disp in
                    sum + profile.strength(for: disp)
                }
            }
            return (track, score)
        }
        
        return trackScores
            .sorted { $0.1 > $1.1 }
            .prefix(3)
            .map { $0.0 }
    }
    
    /// Returns progress percentage (0.0 - 1.0) for a given track based on dispositions practiced.
    func progress(for track: LearningTrack) -> Double {
        guard !track.experiments.isEmpty else { return 0 }
        
        let totalPossible = track.experiments.reduce(0) { sum, exp in
            sum + exp.primaryDispositions.count * 5   // rough target of 5 points per disposition
        }
        
        let current = track.experiments.reduce(0) { sum, exp in
            sum + exp.primaryDispositions.reduce(0) { innerSum, disp in
                innerSum + profile.strength(for: disp)
            }
        }
        
        return min(Double(current) / Double(max(totalPossible, 1)), 1.0)
    }
    
    /// Experiments the child hasn't tried yet that belong to tracks they're already strong in.
    func suggestedNextInStrongTracks(limit: Int = 4) -> [Experiment] {
        let strongTrackIDs = Set(strongestTracks.map { $0.id })
        
        return LearningTrack.all
            .filter { strongTrackIDs.contains($0.id) }
            .flatMap { $0.experiments }
            .filter { exp in
                // Simple heuristic: hasn't been "practiced" much yet
                let practiced = exp.primaryDispositions.reduce(0) { $0 + profile.strength(for: $1) }
                return practiced < 3
            }
            .prefix(limit)
            .map { $0 }
    }
    
    // MARK: - Track Completion & Rewards
    
    /// Returns true if the child has completed enough of the track to earn the reward.
    /// Current rule: 70% of experiments in the track are completed.
    func isTrackCompleted(_ track: LearningTrack) -> Bool {
        guard !track.experimentIDs.isEmpty else { return false }
        let completedCount = track.experimentIDs.filter { profile.hasCompleted($0) }.count
        let completionRate = Double(completedCount) / Double(track.experimentIDs.count)
        return completionRate >= 0.7
    }
    
    /// Returns the special reward Echo Fragment for completing this track (if any).
    func rewardEchoForTrack(_ track: LearningTrack) -> EchoFragment? {
        // Map tracks to special completion echoes (legendary or rare)
        let rewardMap: [String: String] = [
            "light-and-color": "echo_hidden_glow",
            "forces-and-motion": "echo_two_lights",
            "patterns-and-structure": "echo_many_voices",
            "measuring-our-world": "echo_listening_stone"
        ]
        
        guard let echoID = rewardMap[track.id] else { return nil }
        return EchoFragment.all.first { $0.id == echoID }
    }
    
    /// Checks if the child should receive the track completion reward right now.
    /// Call this after completing an experiment.
    func checkForTrackCompletionRewards() -> [EchoFragment] {
        var newlyEarned: [EchoFragment] = []
        
        for track in LearningTrack.all {
            if isTrackCompleted(track),
               let rewardEcho = rewardEchoForTrack(track),
               !profile.collectedEchoIDs.contains(rewardEcho.id) {
                
                profile.collectedEchoIDs.append(rewardEcho.id)
                newlyEarned.append(rewardEcho)
            }
        }
        
        return newlyEarned
    }
    
    // MARK: - Access Control (Free + One-time Full Unlock)
    
    /// The simple freemium rule:
    /// - If the user bought the full unlock → everything is available.
    /// - Otherwise, only experiments marked `isFree` are playable.
    ///
    /// Light branching (isExperimentUnlocked) is kept as a *guidance* layer inside owned content.
    func canAccess(_ experiment: Experiment) -> Bool {
        if profile.hasFullUnlock {
            return true
        }
        return experiment.isFree
    }
    
    // MARK: - Light Branching (Guidance within owned content)
    
    /// Returns whether the child has unlocked this experiment based on track order.
    /// This is now treated as *recommendation / guidance* rather than a hard gate.
    /// The real hard gate is `canAccess` (free vs purchased full unlock).
    func isExperimentUnlocked(_ experiment: Experiment) -> Bool {
        // If they don't own the content, we still let the UI show the first free lab per track
        // as the entry point.
        for track in LearningTrack.all where track.experimentIDs.contains(experiment.id) {
            guard let index = track.experimentIDs.firstIndex(of: experiment.id) else { return true }
            if index == 0 { return true }
            
            let previousID = track.experimentIDs[index - 1]
            return profile.hasCompleted(previousID)
        }
        return true
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
