import SwiftUI

struct AttributeDetectivesLabView: View {
    let profile: ChildProfile
    let onComplete: (String, [LearningDisposition], EchoFragment?) -> Void
    
    @State private var items: [DetectiveItem] = []
    @State private var groupA: [DetectiveItem] = []
    @State private var groupB: [DetectiveItem] = []
    @State private var hasPredicted = false
    @State private var prediction: String = ""
    @State private var discoveredEcho: EchoFragment?
    @State private var showReflection = false
    @State private var ruleDescription: String = ""
    
    private var hero: Hero {
        Hero.hero(for: profile.chosenHeroID)
    }
    
    private let allItems: [DetectiveItem] = [
        .init(name: "🍎", color: "red", size: "small"),
        .init(name: "🍌", color: "yellow", size: "big"),
        .init(name: "🫐", color: "blue", size: "small"),
        .init(name: "🍊", color: "orange", size: "big"),
        .init(name: "🍓", color: "red", size: "big"),
        .init(name: "🥝", color: "green", size: "small"),
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            heroCompanionView
            
            if !hasPredicted {
                predictionView
            }
            
            // Two sorting groups
            HStack(spacing: 16) {
                SortingGroup(title: "Group A", items: groupA, color: .red) { item in
                    moveItem(item, to: &groupA, from: &groupB)
                }
                
                SortingGroup(title: "Group B", items: groupB, color: .blue) { item in
                    moveItem(item, to: &groupB, from: &groupA)
                }
            }
            
            // Available items
            VStack(alignment: .leading, spacing: 8) {
                Text("Items to sort")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 8) {
                    ForEach(remainingItems) { item in
                        Button {
                            moveToGroup(item)
                        } label: {
                            Text(item.name)
                                .font(.largeTitle)
                                .padding(8)
                                .background(Color.sparkCardFill)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
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
            } else if groupA.count + groupB.count >= 4 {
                VStack {
                    TextField("What is your sorting rule?", text: $ruleDescription)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        checkForBeautifulSorting()
                    } label: {
                        Text("I discovered the hidden rule")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(hero.primaryColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding()
                .background(Color.sparkCardFill)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            if items.isEmpty {
                items = allItems.shuffled()
            }
        }
    }
    
    private var remainingItems: [DetectiveItem] {
        let used = Set(groupA + groupB)
        return items.filter { !used.contains($0) }
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
            return "You found a rule that was hiding in plain sight."
        } else if groupA.count + groupB.count >= 4 {
            return "What rule are you using to sort them?"
        } else if hasPredicted {
            return "Drag the items into the two groups and discover the pattern."
        } else {
            return "How do you think these things belong together?"
        }
    }
    
    private var predictionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prediction")
                .font(.headline)
            Text("Will you sort them by color, size, or something else?")
                .font(.callout)
            
            HStack {
                Button("Color") { makePrediction("color") }
                Button("Size") { makePrediction("size") }
                Button("Something else") { makePrediction("other") }
            }
        }
        .padding()
        .background(Color.sparkCardFill)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var reflectionView: some View {
        Button {
            let dispositions: [LearningDisposition] = [.observation, .patterns, .prediction]
            onComplete("Sorting rule discovered", dispositions, discoveredEcho)
        } label: {
            Text("I’m ready to share my sorting rule")
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
    
    private func moveToGroup(_ item: DetectiveItem) {
        if groupA.count <= groupB.count {
            groupA.append(item)
        } else {
            groupB.append(item)
        }
        checkForBeautifulSorting()
    }
    
    private func moveItem(_ item: DetectiveItem, to target: inout [DetectiveItem], from source: inout [DetectiveItem]) {
        if let index = source.firstIndex(of: item) {
            source.remove(at: index)
            target.append(item)
        }
    }
    
    private func checkForBeautifulSorting() {
        // Simple elegant rule detection for echo
        let allRed = groupA.allSatisfy { $0.color == "red" } && groupB.allSatisfy { $0.color != "red" }
        let sizeRule = groupA.allSatisfy { $0.size == "small" } && groupB.allSatisfy { $0.size == "big" }
        
        if (allRed || sizeRule) && (groupA.count + groupB.count) >= 5 {
            if let echo = EchoService.echoForAttributeDetectives(clearRule: true, elegantRule: true) {
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

struct DetectiveItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let color: String
    let size: String
}

// MARK: - Supporting Views
struct SortingGroup: View {
    let title: String
    let items: [DetectiveItem]
    let color: Color
    let onRemove: (DetectiveItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.callout.weight(.semibold))
                .foregroundStyle(color)
            
            VStack {
                if items.isEmpty {
                    Text("Drop items here")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity, minHeight: 80)
                } else {
                    ForEach(items) { item in
                        Text(item.name)
                            .font(.title)
                            .onTapGesture { onRemove(item) }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 90)
            .padding(8)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}