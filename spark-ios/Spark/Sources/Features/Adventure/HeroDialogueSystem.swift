import Foundation

struct HeroDialogueSystem {
    
    // MARK: - Moods (used for tone and animation hints on the hub)
    enum Mood {
        case excited      // Recent big Echo or track progress
        case reflective   // Many Echoes collected, approaching ending
        case proud        // Just completed something meaningful
        case curious      // Default / early-mid game
        case hopeful      // Late game, world visibly brightening
    }
    
    static func currentMood(echoCount: Int, recentlyCompletedTrack: Bool) -> Mood {
        if echoCount >= 7 {
            return .hopeful
        } else if recentlyCompletedTrack {
            return .proud
        } else if echoCount >= 4 {
            return .reflective
        } else if echoCount >= 2 {
            return .excited
        } else {
            return .curious
        }
    }
    
    // MARK: - Hub Greetings (context-aware)
    static func getGreeting(for profile: ChildProfile, hero: Hero, echoCount: Int, strongestTrack: LearningTrack?) -> String {
        let name = profile.name
        let mood = currentMood(echoCount: echoCount, recentlyCompletedTrack: false)
        
        switch mood {
        case .hopeful:
            return "The Shimmer feels brighter because of you, \(name). I can feel it."
            
        case .proud:
            if let track = strongestTrack {
                return "We've come so far in \(track.title). I'm really proud of you."
            }
            return "You've been doing such meaningful work, \(name)."
            
        case .reflective:
            return "The more we explore together, the more the world seems to remember itself."
            
        case .excited:
            return "I've been thinking about what we discovered last time, \(name)!"
            
        case .curious:
            if let top = profile.topDispositions.first {
                switch top {
                case .iteration:
                    return "Ready to try something new today, \(name)? I love watching you figure things out."
                case .observation:
                    return "What do you think we'll notice today, \(name)?"
                case .prediction:
                    return "I wonder what you're going to predict next."
                default:
                    break
                }
            }
            return "Welcome back, \(name). What shall we wonder about today?"
        }
    }
    
    // MARK: - Track Completion Lines (emotional payoff)
    static func getTrackCompletionLine(for track: LearningTrack, hero: Hero) -> String {
        switch hero.id {
        case .flint:
            return "We did it! That was incredible work in \(track.title). You never gave up!"
        case .pebby:
            return "You brought so much care and patience to \(track.title). I will remember this forever."
        case .lumi:
            return "Something in the Shimmer shifted when we finished \(track.title). You felt it too, didn't you?"
        }
    }
    
    // MARK: - Story Progress Lines (tied to ending)
    static func getStoryProgressLine(echoCount: Int, hero: Hero) -> String {
        switch echoCount {
        case 0...1:
            return "Every small discovery helps the light return, little by little."
        case 2...4:
            return "The crystals are starting to remember. I can hear them more clearly now."
        case 5...7:
            return "The Shimmer feels different. Warmer. Because of you."
        default:
            return "We are doing something important here. The light is coming back."
        }
    }
    
    // MARK: - Random Tap Lines (for when player taps the hero on the hub)
    static func getRandomTapLine(hero: Hero, echoCount: Int, strongestTrack: LearningTrack?) -> String {
        let baseLines: [HeroID: [String]] = [
            .flint: [
                "Let's go find something amazing today!",
                "I bet we can make an even bigger discovery than last time!",
                "You ready to shake things up?",
                "The bigger the question, the more fun the answer!"
            ],
            .pebby: [
                "Take your time. The best things are noticed slowly.",
                "I love watching how gently you explore the world.",
                "Shall we go collect some more knowledge pebbles?",
                "Every small noticing is worth celebrating."
            ],
            .lumi: [
                "The world has so many quiet things to show us.",
                "I wonder what the Shimmer will whisper to us today.",
                "Sometimes the smallest observations change everything.",
                "What do you think the light is trying to tell us right now?"
            ]
        ]
        
        var lines = baseLines[hero.id] ?? ["What shall we discover today?"]
        
        // Add ending-aware lines
        if echoCount >= 6 {
            lines.append("We're getting closer to something important. I can feel it.")
        }
        
        if let track = strongestTrack, echoCount >= 4 {
            lines.append("The work we're doing in \(track.title) matters more than you know.")
        }
        
        return lines.randomElement() ?? "What shall we discover today?"
    }
    
    // MARK: - Late Game / Ending Tease Lines
    static func getEndingTeaseLine(hero: Hero, echoCount: Int) -> String {
        guard echoCount >= 5 else { return "" }
        
        switch hero.id {
        case .flint:
            return "The biggest sparks come from the smallest questions. We're close to something huge."
        case .pebby:
            return "Every Echo you've created is a story the Shimmer will never forget."
        case .lumi:
            return "Your Spark has always been unusually bright. The Shimmer chose you for a reason."
        }
    }
    
    // MARK: - Full Story Unlock Reaction
    static func getFullUnlockLine(for hero: Hero) -> String {
        switch hero.id {
        case .flint:
            return "YES! The paths are opening! We can go everywhere now. This is going to be incredible."
        case .pebby:
            return "Oh… you chose to see the whole story with me. Thank you. The Shimmer feels brighter already."
        case .lumi:
            return "You opened the door to everything. Now the crystals can show you what they’ve been waiting to reveal."
        }
    }
    
    // MARK: - Major Story Echo References (Final Echo Moments)
    //
    // These lines are used when the child has earned one or more of the high-stakes major echoes.
    // They make the hero feel like they remember the child's specific journey.
    // Called from the hub (tappable hero) and can be surfaced in ClimaxView farewells.
    
    static func getMajorEchoReferenceLine(hero: Hero, majorEchoes: [EchoFragment]) -> String? {
        guard !majorEchoes.isEmpty else { return nil }
        
        // Prefer the most personal / story-significant one the child earned.
        let beats = Set(majorEchoes.compactMap { $0.storyBeat })
        
        if beats.contains("light_chose_you") {
            switch hero.id {
            case .lumi: return "That moment when the light recognized you… I still feel it when I look at you."
            case .flint: return "You made the light want to stay. I think about that more than you know."
            case .pebby: return "The light remembered your name before we even arrived. That still gives me chills."
            }
        }
        
        if beats.contains("seed_whisper") {
            switch hero.id {
            case .pebby: return "The seed that answered you… I wonder if it is still growing somewhere, thinking of you."
            case .lumi: return "Something living chose to speak back to you. That was the moment I knew we were right to come."
            case .flint: return "You got the world to talk back. That’s bigger than any explosion I could have asked for."
            }
        }
        
        if beats.contains("harmony") {
            switch hero.id {
            case .lumi: return "When the garden sang and the colors answered… the Shimmer changed its breathing that day."
            default: return "That day sound and light found each other because of you. I still hear it sometimes."
            }
        }
        
        if beats.contains("threshold") {
            switch hero.id {
            case .flint: return "You went all the way to the edge and then made everything perfectly still. I’m still proud of that."
            case .pebby: return "Courage and gentleness in the same afternoon. That balance changed something in me too."
            default: return "You showed both fire and perfect quiet. The crystals needed someone who could hold both."
            }
        }
        
        if beats.contains("ancient_memory") {
            return "The pattern that remembered you… I think a part of the Shimmer will always carry that shape now."
        }
        
        // Fallback for any major echo
        return "One of the moments you created is still echoing inside the crystals. I can feel it."
    }
}
