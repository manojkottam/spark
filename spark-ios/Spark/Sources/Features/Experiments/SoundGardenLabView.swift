import SwiftUI

struct SoundGardenLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var selectedMaterials: [String] = []
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private let materials = [
        ("Rice Shaker", "gentle rattling"),
        ("Pebbles", "sharp clicking"),
        ("Dried Leaves", "soft rustling"),
        ("Metal Lid", "bright ringing"),
        ("Wooden Block", "deep knocking")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // Sound material grid
            VStack(alignment: .leading, spacing: 10) {
                Text("Tap the materials to listen")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(materials, id: \.0) { material in
                        SoundMaterialButton(
                            name: material.0,
                            description: material.1,
                            isSelected: selectedMaterials.contains(material.0),
                            color: hero.primaryColor
                        ) {
                            toggleMaterial(material.0)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            if selectedMaterials.count >= 2 {
                resultView
            }
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if showReflection {
                reflectionView
            } else if selectedMaterials.count >= 3 {
                Button {
                    showReflection = true
                } label: {
                    Text("I heard something important")
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
            return "That sound… it felt different from the others. The Shimmer heard it too."
        } else if selectedMaterials.count >= 3 {
            return "You’re really listening now. What did those sounds tell you?"
        } else if hasPredicted {
            return "Good question. Now let’s listen carefully together."
        } else {
            return "Close your eyes and listen. Which material do you think will sound the most alive?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("Which material do you think will make the most interesting sound?")
                .font(.callout)
            
            HStack(spacing: 8) {
                ForEach(["Rice", "Pebbles", "Leaves", "Metal", "Wood"], id: \.self) { mat in
                    Button(mat) {
                        prediction = mat
                        hasPredicted = true
                    }
                    .buttonStyle(PredictionButtonStyle(isSelected: prediction == mat, color: hero.primaryColor))
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var resultView: some View {
        VStack(spacing: 6) {
            Text("You created a sound orchestra")
                .font(.headline)
            Text(selectedMaterials.joined(separator: " + "))
                .font(.callout)
                .foregroundStyle(hero.primaryColor)
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
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .patterns, .prediction]
            onComplete("Sound Orchestra", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share what I heard")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private func toggleMaterial(_ name: String) {
        if selectedMaterials.contains(name) {
            selectedMaterials.removeAll { $0 == name }
        } else {
            selectedMaterials.append(name)
            
            // Haptic feedback for "playing" the material
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            checkForEchoAfterSelection()
        }
    }
    
    private func checkForEchoAfterSelection() {
        // Special combination: Rice + Leaves + Wood (very soft, listening required)
        if selectedMaterials.count == 3 &&
           selectedMaterials.contains("Rice Shaker") &&
           selectedMaterials.contains("Dried Leaves") &&
           selectedMaterials.contains("Wooden Block") {
            
            if let echo = EchoFragment.all.first(where: { $0.id == "echo_listening_stone" }) {
                if !profile.collectedEchoIDs.contains(echo.id) {
                    withAnimation {
                        discoveredEcho = echo
                    }
                    profile.collectedEchoIDs.append(echo.id)
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            }
        }
        
        // All five materials (rare, collaborative moment)
        if selectedMaterials.count == 5 {
            if let echo = EchoFragment.all.first(where: { $0.id == "echo_many_voices" }) {
                if !profile.collectedEchoIDs.contains(echo.id) {
                    withAnimation {
                        discoveredEcho = echo
                    }
                    profile.collectedEchoIDs.append(echo.id)
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            }
        }
    }
}

// MARK: - Supporting View
struct SoundMaterialButton: View {
    let name: String
    let description: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(name)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(description)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white.opacity(0.85) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? color : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(isSelected ? 0 : 0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}