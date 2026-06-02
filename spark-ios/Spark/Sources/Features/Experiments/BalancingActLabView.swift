import SwiftUI

struct BalancingActLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var leftWeight: Double = 3
    @State private var rightWeight: Double = 3
    @State private var leftPosition: Double = 2
    @State private var rightPosition: Double = 2
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var discoveredMajorEcho: EchoFragment?   // Major story echo (Final Echo Moment)
    @State private var showMajorEchoMoment = false          // Cinematic full-screen takeover
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var balance: Double {
        (leftWeight * leftPosition) - (rightWeight * rightPosition)
    }
    
    private var isBalanced: Bool {
        abs(balance) < 0.6
    }
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // Seesaw / Balance
            ZStack {
                // Base
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 30)
                    .offset(y: 70)
                
                // Beam
                RoundedRectangle(cornerRadius: 8)
                    .fill(hero.primaryColor)
                    .frame(width: 260, height: 14)
                    .rotationEffect(.degrees(balance * 6))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: balance)
                
                // Left weight
                VStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 36 + CGFloat(leftWeight * 3), height: 36 + CGFloat(leftWeight * 3))
                    Text("\(Int(leftWeight))")
                        .font(.caption.bold())
                }
                .offset(x: -80 + CGFloat((leftPosition - 2) * 20), y: -20)
                
                // Right weight
                VStack {
                    Circle()
                        .fill(.blue)
                        .frame(width: 36 + CGFloat(rightWeight * 3), height: 36 + CGFloat(rightWeight * 3))
                    Text("\(Int(rightWeight))")
                        .font(.caption.bold())
                }
                .offset(x: 80 - CGFloat((rightPosition - 2) * 20), y: -20)
            }
            .frame(height: 160)
            .background(Color.sparkCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Controls
            VStack(spacing: 16) {
                HStack {
                    VStack {
                        Text("Left Weight: \(Int(leftWeight))")
                        Slider(value: $leftWeight, in: 1...6, step: 1)
                    }
                    VStack {
                        Text("Right Weight: \(Int(rightWeight))")
                        Slider(value: $rightWeight, in: 1...6, step: 1)
                    }
                }
                
                HStack {
                    VStack {
                        Text("Left Position")
                        Slider(value: $leftPosition, in: 1...3, step: 0.1)
                    }
                    VStack {
                        Text("Right Position")
                        Slider(value: $rightPosition, in: 1...3, step: 0.1)
                    }
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
                    Text("I found the balance")
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
            return "When everything was perfectly still… that was the real discovery."
        } else if isBalanced {
            return "Look at that! It found its balance."
        } else if hasPredicted {
            return "Move the weights and positions. Feel what the balance wants."
        } else {
            return "Where do you think the weights need to sit?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("Will a heavier weight closer to the center balance a lighter weight farther out?")
                .font(.callout)
            
            HStack {
                Button("Yes") { makePrediction("yes") }
                Button("No") { makePrediction("no") }
            }
        }
        .padding()
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.prediction, .quantitative, .iteration]
            checkForMajorThresholdEcho()
            if discoveredMajorEcho != nil {
                showMajorEchoMoment = true
            }
            onComplete("Balance experiment", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share what I learned about balance")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
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
    
    // Major Story Echo card (threshold — courage + stillness)
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
        let perfect = isBalanced && abs(leftWeight - rightWeight) < 0.5
        let surprise = abs(leftWeight - rightWeight) > 2.5 && isBalanced
        
        if let echo = EchoService.echoForBalancingAct(perfectBalance: perfect, surprisingLightObject: surprise) {
            if !profile.collectedEchoIDs.contains(echo.id) {
                withAnimation {
                    discoveredEcho = echo
                }
                profile.collectedEchoIDs.append(echo.id)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        
        // MAJOR STORY ECHO contribution for threshold (perfect still + prior ramp bravery)
        checkForMajorThresholdEcho()
        
        showReflection = true
    }
    
    private func checkForMajorThresholdEcho() {
        guard discoveredMajorEcho == nil else { return }
        
        // "Stillness" side: very clean perfect balance, especially with unequal weights (gentle control)
        let isPerfectStill = isBalanced && abs(leftWeight - rightWeight) < 1.0
        
        guard isPerfectStill else { return }
        
        let context = EchoService.MajorEchoContext(
            experimentID: "balancing-act",
            wasPerfectSynthesis: true,
            secondaryScore: 0.88
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
}