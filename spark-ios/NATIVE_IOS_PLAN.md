# Spark - Native iOS App Plan

## Decision
We are moving from React Native + Expo to a **native iOS app** built with **Swift + SwiftUI**.

**Primary Goals (in priority order):**
1. Excellent iOS-native animations and feel (stories should "come alive")
2. High-quality, premium experience for kids (K-5) and parents
3. Target App Store first
4. Only build Android later if the product gains significant traction

## Core Product Elements to Preserve

### Heroes
- Flint (energetic, bold, experiment-loving)
- Pebby (warm, gentle, encouraging)
- Lumi (calm, curious, poetic)

Each child chooses one hero. The hero guides them and has distinct personality in dialogue and reactions.

### Background Story: The Dimming Shimmer
- Living crystal world losing its light
- Children create "Echoes" through deep learning and wonder
- Subtle, gentle story integration (not heavy-handed)
- Echo Fragments that appear during meaningful moments

### Learning Philosophy
- Strong focus on **Science experiments** with real interactivity
- Prediction → Experiment → Reflection loop
- High emphasis on observation and "noticing"
- Age-appropriate (K-5), with gentle progression

### First Major Feature
**Color Mixing Lab** (with drag & drop, prediction, beautiful animations, and story moments)

## Technology Stack (Native iOS)

- **Language**: Swift 6
- **UI Framework**: SwiftUI (primary) + UIKit where needed for complex interactions
- **Animations**: SwiftUI animations + Core Animation + possibly Lottie/Rive
- **2D Graphics & Experiments**: SwiftUI Canvas + Metal (for high-performance experiments) + SpriteKit where appropriate
- **Character Animation**: Rive Runtime for iOS (excellent support)
- **State Management**: SwiftUI + Observation framework (or TCA / custom if needed)
- **Persistence**: SwiftData (or Core Data if more control needed)
- **Networking** (future): Async/Await + URLSession
- **Design System**: Custom SwiftUI components with strong typography, spacing, and motion guidelines

## Key Advantages We're Seeking

- Superior animation quality and fluidity
- Tight integration with iOS design language and behaviors
- Better performance for complex visual experiments
- Smaller app size
- Higher perceived quality for educational content aimed at young children

## Risks & Mitigations

- Slower development of interactive experiments → Accept this in exchange for higher quality. Start with fewer but more polished experiments.
- Double work if Android is needed later → Only solve Android if traction justifies it. Consider a completely separate Android app (different tech) if that happens.
- Longer time to first App Store release → Accept this as the cost of quality.

## Next Steps

1. Set up a proper Xcode project with SwiftUI + modern architecture.
2. Define core models (Hero, EchoFragment, Activity, Discovery, etc.).
3. Build the hero selection + onboarding flow with excellent animations.
4. Rebuild the Color Mixing Lab natively with superior motion design.
5. Establish a strong design system and animation language early.
6. Integrate Rive for hero characters.

## Open Questions

- Should we use SwiftData or Core Data for persistence?
- Do we want to use TCA (The Composable Architecture) for stronger state management?
- How heavily do we want to use Rive vs. pure SwiftUI animations for the heroes?
- What is the minimum viable set of experiments for a first App Store release?
