import SwiftUI

@main
struct SparkApp: App {
    var body: some Scene {
        WindowGroup {
            // Temporary root view while we build the real onboarding
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Spark")
                .font(.largeTitle.bold())
            
            Text("Native iOS version")
                .foregroundStyle(.secondary)
            
            Text("Work in progress on MacBook")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
