import SwiftUI

// MARK: - Glass Morphism Modifier
struct GlassView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            // Frosted glass background
            BlurView(style: .systemThickMaterialDark)
            
            // Overlay with subtle color
            Color.white.opacity(0.05)
            
            content
        }
    }
}

extension View {
    func glassEffect() -> some View {
        modifier(GlassView())
    }
}

// MARK: - Blur View for Glass Effect
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Border Bottom Modifier
struct BorderBottomModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Divider()
                .background(color)
        }
    }
}

extension View {
    func borderBottom(_ color: Color) -> some View {
        modifier(BorderBottomModifier(color: color))
    }
}
