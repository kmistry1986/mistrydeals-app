import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabSelection = .featured
    @State private var isSearchActive = false
    @State private var previousTabIndex = 0
    @State private var currentTransitionEdges: (incoming: Edge, outgoing: Edge) = (.trailing, .leading)
    @StateObject private var supabaseClient = SupabaseClient()
    @Namespace private var searchAnimation
    @Namespace private var pillAnimation

    private var tabIndex: Int {
        switch selectedTab {
        case .featured: return 0
        case .prime: return 1
        case .guides: return 2
        case .search: return 0
        }
    }

    private func getTransitionEdges(from: Int, to: Int) -> (incoming: Edge, outgoing: Edge) {
        switch (from, to) {
        case (0, 1): return (.trailing, .leading)
        case (0, 2): return (.trailing, .leading)
        case (1, 0): return (.leading, .trailing)
        case (1, 2): return (.trailing, .leading)
        case (2, 1): return (.leading, .trailing)
        case (2, 0): return (.leading, .trailing)
        default: return (.trailing, .leading)
        }
    }

    private var tabOffset: CGFloat {
        // HStack padding is 8 on each side = 16 total
        // Search button is 38 width + 12 spacing = 50
        // Spacer takes remaining, so pill gets: (screen - 16) - 50
        let screenWidth = UIScreen.main.bounds.width
        let pillWidth = (screenWidth - 16) - 50
        let itemWidth = pillWidth / 3
        switch tabIndex {
        case 0: return 0
        case 1: return itemWidth
        case 2: return itemWidth * 2
        default: return 0
        }
    }

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

            ZStack {
                DesignColors.background
                    .ignoresSafeArea()

                if isSearchActive {
                    SearchView(client: supabaseClient, isSearchActive: $isSearchActive, searchAnimation: searchAnimation)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25), value: isSearchActive)
                } else {
                    switch selectedTab {
                    case .featured:
                        FeaturedView(client: supabaseClient)
                            .transition(.asymmetric(insertion: .move(edge: currentTransitionEdges.incoming), removal: .move(edge: currentTransitionEdges.outgoing)))
                            .animation(.easeInOut(duration: 0.15), value: selectedTab)
                            .id("featured")
                    case .prime:
                        PrimeView(client: supabaseClient)
                            .transition(.asymmetric(insertion: .move(edge: currentTransitionEdges.incoming), removal: .move(edge: currentTransitionEdges.outgoing)))
                            .animation(.easeInOut(duration: 0.15), value: selectedTab)
                            .id("prime")
                    case .guides:
                        GuidesView(client: supabaseClient)
                            .transition(.asymmetric(insertion: .move(edge: currentTransitionEdges.incoming), removal: .move(edge: currentTransitionEdges.outgoing)))
                            .animation(.easeInOut(duration: 0.15), value: selectedTab)
                            .id("guides")
                    case .search:
                        FeaturedView(client: supabaseClient)
                            .transition(.asymmetric(insertion: .move(edge: currentTransitionEdges.incoming), removal: .move(edge: currentTransitionEdges.outgoing)))
                            .animation(.easeInOut(duration: 0.15), value: selectedTab)
                            .id("search")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                if !isSearchActive {
                    HStack(spacing: 12) {
                        // Navigation pill (narrower, left-aligned, 3 tabs only)
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                let itemWidth = geometry.size.width / 3
                                let offset = CGFloat(tabIndex) * itemWidth

                                Capsule()
                                    .fill(DesignColors.tabBarActiveFill)
                                    .matchedGeometryEffect(id: "selectedTabBackground", in: pillAnimation)
                                    .frame(maxWidth: itemWidth)
                                    .offset(x: offset)

                                HStack(spacing: 0) {
                                    Button(action: {
                                        currentTransitionEdges = getTransitionEdges(from: tabIndex, to: 0)
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            previousTabIndex = tabIndex
                                            selectedTab = .featured
                                        }
                                    }) {
                                        Text("Featured")
                                            .font(DesignTypography.bodySmall)
                                            .fontWeight(selectedTab == .featured ? .semibold : .regular)
                                            .foregroundColor(selectedTab == .featured ? DesignColors.tabBarActiveLabel : DesignColors.tabBarLabel)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                    }

                                    Button(action: {
                                        currentTransitionEdges = getTransitionEdges(from: tabIndex, to: 1)
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            previousTabIndex = tabIndex
                                            selectedTab = .prime
                                        }
                                    }) {
                                        Text("Prime")
                                            .font(DesignTypography.bodySmall)
                                            .fontWeight(selectedTab == .prime ? .semibold : .regular)
                                            .foregroundColor(selectedTab == .prime ? DesignColors.tabBarActiveLabel : DesignColors.tabBarLabel)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                    }

                                    Button(action: {
                                        currentTransitionEdges = getTransitionEdges(from: tabIndex, to: 2)
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            previousTabIndex = tabIndex
                                            selectedTab = .guides
                                        }
                                    }) {
                                        Text("Guides")
                                            .font(DesignTypography.bodySmall)
                                            .fontWeight(selectedTab == .guides ? .semibold : .regular)
                                            .foregroundColor(selectedTab == .guides ? DesignColors.tabBarActiveLabel : DesignColors.tabBarLabel)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                    }
                                }
                            }
                        }
                        .frame(height: 40)
                        .background(DesignColors.tabBarBackground)
                        .clipShape(Capsule())

                        // Floating search button
                        if !isSearchActive {
                            Button(action: { withAnimation(.easeInOut(duration: 0.4)) { isSearchActive = true } }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DesignColors.tabBarActiveLabel)
                                    .frame(width: 38, height: 38)
                                    .background(
                                        Circle()
                                            .fill(DesignColors.tabBarActiveFill)
                                    )
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 22)
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
                    .foregroundColor(isSelected ? Color("AccentColor") : DesignColors.tertiary)

                Text(label)
                    .font(DesignTypography.caption2)
                    .foregroundColor(isSelected ? Color("AccentColor") : DesignColors.tertiary)
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
