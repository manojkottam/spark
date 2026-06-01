import SwiftUI

struct RampRunnersLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var rampAngle: Double = 25
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var hasRun = false
    @State private var distance: Double = 0
    @State private var discoveredEcho: EchoFragment?
    @State private var discoveredMajorEcho: EchoFragment?   // Major story echo (Final Echo Moment)
    @State private var showMajorEchoMoment = false          // Cinematic full-screen takeover
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            rampVisualization
            
            controls
            
            if hasRun {
                resultView
            }
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if let major = discoveredMajorEcho {
                majorEchoFragmentCard(major)
            }
            
            if hasRun && discoveredEcho == nil {
                Button {
                    completeExperiment()
                } label: {
                    Text("I noticed something about the ramp")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $showMajorEchoMoment) {
            if let major = discoveredMajorEcho {
                MajorEchoMomentView(echo: major, hero: hero) {
                    showMajorEchoMoment = false
                }
            }
        }
    }
    
    private var heroCompanionView: some View {
        HStack {
            Text(hero.emoji)
                .font(.title)
            Text(heroComment)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var heroComment: String {
        if hasRun {
            if discoveredEcho != nil {
                return "That was special… the ramp showed us something important."
            }
            return "Look at how far it went! What did you notice about the angle?"
        } else if hasPredicted {
            return "Good thinking. Now let’s test it and see what the ramp teaches us."
        } else {
            return "How steep do you think the ramp needs to be for the biggest journey?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            
            Text("Will the object go farther on a steep ramp or a gentle one?")
                .font(.callout)
            
            HStack(spacing: 12) {
                Button("Steep ramp") { makePrediction("steep") }
                    .buttonStyle(PredictionButtonStyle(isSelected: prediction == "steep", color: hero.primaryColor))
                
                Button("Gentle ramp") { makePrediction("gentle") }
                    .buttonStyle(PredictionButtonStyle(isSelected: prediction == "gentle", color: hero.primaryColor))
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var rampVisualization: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color(hex: "#E8DCC8"))
                .frame(height: 70)
            
            // Ramp line
            Path { path in
                let startX: CGFloat = 50
                let startY: CGFloat = 210
                let angleRad = rampAngle * .pi / 180
                let rampLength: CGFloat = 260
                let endX = startX + rampLength
                let endY = startY - CGFloat(rampLength * sin(angleRad))
                
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            .stroke(hero.primaryColor, style: StrokeStyle(lineWidth: 16, lineCap: .round))
            .shadow(color: .black.opacity(0.12), radius: 3, y: 2)
            
            // Rolling object
            if hasRun {
                Circle()
                    .fill(Color.red)
                    .frame(width: 28, height: 28)
                    .shadow(color: .black.opacity(0.2), radius: 3)
                    .offset(x: 50 + CGFloat(distance * 2.1), y: -14)
                    .animation(.easeOut(duration: 1.4), value: distance)
            }
        }
        .frame(height: 230)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var controls: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text("Ramp Steepness: \(Int(rampAngle))°")
                    .font(.callout.weight(.medium))
                
                Slider(value: $rampAngle, in: 12...42, step: 1)
                    .tint(hero.primaryColor)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            Button {
                runExperiment()
            } label: {
                Text(hasRun ? "Reset & Try a Different Angle" : "Release the Object")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(hero.primaryColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    private var resultView: some View {
        VStack(spacing: 6) {
            Text("It traveled \(Int(distance)) units!")
                .font(.title3.weight(.semibold))
                .foregroundStyle(hero.primaryColor)
            
            Text("What did changing the angle teach you?")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private func echoFragmentCard(_ echo: EchoFragment) -> some View {
        VStack(spacing: 8) {
            Text("✨ Something special just happened")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor)
            
            Text(echo.title)
                .font(.title3.weight(.semibold))
            
            Text(EchoService.reactionForEcho(echo, heroID: hero.id))
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(hero.primaryColor.opacity(0.25), lineWidth: 1.5)
        )
        .transition(.scale.combined(with: .opacity))
    }
    
    // Major Story Echo card for threshold (brave + still) moments
    private func majorEchoFragmentCard(_ echo: EchoFragment) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                Text("🌌")
                Text("The Shimmer remembers this deeply")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(hero.primaryColor)
            }
            
            Text(echo.title)
                .font(.title3.weight(.bold))
            
            Text(EchoService.reactionForMajorEcho(echo, heroID: hero.id))
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Text("A Final Echo Moment")
                .font(.caption2.weight(.medium))
                .foregroundStyle(hero.primaryColor.opacity(0.7))
                .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [hero.primaryColor.opacity(0.08), Color.white.opacity(0.95)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(hero.primaryColor.opacity(0.4), lineWidth: 2)
        )
        .shadow(color: hero.primaryColor.opacity(0.15), radius: 12, y: 6)
    }
    
    private func makePrediction(_ choice: String) {
        prediction = choice
        hasPredicted = true
    }
    
    private func runExperiment() {
        withAnimation(.easeOut(duration: 1.3)) {
            hasRun = true
            let base = rampAngle * 2.85
            let variance = Double.random(in: -7...7)
            distance = max(20, base + variance)
        }
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // Check for Echo Fragment after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            checkForEchoFragment()
        }
    }
    
    private func checkForEchoFragment() {
        if let echo = EchoService.echoForRampRunners(angle: rampAngle, distance: distance) {
            if !profile.collectedEchoIDs.contains(echo.id) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    discoveredEcho = echo
                }
                profile.collectedEchoIDs.append(echo.id)
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        
        // MAJOR STORY ECHO: The Edge Where Courage Met Stillness
        // Brave steep runs (high angle + good distance) + evidence of balancing work in journey.
        checkForMajorThresholdEcho()
    }
    
    private func checkForMajorThresholdEcho() {
        guard discoveredMajorEcho == nil else { return }
        
        // "Brave" run: steep angle with solid distance
        let isBraveRun = rampAngle > 32 && distance > 70
        
        guard isBraveRun else { return }
        
        let context = EchoService.MajorEchoContext(
            experimentID: "ramp-runners",
            wasPerfectSynthesis: true,
            secondaryScore: min(distance / 110.0, 1.0)
        )
        
        if let major = EchoService.majorEchoForCompletion(context: context, profile: profile),
           !profile.collectedEchoIDs.contains(major.id) {
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                discoveredMajorEcho = major
                showMajorEchoMoment = true
            }
            profile.collectedEchoIDs.append(major.id)
            
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }
    }
    
    private func completeExperiment() {
        let dispositions: [LearningDisposition] = [.prediction, .iteration, .quantitative]
        checkForMajorThresholdEcho()
        if discoveredMajorEcho != nil {
            showMajorEchoMoment = true
        }
        onComplete("Traveled \(Int(distance)) units", dispositions, discoveredEcho)
    }
}

struct PredictionButtonStyle: ButtonStyle {
    let isSelected: Bool
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout.weight(.medium))
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(isSelected ? color : Color.white)
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}
