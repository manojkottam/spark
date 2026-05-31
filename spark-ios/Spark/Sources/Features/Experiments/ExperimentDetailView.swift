import SwiftUI

struct ExperimentDetailView: View {
    let experiment: Experiment
    let profile: ChildProfile
    
    @State private var predictionText: String = ""
    @State private var hasStartedExperiment = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    var body: some View {
        ZStack {
            Color.sparkBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Greeting
                    heroGreetingSection
                    
                    // Experiment Overview
                    experimentOverviewSection
                    
                    // Prediction Phase
                    predictionSection
                    
                    // The Lab (Interactive Placeholder)
                    labPlaceholderSection
                    
                    // Reflection
                    reflectionSection
                    
                    // Story Teaser
                    if experiment.supportsEchoFragments {
                        storyTeaserSection
                    }
                    
                    // Primary CTA
                    primaryActionButton
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle(experiment.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Sections
    
    private var heroGreetingSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(hero.primaryColor.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Text(hero.emoji)
                    .font(.system(size: 56))
            }
            
            Text(heroGreeting)
                .font(.sparkBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(.top, 12)
    }
    
    private var heroGreeting: String {
        let notes = experiment.heroApproachNotes?[hero.id] ?? ""
        return "Hi \(profile.name)! \(notes.isEmpty ? "I think you'll really like this one." : notes)"
    }
    
    private var experimentOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(experiment.domain.emoji)
                    .font(.largeTitle)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(experiment.title)
                        .font(.sparkTitle)
                    
                    if let subtitle = experiment.subtitle {
                        Text(subtitle)
                            .font(.sparkHeadline)
                            .foregroundStyle(hero.primaryColor)
                    }
                }
            }
            
            Text(experiment.description)
                .font(.sparkBody)
                .foregroundStyle(.secondary)
            
            // Dispositions
            VStack(alignment: .leading, spacing: 8) {
                Text("This helps you practice:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(experiment.primaryDispositions, id: \.self) { disposition in
                        Text(disposition.shortLabel)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(hero.primaryColor.opacity(0.12))
                            .foregroundStyle(hero.primaryColor)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
        )
    }
    
    private var predictionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What do you think will happen?")
                .font(.sparkHeadline)
            
            Text("Take a moment to make a prediction before we begin.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            TextEditor(text: $predictionText)
                .frame(minHeight: 100)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(hero.primaryColor.opacity(0.2), lineWidth: 1)
                )
            
            // Hero-flavored suggestion prompts
            if let notes = experiment.heroApproachNotes?[hero.id], !notes.isEmpty {
                Text("💡 \(hero.name) wonders: \"\(suggestionPrompt)\"")
                    .font(.caption)
                    .foregroundStyle(hero.primaryColor.opacity(0.8))
                    .padding(.top, 4)
            }
        }
    }
    
    private var suggestionPrompt: String {
        switch hero.id {
        case .flint:
            return "What’s the wildest thing you think might happen?"
        case .pebby:
            return "What feels like it might be true, even if you’re not sure yet?"
        case .lumi:
            return "If you could whisper a question to this experiment, what would you ask?"
        }
    }
    
    private var labPlaceholderSection: some View {
        Group {
            if experiment.id == "color-mixing" {
                // Real interactive lab for Color Mixing
                if experiment.id == "color-mixing" {
                    ColorMixingLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        print("Color mixing complete: \(resultName). Practiced: \(dispositions). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "ramp-runners" {
                    RampRunnersLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Ramp Runners complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "sound-garden" {
                    SoundGardenLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Sound Garden complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "pattern-garden" {
                    PatternGardenLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Pattern Garden complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "mirror-worlds" {
                    MirrorWorldsLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Mirror Worlds complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "pouring-lab" {
                    PouringLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Pouring Lab complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "shadow-play" {
                    ShadowPlayLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Shadow Play complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "balancing-act" {
                    BalancingActLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Balancing Act complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "growing-secrets" {
                    GrowingSecretsLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Growing Secrets complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else if experiment.id == "attribute-detectives" {
                    AttributeDetectivesLabView(profile: profile) { resultName, dispositions, echo in
                        hasStartedExperiment = true
                        for disposition in dispositions {
                            profile.recordStrength(disposition, amount: 1)
                        }
                        if let echo = echo {
                            profile.collectedEchoIDs.append(echo.id)
                        }
                        print("Attribute Detectives complete: \(resultName). Echo: \(echo?.title ?? "none")")
                    }
                } else {
                    // Fallback placeholder for other labs
                    Text("Interactive lab coming soon for \(experiment.title)")
                        .padding(40)
                }
            } else {
                // Placeholder for other experiments
                VStack(spacing: 16) {
                    Text("The Experiment")
                        .font(.sparkHeadline)
                    
                    VStack(spacing: 12) {
                        Text("🧪")
                            .font(.system(size: 48))
                        
                        Text("This is where the magic happens.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                        Text("The interactive experience for this lab will be built here.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.6))
                    )
                    
                    Button {
                        hasStartedExperiment = true
                    } label: {
                        Text(hasStartedExperiment ? "Return to the Lab" : "Begin the Experiment")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(hero.primaryColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
        }
    }
    
    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What did you notice?")
                .font(.sparkHeadline)
            
            Text("Take your time. The best discoveries often come from quiet noticing.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            TextEditor(text: .constant(""))
                .frame(minHeight: 90)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(hero.primaryColor.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var storyTeaserSection: some View {
        VStack(spacing: 8) {
            Text("✨ The Shimmer might notice this moment.")
                .font(.callout.weight(.medium))
                .foregroundStyle(hero.primaryColor)
            
            Text("Some experiments leave behind small echoes.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(hero.primaryColor.opacity(0.08))
        )
    }
    
    private var primaryActionButton: some View {
        Button {
            // In a real implementation this would save progress,
            // record dispositions, potentially trigger insight checks, etc.
            print("Experiment completed: \(experiment.id) with hero \(hero.name)")
        } label: {
            Text("I’m ready to share what I noticed")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    hasStartedExperiment ? hero.primaryColor : Color.gray.opacity(0.2)
                )
                .foregroundStyle(hasStartedExperiment ? .white : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .disabled(!hasStartedExperiment)
    }
}

#Preview {
    let profile = ChildProfile(
        name: "Leo",
        grade: .third,
        chosenHeroID: .flint
    )
    
    NavigationStack {
        ExperimentDetailView(
            experiment: Experiment.all.first { $0.id == "ramp-runners" }!,
            profile: profile
        )
    }
}
