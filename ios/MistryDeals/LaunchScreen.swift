import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    DesignColors.background,
                    DesignColors.secondaryBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(DesignColors.accent)

                    Text("MistryDeals")
                        .font(DesignTypography.displayLarge)
                        .foregroundColor(DesignColors.primary)

                    Text("Best Deals & Buying Guides")
                        .font(DesignTypography.bodySmall)
                        .foregroundColor(DesignColors.secondary)
                }

                Spacer()

                ProgressView()
                    .tint(DesignColors.accent)
                    .scaleEffect(1.2)

                Spacer()
                    .frame(height: 40)
            }
            .padding(DesignSpacing.lg)
        }
    }
}

#Preview {
    LaunchScreen()
}
