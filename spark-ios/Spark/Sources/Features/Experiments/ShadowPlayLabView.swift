import SwiftUI

struct ShadowPlayLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var lightAngle: Double = 45
    @State private var objectHeight: Double = 50
    @State private var hasMultipleLights = false
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private var shadowSize: Double {
        let base = 30 + (objectHeight * 0.8)
        let angleFactor = sin(lightAngle * .pi / 180)
        return max(20, base / max(0.3, angleFactor))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // The Shadow Scene
            ZStack {
                // Wall / Ground
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#F5F0E6"))
                    .frame(height: 220)
                
                // Light source
                Circle()
                    .fill(Color.yellow.opacity(0.9))
                    .frame(width: 36, height: 36)
                    .shadow(color: .yellow.opacity(0.5), radius: 20)
                    .offset(x: CGFloat(lightAngle - 45) * 1.8 - 60, y: -70)
                
                // Object casting shadow
                RoundedRectangle(cornerRadius: 6)
                    .fill(hero.primaryColor)
                    .frame(width: 28, height: objectHeight)
                    .offset(x: -30, y: CGFloat(80 - objectHeight/2))
                
                // Shadow
                Ellipse()
                    .fill(Color.black.opacity(0.35))
                    .frame(width: shadowSize, height: 18)
                    .offset(x: CGFloat(lightAngle - 45) * 2.5 + 40, y: 85)
                    .animation(.spring(response: 0.4), value: lightAngle)
                    .animation(.spring(response: 0.4), value: objectHeight)
                
                if hasMultipleLights {
                    Circle()
                        .fill(Color.orange.opacity(0.7))
                        .frame(width: 28, height: 28)
                        .offset(x: 80, y: -55)
                    
                    Ellipse()
                        .fill(Color.black.opacity(0.25))
                        .frame(width: shadowSize * 0.7, height: 14)
                        .offset(x: 20, y: 85)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Controls
            VStack(spacing: 16) {
                VStack {
                    Text("Light Angle: \(Int(lightAngle))°")
                    Slider(value: $lightAngle, in: 20...80)
                        .tint(hero.primaryColor)
                }
                
                VStack {
                    Text("Object Height: \(Int(objectHeight))")
                    Slider(value: $objectHeight, in: 20...90)
                        .tint(hero.primaryColor)
                }
                
                Toggle("Add second light", isOn: $hasMultipleLights)
                    .tint(hero.primaryColor)
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if showReflection {
                reflectionView
            } else if hasPredicted {
                Button {
                    checkForEchoAndReflect()
                } label: {
                    Text("I understand shadows now")
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
        if discoveredEcho != nil {
            return "Look at those edges… they were hiding something beautiful."
        } else if hasMultipleLights {
            return "Two lights change everything. The shadows start talking to each other."
        } else if hasPredicted {
            return "Move the light and the object. Watch what the shadow does."
        } else {
            return "How do you think the shadow will change?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("When the light moves higher, will the shadow get bigger or smaller?")
                .font(.callout)
            
            HStack {
                Button("Bigger") { makePrediction("bigger") }
                Button("Smaller") { makePrediction("smaller") }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .patterns, .prediction]
            onComplete("Shadow experiment", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share what I saw")
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
        .background(Color.white)
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
    
    private func checkForEchoAndReflect() {
        let perfectEdge = abs(lightAngle - 50) < 8 && objectHeight > 60
        let multiple = hasMultipleLights
        
        if let echo = EchoService.echoForShadowPlay(perfectEdge: perfectEdge, multipleLights: multiple) {
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