import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabSelection = .featured
    @State private var isSearchActive = false
    @StateObject private var supabaseClient = SupabaseClient()
    @Namespace private var searchAnimation
    @Namespace private var pillAnimation

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
                if isSearchActive {
                    SearchView(client: supabaseClient, isSearchActive: $isSearchActive, searchAnimation: searchAnimation)
                        .transition(.opacity)
                } else {
                    switch selectedTab {
                    case .featured:
                        FeaturedView(client: supabaseClient)
                    case .prime:
                        PrimeView(client: supabaseClient)
                    case .guides:
                        GuidesView(client: supabaseClient)
                    case .search:
                        FeaturedView(client: supabaseClient)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: isSearchActive)
            .safeAreaInset(edge: .bottom) {
                if !isSearchActive {
                    HStack(spacing: 12) {
                        // Navigation pill (narrower, left-aligned, 3 tabs only)
                        HStack(spacing: 0) {
                            Button(action: { withAnimation(.easeInOut(duration: 0.3)) { selectedTab = .featured } }) {
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
                                            .cornerRadius(12)
                                            .matchedGeometryEffect(id: "selectedTabBackground", in: pillAnimation)
                                        ) :
                                        AnyView(Color.clear)
                                    )
                            }

                            Button(action: { withAnimation(.easeInOut(duration: 0.3)) { selectedTab = .prime } }) {
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
                                            .cornerRadius(12)
                                            .matchedGeometryEffect(id: "selectedTabBackground", in: pillAnimation)
                                        ) :
                                        AnyView(Color.clear)
                                    )
                            }

                            Button(action: { withAnimation(.easeInOut(duration: 0.3)) { selectedTab = .guides } }) {
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
                                            .cornerRadius(12)
                                            .matchedGeometryEffect(id: "selectedTabBackground", in: pillAnimation)
                                        ) :
                                        AnyView(Color.clear)
                                    )
                            }
                        }
                        .frame(height: 40)
                        .background(
                            ZStack {
                                Color.white.opacity(0.1)
                                BlurView(style: .systemThinMaterialDark)
                            }
                        )
                        .cornerRadius(20)

                        // Floating search button
                        if !isSearchActive {
                            Button(action: { isSearchActive = true }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                DesignColors.accent,
                                                Color(red: 0.3, green: 0.8, blue: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .matchedGeometryEffect(id: "searchButton", in: searchAnimation)
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                }
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
