import SwiftUI

/// A small, soft glowing sparkle that gently twinkles.
/// Used to evoke the living crystal light of The Shimmer.
struct CrystalSparkle: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    
    @State private var isTwinkling = false
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: size > 3 ? 1.5 : 0.8)
            .opacity(isTwinkling ? 0.9 : 0.15)
            .scaleEffect(isTwinkling ? 1.0 : 0.4)
            .animation(
                .easeInOut(duration: 1.6)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: isTwinkling
            )
            .onAppear {
                isTwinkling = true
            }
    }
}
