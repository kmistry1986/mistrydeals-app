import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabSelection = .featured
    @StateObject private var supabaseClient = SupabaseClient()

    var body: some View {
        ZStack {
            // Modern iOS 27 gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    DesignColors.background,
                    DesignColors.secondaryBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .featured:
                        FeaturedView(client: supabaseClient)
                    case .prime:
                        PrimeView(client: supabaseClient)
                    case .guides:
                        GuidesView(client: supabaseClient)
                    case .search:
                        SearchView(client: supabaseClient)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                TabBar(selectedTab: $selectedTab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: [.top, .bottom])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct TabBar: View {
    @Binding var selectedTab: TabSelection

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TabBarItem(
                    icon: "tag",
                    label: "Featured",
                    isSelected: selectedTab == .featured,
                    action: { selectedTab = .featured }
                )

                TabBarItem(
                    icon: "creditcard",
                    label: "Prime",
                    isSelected: selectedTab == .prime,
                    action: { selectedTab = .prime }
                )

                TabBarItem(
                    icon: "book",
                    label: "Guides",
                    isSelected: selectedTab == .guides,
                    action: { selectedTab = .guides }
                )

                TabBarItem(
                    icon: "magnifyingglass",
                    label: "Search",
                    isSelected: selectedTab == .search,
                    action: { selectedTab = .search }
                )
            }
            .frame(height: 64)
            .background(
                ZStack {
                    DesignColors.secondaryBackground.opacity(0.6)
                    BlurView(style: .systemThickMaterialDark)
                }
            )
            .padding(.bottom, 0)
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isSelected ? DesignColors.accent : DesignColors.tertiary)

                Text(label)
                    .font(DesignTypography.caption2)
                    .foregroundColor(isSelected ? DesignColors.accent : DesignColors.tertiary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ContentView()
}
