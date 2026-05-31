import SwiftUI

struct MirrorWorldsLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var leftSide: [MirrorBlock] = []
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private let availableBlocks: [MirrorBlock] = [.red, .yellow, .blue, .green]
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // The Mirror Interface
            VStack(spacing: 8) {
                Text("Left Side (You)")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 12) {
                    ForEach(leftSide, id: \.self) { block in
                        MirrorBlockView(color: block.color)
                            .onTapGesture { removeBlock(block) }
                    }
                }
                .frame(height: 70)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text("Mirror Side (Magic)")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(hero.primaryColor)
                
                HStack(spacing: 12) {
                    ForEach(leftSide.reversed(), id: \.self) { block in
                        MirrorBlockView(color: block.color)
                            .opacity(0.85)
                    }
                }
                .frame(height: 70)
                .padding()
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(hero.primaryColor.opacity(0.3), lineWidth: 2)
                )
            }
            
            // Block Palette
            VStack(alignment: .leading, spacing: 10) {
                Text("Add blocks to the left side")
                    .font(.headline)
                
                HStack(spacing: 16) {
                    ForEach(availableBlocks, id: \.self) { block in
                        Button {
                            addBlock(block)
                        } label: {
                            MirrorBlockView(color: block.color, size: 52)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            if leftSide.count >= 3 {
                resultView
            }
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if showReflection {
                reflectionView
            } else if leftSide.count >= 4 {
                Button {
                    checkForEchoAndReflect()
                } label: {
                    Text("I see the reflection now")
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
            return "When the two sides became one… that was the moment."
        } else if leftSide.count >= 4 {
            return "Look carefully at both sides. What stays the same?"
        } else if hasPredicted {
            return "Let’s build and see what the mirror shows us."
        } else {
            return "If you build something on this side, what do you think will appear on the other side?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("Will the mirror side look exactly the same, or will it be flipped?")
                .font(.callout)
            
            HStack(spacing: 8) {
                Button("Exactly the same") { makePrediction("same") }
                Button("Flipped / Mirrored") { makePrediction("flipped") }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var resultView: some View {
        VStack(spacing: 6) {
            Text("You built something with \(leftSide.count) blocks")
                .font(.headline)
            Text("The mirror is showing the reflection.")
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
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .patterns, .prediction]
            onComplete("Mirror pattern with \(leftSide.count) blocks", dispositions, discoveredEcho)
        } label: {
            Text("I understand the mirror now")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private func makePrediction(_ choice: String) {
        prediction = choice
        hasPredicted = true
    }
    
    private func addBlock(_ block: MirrorBlock) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            leftSide.append(block)
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        checkForSpecialSymmetry()
    }
    
    private func removeBlock(_ block: MirrorBlock) {
        if let index = leftSide.lastIndex(of: block) {
            withAnimation {
                leftSide.remove(at: index)
            }
        }
    }
    
    private func checkForSpecialSymmetry() {
        guard leftSide.count >= 4 else { return }
        
        // Perfect symmetry (palindrome)
        let isSymmetric = leftSide == leftSide.reversed()
        if isSymmetric && leftSide.count >= 5 {
            triggerEchoIfPossible("echo_many_voices")
        } else if isSymmetric && leftSide.count >= 3 {
            triggerEchoIfPossible("echo_two_lights")
        }
    }
    
    private func triggerEchoIfPossible(_ echoID: String) {
        guard let echo = EchoFragment.all.first(where: { $0.id == echoID }),
              !profile.collectedEchoIDs.contains(echo.id) else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            discoveredEcho = echo
        }
        profile.collectedEchoIDs.append(echo.id)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    private func checkForEchoAndReflect() {
        // Trigger any remaining echo based on current state
        let isSymmetric = leftSide == leftSide.reversed()
        if let echo = EchoService.echoForMirrorWorlds(hasSymmetry: isSymmetric, complexity: leftSide.count) {
            if !profile.collectedEchoIDs.contains(echo.id) {
                discoveredEcho = echo
                profile.collectedEchoIDs.append(echo.id)
            }
        }
        showReflection = true
    }
}

enum MirrorBlock: Hashable, CaseIterable {
    case red, yellow, blue, green
    
    var color: Color {
        switch self {
        case .red: .red
        case .yellow: .yellow
        case .blue: .blue
        case .green: .green
        }
    }
}

struct MirrorBlockView: View {
    let color: Color
    var size: CGFloat = 44
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
    }
}
