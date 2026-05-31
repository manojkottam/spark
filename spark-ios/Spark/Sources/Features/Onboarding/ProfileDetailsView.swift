import SwiftUI
import SwiftData

struct ProfileDetailsView: View {
    let hero: Hero
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var childName: String = ""
    @State private var selectedGrade: Grade?
    @FocusState private var nameFieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            Color.sparkBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 36) {
                    // Hero greeting header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(hero.primaryColor.opacity(0.15))
                                .frame(width: 110, height: 110)
                            
                            Text(hero.emoji)
                                .font(.system(size: 60))
                        }
                        
                        Text("Hi! I'm \(hero.name).")
                            .font(.sparkTitle)
                            .foregroundStyle(hero.primaryColor)
                        
                        Text(heroGreeting)
                            .font(.sparkBody)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 24)
                    
                    // Name input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What should we call you?")
                            .font(.sparkHeadline)
                            .foregroundStyle(.primary)
                        
                        TextField("Your name", text: $childName)
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
                            )
                            .focused($nameFieldIsFocused)
                            .submitLabel(.next)
                            .onSubmit {
                                nameFieldIsFocused = false
                            }
                    }
                    .padding(.horizontal, 28)
                    
                    // Grade selection
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Which grade are you in?")
                            .font(.sparkHeadline)
                            .foregroundStyle(.primary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                            ForEach(Grade.allCases, id: \.self) { grade in
                                GradeChip(
                                    grade: grade,
                                    isSelected: selectedGrade == grade,
                                    accentColor: hero.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedGrade = grade
                                    }
                                    
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    Spacer(minLength: 20)
                    
                    // Continue button
                    Button {
                        saveProfileAndFinish()
                    } label: {
                        Text(continueButtonTitle)
                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                canContinue ? hero.primaryColor : Color.gray.opacity(0.25)
                            )
                            .foregroundStyle(canContinue ? .white : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: .buttonCorner, style: .continuous))
                            .shadow(
                                color: canContinue ? hero.primaryColor.opacity(0.35) : .clear,
                                radius: 14,
                                y: 6
                            )
                    }
                    .disabled(!canContinue)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: canContinue)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Actions
    
    private func saveProfileAndFinish() {
        guard let grade = selectedGrade else { return }
        
        let trimmedName = childName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let profile = ChildProfile(
            name: trimmedName,
            grade: grade,
            chosenHeroID: hero.id
        )
        
        modelContext.insert(profile)
        
        // The root view (ContentRootView) will automatically switch to MainAppView
        // because of the @Query observing the model context.
    }
    
    // MARK: - Computed
    
    private var canContinue: Bool {
        !childName.trimmingCharacters(in: .whitespaces).isEmpty && selectedGrade != nil
    }
    
    private var continueButtonTitle: String {
        if let grade = selectedGrade {
            return "Let's explore with \(hero.name)!"
        } else {
            return "Let's begin"
        }
    }
    
    private var heroGreeting: String {
        switch hero.id {
        case .flint:
            return "I love big discoveries and wild experiments. We're going to have so much fun together!"
        case .pebby:
            return "I collect knowledge pebbles with my friends. I can't wait to learn with you."
        case .lumi:
            return "I love noticing the quiet, beautiful things. What do you think we'll discover?"
        }
    }
}

// MARK: - Grade Chip
private struct GradeChip: View {
    let grade: Grade
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(grade.displayName)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    isSelected 
                    ? accentColor 
                    : Color.white
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(
                            isSelected ? accentColor : Color.black.opacity(0.08),
                            lineWidth: isSelected ? 0 : 1.5
                        )
                )
                .shadow(
                    color: isSelected ? accentColor.opacity(0.25) : .black.opacity(0.04),
                    radius: isSelected ? 10 : 4,
                    y: isSelected ? 4 : 2
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Grade Display Helper
extension Grade {
    var displayName: String {
        switch self {
        case .kindergarten: "Kindergarten"
        case .first: "1st Grade"
        case .second: "2nd Grade"
        case .third: "3rd Grade"
        case .fourth: "4th Grade"
        case .fifth: "5th Grade"
        }
    }
}

#Preview {
    NavigationStack {
        ProfileDetailsView(hero: Hero.all[0])
    }
}
