import SwiftUI

struct PillSelector: View {
    @Binding var selectedTab: TabSelection

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 0) {
                PillSelectorItem(
                    label: "Featured",
                    isSelected: selectedTab == .featured,
                    action: { selectedTab = .featured }
                )

                PillSelectorItem(
                    label: "Prime",
                    isSelected: selectedTab == .prime,
                    action: { selectedTab = .prime }
                )

                PillSelectorItem(
                    label: "Guides",
                    isSelected: selectedTab == .guides,
                    action: { selectedTab = .guides }
                )

                PillSelectorItem(
                    label: "Search",
                    isSelected: selectedTab == .search,
                    action: { selectedTab = .search }
                )
            }
            .frame(height: 50)
            .background(
                ZStack {
                    DesignColors.secondaryBackground.opacity(0.6)
                    BlurView(style: .systemThickMaterialDark)
                }
            )
            .cornerRadius(25)
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
    }
}

struct PillSelectorItem: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(DesignTypography.bodySmall)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : DesignColors.tertiary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    isSelected ?
                    AnyView(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                DesignColors.accent,
                                Color(red: 0.3, green: 0.8, blue: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(20)
                    ) :
                    AnyView(Color.clear)
                )
        }
    }
}

#Preview {
    PillSelector(selectedTab: .constant(.featured))
        .background(DesignColors.background)
}
