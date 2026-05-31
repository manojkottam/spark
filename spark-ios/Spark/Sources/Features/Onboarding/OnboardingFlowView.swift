import SwiftUI

/// Manages the full onboarding experience (Hero Selection → Profile Details).
struct OnboardingFlowView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            HeroSelectionView(path: $path)
                .navigationDestination(for: Hero.self) { hero in
                    ProfileDetailsView(hero: hero)
                }
        }
    }
}
