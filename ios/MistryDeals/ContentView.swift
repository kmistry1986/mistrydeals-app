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
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 0) {
                    Button(action: { selectedTab = .featured }) {
                        Text("Featured")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedTab == .featured ? .semibold : .regular)
                            .foregroundColor(selectedTab == .featured ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedTab == .featured ?
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

                    Button(action: { selectedTab = .prime }) {
                        Text("Prime")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedTab == .prime ? .semibold : .regular)
                            .foregroundColor(selectedTab == .prime ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedTab == .prime ?
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

                    Button(action: { selectedTab = .guides }) {
                        Text("Guides")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedTab == .guides ? .semibold : .regular)
                            .foregroundColor(selectedTab == .guides ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedTab == .guides ?
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

                    Button(action: { selectedTab = .search }) {
                        Text("Search")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedTab == .search ? .semibold : .regular)
                            .foregroundColor(selectedTab == .search ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedTab == .search ?
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
                .frame(height: 50)
                .background(
                    ZStack {
                        Color.white.opacity(0.1)
                        BlurView(style: .systemThinMaterialDark)
                    }
                )
                .cornerRadius(25)
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
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
