import SwiftUI

struct PatternGardenLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var pattern: [PatternBlock] = []
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var discoveredMajorEcho: EchoFragment?   // Major story echo (Final Echo Moment)
    @State private var showMajorEchoMoment = false          // Cinematic full-screen takeover
    @State private var showReflection = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    // Available block types for building patterns
    private let blockTypes: [PatternBlock] = [
        .redCircle, .yellowCircle, .blueCircle,
        .redSquare, .yellowSquare, .blueSquare
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // Current Pattern Display
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Pattern So Far")
                    .font(.headline)
                
                if pattern.isEmpty {
                    Text("Start building your pattern by tapping blocks below")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.sparkCardFill.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(pattern.enumerated()), id: \.offset) { index, block in
                                PatternBlockView(block: block)
                                    .onTapGesture {
                                        removeBlock(at: index)
                                    }
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .frame(height: 70)
                    .background(Color.sparkCardFill)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            
            // Block Palette
            VStack(alignment: .leading, spacing: 10) {
                Text("Tap to add blocks")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(blockTypes, id: \.self) { block in
                        Button {
                            addBlock(block)
                        } label: {
                            PatternBlockView(block: block, isPalette: true)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .background(Color.sparkCardFill)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Result / Insight
            if pattern.count >= 4 {
                resultView
            }
            
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            if let major = discoveredMajorEcho {
                majorEchoFragmentCard(major)
            }
            
            if showReflection {
                reflectionView
            } else if pattern.count >= 6 {
                Button {
                    checkForSpecialPatternAndShowReflection()
                } label: {
                    Text("I see a pattern")
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
    
    // MARK: - Subviews
    
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
            return "That pattern... it feels like it was always waiting to be found."
        } else if pattern.count >= 6 {
            return "You're seeing something now. Can you describe the rule?"
        } else if hasPredicted {
            return "Good question. Let's build and see what the pattern wants to become."
        } else {
            return "What kind of pattern do you think will appear?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            
            Text("What kind of pattern do you think you'll make?")
                .font(.callout)
            
            HStack(spacing: 8) {
                ForEach(["Repeating", "Growing", "Alternating", "Random"], id: \.self) { type in
                    Button(type) {
                        prediction = type
                        hasPredicted = true
                    }
                    .buttonStyle(PredictionButtonStyle(isSelected: prediction == type, color: hero.primaryColor))
                }
            }
        }
        .padding()
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var resultView: some View {
        VStack(spacing: 6) {
            Text("You've built a pattern with \(pattern.count) blocks")
                .font(.headline)
            
            Text("Can you describe the rule?")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.sparkCardFill)
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
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(hero.primaryColor.opacity(0.25), lineWidth: 1.5)
        )
    }
    
    // Major Story Echo card (Final Echo Moment) — "The Pattern That Remembered Its Own Name"
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
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.patterns, .observation, .prediction]
            
            // Safety net for major ancient memory echo
            checkForMajorAncientMemoryEcho()
            if discoveredMajorEcho != nil {
                showMajorEchoMoment = true
            }
            
            onComplete("Pattern with \(pattern.count) blocks", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share the pattern I found")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    // MARK: - Logic
    
    private func addBlock(_ block: PatternBlock) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            pattern.append(block)
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Check for special patterns that might trigger echoes
        checkForSpecialPattern()
    }
    
    private func removeBlock(at index: Int) {
        guard index < pattern.count else { return }
        withAnimation {
            pattern.remove(at: index)
        }
    }
    
    private func checkForSpecialPattern() {
        guard pattern.count >= 5 else { return }
        
        // Check for repeating pattern of length 3 or more
        let lastThree = Array(pattern.suffix(3))
        if lastThree == Array(pattern.dropLast(3).suffix(3)) && pattern.count >= 6 {
            triggerEchoIfNotCollected("echo_patterns")
        }
        
        // Check for alternating two colors
        if pattern.count >= 6 {
            let even = stride(from: 0, to: pattern.count, by: 2).map { pattern[$0] }
            let odd = stride(from: 1, to: pattern.count, by: 2).map { pattern[$0] }
            
            if Set(even).count == 1 && Set(odd).count == 1 && even[0] != odd[0] {
                triggerEchoIfNotCollected("echo_two_lights")
            }
        }
        
        // MAJOR STORY ECHO: The Pattern That Remembered Its Own Name (ancient_memory)
        // Long pattern + clear repeating structure = elegant synthesis the Shimmer recognizes.
        checkForMajorAncientMemoryEcho()
    }
    
    private func checkForMajorAncientMemoryEcho() {
        guard discoveredMajorEcho == nil, pattern.count >= 7 else { return }
        
        // Require some repeating structure (elegance)
        let hasRepeatingCore = pattern.count >= 6 &&
            Array(pattern.suffix(3)) == Array(pattern.dropLast(3).suffix(3))
        
        guard hasRepeatingCore else { return }
        
        let context = EchoService.MajorEchoContext(
            experimentID: "pattern-garden",
            wasPerfectSynthesis: true,
            secondaryScore: Double(min(pattern.count, 12)) / 12.0   // longer = more special
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
    
    private func triggerEchoIfNotCollected(_ echoID: String) {
        guard let echo = EchoFragment.all.first(where: { $0.id == echoID }),
              !profile.collectedEchoIDs.contains(echo.id) else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            discoveredEcho = echo
        }
        profile.collectedEchoIDs.append(echo.id)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    private func checkForSpecialPatternAndShowReflection() {
        checkForSpecialPattern()
        showReflection = true
    }
}

// MARK: - Pattern Block Model
enum PatternBlock: Hashable, CaseIterable {
    case redCircle, yellowCircle, blueCircle
    case redSquare, yellowSquare, blueSquare
    
    var color: Color {
        switch self {
        case .redCircle, .redSquare: .red
        case .yellowCircle, .yellowSquare: .yellow
        case .blueCircle, .blueSquare: .blue
        }
    }
    
    var symbol: String {
        switch self {
        case .redCircle, .yellowCircle, .blueCircle: "●"
        case .redSquare, .yellowSquare, .blueSquare: "■"
        }
    }
}

struct PatternBlockView: View {
    let block: PatternBlock
    var isPalette: Bool = false
    
    var body: some View {
        Text(block.symbol)
            .font(.system(size: isPalette ? 42 : 32, weight: .bold))
            .foregroundStyle(block.color)
            .frame(width: isPalette ? 56 : 46, height: isPalette ? 56 : 46)
            .background(
                RoundedRectangle(cornerRadius: isPalette ? 12 : 8)
                    .fill(block.color.opacity(0.15))
            )
            .shadow(color: .black.opacity(0.12), radius: 3, y: 2)
    }
}
