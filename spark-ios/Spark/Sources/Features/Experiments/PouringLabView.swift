import SwiftUI

struct PouringLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var waterLevelA: Double = 0.6
    @State private var waterLevelB: Double = 0.4
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var containerAHeight: Double { waterLevelA * 120 }
    private var containerBHeight: Double { waterLevelB * 120 }
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // Two containers
            HStack(spacing: 40) {
                VStack {
                    Text("Container A")
                        .font(.callout.weight(.medium))
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(hero.primaryColor, lineWidth: 3)
                            .frame(width: 90, height: 130)
                        Rectangle()
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: 84, height: containerAHeight)
                            .animation(.spring, value: waterLevelA)
                    }
                    Text("\(Int(waterLevelA * 100)) units")
                        .font(.caption)
                }
                
                VStack {
                    Text("Container B")
                        .font(.callout.weight(.medium))
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(hero.primaryColor, lineWidth: 3)
                            .frame(width: 70, height: 130) // narrower but same height
                        Rectangle()
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: 64, height: containerBHeight)
                            .animation(.spring, value: waterLevelB)
                    }
                    Text("\(Int(waterLevelB * 100)) units")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.sparkCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Controls
            VStack(spacing: 16) {
                VStack {
                    Text("Pour into A: \(Int(waterLevelA * 100))")
                    Slider(value: $waterLevelA, in: 0...1)
                        .tint(hero.primaryColor)
                }
                
                VStack {
                    Text("Pour into B: \(Int(waterLevelB * 100))")
                    Slider(value: $waterLevelB, in: 0...1)
                        .tint(hero.primaryColor)
                }
            }
            .padding()
            .background(Color.sparkCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if showReflection {
                reflectionView
            } else if abs(waterLevelA - waterLevelB) > 0.15 {
                Button {
                    checkForSurpriseAndReflect()
                } label: {
                    Text("I think I understand now")
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
            return "Even when it looked different… it was the same amount all along."
        } else if abs(waterLevelA - waterLevelB) < 0.1 {
            return "Interesting… they look almost the same now."
        } else if hasPredicted {
            return "Let’s play with the levels and see what’s really true."
        } else {
            return "Do you think these two containers hold the same amount?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("Which container holds more water right now?")
                .font(.callout)
            
            HStack(spacing: 8) {
                Button("A holds more") { makePrediction("A") }
                Button("B holds more") { makePrediction("B") }
                Button("They’re equal") { makePrediction("equal") }
            }
        }
        .padding()
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.prediction, .quantitative, .observation]
            onComplete("Water levels explored", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share what I discovered")
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
    
    private func makePrediction(_ choice: String) {
        prediction = choice
        hasPredicted = true
    }
    
    private func checkForSurpriseAndReflect() {
        let difference = abs(waterLevelA - waterLevelB)
        let isSurprise = difference < 0.08 && (waterLevelA > 0.3 && waterLevelB > 0.3)
        
        if isSurprise, let echo = EchoService.echoForPouringLab(surprise: true, accuracy: 1.0 - difference) {
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