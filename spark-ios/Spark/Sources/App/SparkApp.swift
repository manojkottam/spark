import SwiftUI
import SwiftData

@main
struct SparkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentRootView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: ChildProfile.self)
    }
}

// Decides whether to show onboarding or the main app
struct ContentRootView: View {
    @Query private var profiles: [ChildProfile]
    
    var body: some View {
        if let profile = profiles.first {
            MainAppView(profile: profile)
        } else {
            OnboardingFlowView()
        }
    }
}


