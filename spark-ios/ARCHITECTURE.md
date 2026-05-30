# Spark iOS Architecture (Native SwiftUI)

## Guiding Principles
- **Quality over speed** — We are optimizing for a premium iOS experience.
- **Stories come alive** — Animation and motion design are first-class citizens.
- **Gentle storytelling** — The "Dimming Shimmer" narrative stays subtle.
- **Child-first** — Every interaction should feel safe, delightful, and age-appropriate.

## High-Level Architecture

### Layers
- **App Layer**: Entry point, app lifecycle, root navigation.
- **Feature Layer**: Self-contained features (Onboarding, Experiments, Profile, Discoveries, etc.).
- **Core Layer**:
  - Models
  - Services (Persistence, Story Engine, etc.)
  - Design System / UI Components
- **Resources**: Colors, fonts, images, Rive files, sounds.

### Navigation
We will use SwiftUI's `NavigationStack` + `NavigationPath` for most flows. For more complex flows we may introduce a lightweight coordinator pattern later.

### State Management
- Prefer SwiftUI's built-in tools (`@Observable`, `@State`, `@Binding`).
- Use `@Observable` classes for longer-lived state (Profile, Story Progress).
- Consider TCA only if complexity grows significantly.

### Persistence (Phase 1)
Start with SwiftData for simplicity. We can move to Core Data later if needed for more control.

### Animation Philosophy
- Use SwiftUI's animation system heavily.
- Leverage `matchedGeometryEffect` for smooth transitions.
- Use Rive for hero character expressions and reactions.
- For science experiments: Combine SwiftUI Canvas + gesture recognizers + Core Animation.

## Key Modules (Initial)

- `HeroSystem`
- `StoryEngine` (Echo Fragments)
- `Onboarding`
- `Experiments` (starting with Color Mixing Lab)
- `Profile & Progress`
- `DesignSystem`

## Technology Decisions

- **UI**: SwiftUI (primary)
- **Graphics**: SwiftUI Canvas + Metal (for high-performance experiments)
- **Character Animation**: Rive Runtime
- **Persistence**: SwiftData
- **Haptics**: Core Haptics + UIKit haptics
- **Accessibility**: First-class support from day one

## Development Guidelines

- Every new feature should consider motion design early.
- Story moments (Echo Fragments) should feel like gifts, not rewards.
- Keep the interface big, friendly, and forgiving.
- Prefer composition over inheritance.
