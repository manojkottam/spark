import SwiftUI

struct ExperimentCard: View {
    let experiment: Experiment
    let hero: Hero
    let isRecommended: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Domain + Recommendation badge
            HStack {
                Text(experiment.domain.emoji)
                    .font(.title3)
                
                if isRecommended {
                    Text("Recommended for you")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(hero.primaryColor.opacity(0.15))
                        .foregroundStyle(hero.primaryColor)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Text("Level \(experiment.baseComplexity)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            // Title & Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(experiment.title)
                    .font(.sparkHeadline)
                    .foregroundStyle(.primary)
                
                if let subtitle = experiment.subtitle {
                    Text(subtitle)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Hook
            Text(experiment.hook)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // Disposition chips
            DispositionChips(
                dispositions: experiment.primaryDispositions,
                accentColor: hero.primaryColor
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(hero.primaryColor.opacity(0.15), lineWidth: 1)
        )
    }
}

private struct DispositionChips: View {
    let dispositions: [LearningDisposition]
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(dispositions.prefix(3), id: \.self) { disposition in
                Text(disposition.shortLabel)
                    .font(.caption2.weight(.medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.12))
                    .foregroundStyle(accentColor)
                    .clipShape(Capsule())
            }
            
            if dispositions.count > 3 {
                Text("+\(dispositions.count - 3)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ExperimentCard(
            experiment: Experiment.all[0],
            hero: Hero.all[0],
            isRecommended: true
        )
        ExperimentCard(
            experiment: Experiment.all[3],
            hero: Hero.all[2],
            isRecommended: false
        )
    }
    .padding()
    .background(Color.sparkBackground)
}