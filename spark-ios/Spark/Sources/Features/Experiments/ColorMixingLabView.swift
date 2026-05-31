import SwiftUI

struct ColorMixingLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var addedColors: [String] = []
    @State private var currentMix: MixResult?
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    @State private var isDragging = false
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private let primaryColors = ["red", "yellow", "blue"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Hero companion area
            heroCompanionView
            
            // Prediction
            if !hasPredicted && addedColors.isEmpty {
                predictionView
            }
            
            // The Mixing Canvas
            mixingCanvas
            
            // Color palette with real drag
            colorPalette
            
            // Result
            if let mix = currentMix {
                resultView(mix: mix)
            }
            
            // Echo Fragment discovery (beautiful moment)
            if let echo = discoveredEcho {
                echoFragmentCard(echo)
            }
            
            // Reflection
            if showReflection {
                reflectionView
            } else if currentMix != nil && discoveredEcho == nil {
                // Show reflection button once mixing is done
                Button {
                    showReflection = true
                } label: {
                    Text("I noticed something")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(hero.primaryColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 8)
            }
            
            Spacer(minLength: 20)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Subviews
    
    private var heroCompanionView: some View {
        HStack(spacing: 12) {
            Text(hero.emoji)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(hero.name) says:")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(hero.primaryColor)
                
                Text(heroComment)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: hero.primaryColor.opacity(0.1), radius: 8, y: 3)
        )
    }
    
    private var heroComment: String {
        if let mix = currentMix {
            return heroReaction(for: mix)
        } else if hasPredicted {
            return "Great prediction! Now let's see what actually happens..."
        } else {
            return "Take your time. What do you think these colors will become?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Make a prediction first")
                .font(.headline)
            
            HStack(spacing: 8) {
                ForEach(["Orange", "Green", "Purple", "Brown"], id: \.self) { color in
                    Button {
                        prediction = color
                        hasPredicted = true
                    } label: {
                        Text(color)
                            .font(.callout.weight(.medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                prediction == color 
                                ? hero.primaryColor 
                                : Color.white
                            )
                            .foregroundStyle(prediction == color ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var mixingCanvas: some View {
        ZStack {
            // Warm paper background
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(hex: "#F8F5F0"))
                .shadow(color: .black.opacity(0.08), radius: 14, y: 5)
            
            // Subtle shimmer overlay (use generated crystal image here in real build)
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.15), Color.clear, Color.white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack {
                Text("Mixing Paper")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary.opacity(0.7))
                    .padding(.top, 14)
                
                Spacer()
                
                // Live mix preview
                if let mix = currentMix {
                    Circle()
                        .fill(Color(hex: mix.colorHex))
                        .frame(width: 135, height: 135)
                        .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.5), lineWidth: 10)
                                .blur(radius: 0.5)
                        )
                        .scaleEffect(isDragging ? 1.05 : 1.0)
                        .animation(.spring(response: 0.3), value: isDragging)
                } else {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 170, height: 95)
                        .overlay(
                            Text("Drag colors onto the paper")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        )
                }
                
                Spacer()
            }
        }
        .frame(height: 230)
        .dropDestination(for: String.self) { items, location in
            guard let color = items.first, !addedColors.contains(color), addedColors.count < 3 else { return false }
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                addedColors.append(color)
                currentMix = calculateMix(addedColors)
                checkForEchoFragment()
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            return true
        } isTargeted: { isTargeted in
            isDragging = isTargeted
        }
    }
    
    private var colorPalette: some View {
        HStack(spacing: 28) {
            ForEach(primaryColors, id: \.self) { colorKey in
                let isUsed = addedColors.contains(colorKey)
                
                Circle()
                    .fill(Color(hex: colorForKey(colorKey)))
                    .frame(width: 72, height: 72)
                    .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
                    .opacity(isUsed ? 0.3 : 1.0)
                    .scaleEffect(isUsed ? 0.85 : 1.0)
                    .draggable(colorKey) {
                        Circle()
                            .fill(Color(hex: colorForKey(colorKey)))
                            .frame(width: 60, height: 60)
                    }
                    .onTapGesture {
                        // Fallback tap support
                        if !isUsed && addedColors.count < 3 {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                addedColors.append(colorKey)
                                currentMix = calculateMix(addedColors)
                                checkForEchoFragment()
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
            }
        }
        .padding(.vertical, 12)
    }
    
    private func resultView(mix: MixResult) -> some View {
        VStack(spacing: 8) {
            Text(mix.name)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color(hex: mix.colorHex))
            
            Text(mix.description)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if hasPredicted && !prediction.isEmpty {
                Text("Your prediction: \(prediction)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .prediction, .iteration]
            onComplete(currentMix?.name ?? "Something beautiful", dispositions, discoveredEcho)
        } label: {
            Text("I noticed something special")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hero.primaryColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }
    
    // MARK: - Logic
    
    private func calculateMix(_ colors: [String]) -> MixResult {
        let hasRed = colors.contains("red")
        let hasYellow = colors.contains("yellow")
        let hasBlue = colors.contains("blue")
        
        if hasRed && hasYellow && hasBlue {
            return MixResult(colorHex: "#4A3728", name: "Deep Earth Brown", description: "All three colors together create something rich and grounded.")
        }
        if hasRed && hasYellow {
            return MixResult(colorHex: "#E67E22", name: "Warm Orange", description: "Red and yellow dance together into a glowing orange.")
        }
        if hasYellow && hasBlue {
            return MixResult(colorHex: "#27AE60", name: "Living Green", description: "Yellow and blue create the color of growing things.")
        }
        if hasRed && hasBlue {
            return MixResult(colorHex: "#8E44AD", name: "Mysterious Purple", description: "Red and blue meet to make something deep and magical.")
        }
        
        if hasRed { return MixResult(colorHex: "#E74C3C", name: "Bold Red", description: "Just red, standing strong.") }
        if hasYellow { return MixResult(colorHex: "#F1C40F", name: "Sunny Yellow", description: "Bright and cheerful yellow.") }
        if hasBlue { return MixResult(colorHex: "#3498DB", name: "Calm Blue", description: "Cool, steady blue.") }
        
        return MixResult(colorHex: "#ECF0F1", name: "Nothing yet", description: "Add some colors to begin.")
    }
    
    private func colorForKey(_ key: String) -> String {
        switch key {
        case "red": return "#E74C3C"
        case "yellow": return "#F1C40F"
        case "blue": return "#3498DB"
        default: return "#BDC3C7"
        }
    }
    
    private func heroReaction(for mix: MixResult) -> String {
        switch hero.id {
        case .flint:
            return "Whoa! Look at that \(mix.name.lowercased())! Did you see how it changed?"
        case .pebby:
            return "That's such a beautiful \(mix.name.lowercased()). I wonder how the colors feel about meeting each other."
        case .lumi:
            return "The way those colors became \(mix.name.lowercased())... it feels like a small miracle, doesn't it?"
        }
    }
    
    private func checkForEchoFragment() {
        guard let mix = currentMix else { return }
        
        if let echo = EchoService.echoForColorMix(colors: addedColors, resultName: mix.name) {
            // Only show if not already collected
            if !profile.collectedEchoIDs.contains(echo.id) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    discoveredEcho = echo
                }
                
                // Record the echo
                profile.collectedEchoIDs.append(echo.id)
                
                // Strong haptic for special moment
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }
    
    private func echoFragmentCard(_ echo: EchoFragment) -> some View {
        VStack(spacing: 10) {
            Text("✨ Something special just happened")
                .font(.caption.weight(.semibold))
                .foregroundStyle(hero.primaryColor)
            
            Text(echo.title)
                .font(.title3.weight(.semibold))
            
            Text(EchoService.reactionForEcho(echo, heroID: hero.id))
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: hero.primaryColor.opacity(0.15), radius: 14, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(hero.primaryColor.opacity(0.25), lineWidth: 1.5)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

struct MixResult {
    let colorHex: String
    let name: String
    let description: String
}

// Helper for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex.hasPrefix("#") ? String(hex.dropFirst()) : hex)
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
