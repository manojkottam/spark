import SwiftUI

struct GrowingSecretsLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var water: Double = 0.5
    @State private var sunlight: Double = 0.6
    @State private var day: Double = 3
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var discoveredMajorEcho: EchoFragment?   // Major story echo (Final Echo Moment)
    @State private var showMajorEchoMoment = false          // Cinematic full-screen takeover
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var growth: Double {
        (water * 0.5 + sunlight * 0.6) * (day / 10)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // Plant visualization
            VStack {
                Text("Day \(Int(day))")
                    .font(.headline)
                
                ZStack(alignment: .bottom) {
                    // Soil
                    Rectangle()
                        .fill(Color(hex: "#8B6F47"))
                        .frame(height: 40)
                    
                    // Stem
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.green)
                        .frame(width: 6, height: 30 + CGFloat(growth * 80))
                    
                    // Leaves / Flower
                    Circle()
                        .fill(growth > 0.6 ? Color.yellow : Color.green.opacity(0.8))
                        .frame(width: 20 + CGFloat(growth * 25), height: 20 + CGFloat(growth * 25))
                        .offset(y: -30 - CGFloat(growth * 50))
                }
                .frame(height: 180)
            }
            .padding()
            .background(Color.sparkCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Controls
            VStack(spacing: 16) {
                VStack {
                    Text("Water: \(Int(water * 100))%")
                    Slider(value: $water, in: 0.1...1.0)
                }
                
                VStack {
                    Text("Sunlight: \(Int(sunlight * 100))%")
                    Slider(value: $sunlight, in: 0.1...1.0)
                }
                
                VStack {
                    Text("Days passed: \(Int(day))")
                    Slider(value: $day, in: 1...12, step: 1)
                }
            }
            .padding()
            .background(Color.sparkCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if let major = discoveredMajorEcho {
                majorEchoFragmentCard(major)
            }
            
            if showReflection {
                reflectionView
            } else if hasPredicted {
                Button {
                    checkForEchoAndReflect()
                } label: {
                    Text("I watched it grow")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
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
            HeroCreatureView(heroID: hero.id, expression: discoveredEcho != nil ? .happy : .idle, size: 40)
            Text(heroComment)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var heroComment: String {
        if discoveredEcho != nil {
            return "It grew when we gave it exactly what it needed… not too much, not too little."
        } else if growth > 0.8 {
            return "Look how strong it’s becoming!"
        } else if hasPredicted {
            return "Change the water and sunlight. Watch what happens over the days."
        } else {
            return "What do you think this little seed needs most?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("Will more water or more sunlight help it grow faster?")
                .font(.callout)
            
            HStack {
                Button("More water") { makePrediction("water") }
                Button("More sunlight") { makePrediction("sun") }
                Button("Both the same") { makePrediction("both") }
            }
        }
        .padding()
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .prediction, .patterns]
            
            // MAJOR STORY ECHO: The Seed That Whispered Back
            checkForMajorSeedWhisperEcho()
            if discoveredMajorEcho != nil {
                showMajorEchoMoment = true
            }
            
            onComplete("Plant growth experiment", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share what I learned about growing")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private func checkForMajorSeedWhisperEcho() {
        guard discoveredMajorEcho == nil else { return }
        
        let consistentCare = water > 0.6 && sunlight > 0.55 && day >= 4
        let surprisingGrowth = growth > 0.75
        
        guard consistentCare && surprisingGrowth else { return }
        
        let context = EchoService.MajorEchoContext(
            experimentID: "growing-secrets",
            wasPerfectSynthesis: true,
            secondaryScore: min(growth, 1.0)
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
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(hero.primaryColor.opacity(0.25), lineWidth: 1.5)
        )
    }
    
    // Major Story Echo card — The Seed That Whispered Back
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
                colors: [hero.primaryColor.opacity(0.08), Color.sparkCardFill.opacity(0.95)],
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
    
    private func checkForEchoAndReflect() {
        let consistent = water > 0.4 && water < 0.7 && sunlight > 0.5
        let surprising = growth > 0.85 && (water < 0.35 || sunlight < 0.4)
        
        if let echo = EchoService.echoForGrowingSecrets(consistentCare: consistent, surprisingGrowth: surprising) {
            if !profile.collectedEchoIDs.contains(echo.id) {
                withAnimation {
                    discoveredEcho = echo
                }
                profile.collectedEchoIDs.append(echo.id)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        showReflection = true
    }
}