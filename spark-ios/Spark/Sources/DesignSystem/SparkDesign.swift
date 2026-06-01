import SwiftUI

// MARK: - Colors
extension Color {
    // Warm paper-like background used throughout the app
    // Slightly darkened from previous version for better contrast on real devices (especially iPad)
    static let sparkBackground = Color(red: 0.95, green: 0.94, blue: 0.925)
    
    // Hero primary colors (matching the model)
    static let flint = Color(red: 1.0, green: 0.42, blue: 0.21)
    static let pebby = Color(red: 0.49, green: 0.23, blue: 0.93)
    static let lumi  = Color(red: 0.13, green: 0.83, blue: 0.91)
    
    // Soft tints for card backgrounds when selected
    static let flintTint = Color(red: 1.0, green: 0.95, blue: 0.90)
    static let pebbyTint = Color(red: 0.96, green: 0.93, blue: 1.0)
    static let lumiTint  = Color(red: 0.90, green: 0.97, blue: 0.98)
}

// MARK: - Typography
extension Font {
    static let sparkTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let sparkHeadline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let sparkBody = Font.system(size: 17, weight: .regular, design: .rounded)
    static let sparkCallout = Font.system(size: 15, weight: .medium, design: .rounded)
}

// MARK: - Corner Radius
extension CGFloat {
    static let cardCorner: CGFloat = 28
    static let buttonCorner: CGFloat = 22
}
