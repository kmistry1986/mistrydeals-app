import SwiftUI
import Combine
import UIKit

struct SearchView: View {
    @ObservedObject var client: SupabaseClient
    @Binding var isSearchActive: Bool
    var searchAnimation: Namespace.ID
    @State private var searchText = ""
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var hasSearched = false
    @State private var selectedFilter: SearchFilter = .all
    @FocusState private var isSearchFocused: Bool
    @State private var showSearchOverlay = false
    @Namespace private var filterAnimation

    enum SearchFilter {
        case all
        case featured
        case prime
    }

    private var filterOffset: CGFloat {
        let availableWidth = UIScreen.main.bounds.width - DesignSpacing.lg * 2
        let itemWidth = availableWidth / 3
        switch selectedFilter {
        case .all: return 0
        case .featured: return itemWidth
        case .prime: return itemWidth * 2
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Search")
                    .font(DesignTypography.headline1)
                    .foregroundColor(DesignColors.primary)

                HStack {
                    Spacer()
                    Button(action: {
                        isSearchFocused = false
                        isSearchActive = false
                        searchText = ""
                    }) {
                        Text("Close")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.top, DesignSpacing.lg)
            .padding(.bottom, DesignSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(DesignColors.secondaryBackground)
            .borderBottom(DesignColors.divider)
            .padding(.top, 48)

            // Filter pills - pill container like navigation bar
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("AccentColor"),
                                Color("AccentColor").opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .matchedGeometryEffect(id: "filterBackground", in: filterAnimation)
                    .frame(maxWidth: (UIScreen.main.bounds.width - DesignSpacing.lg * 2) / 3)
                    .offset(x: filterOffset)

                HStack(spacing: 0) {
                    Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selectedFilter = .all; applyFilter() } }) {
                        Text("All")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedFilter == .all ? .semibold : .regular)
                            .foregroundColor(selectedFilter == .all ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }

                    Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selectedFilter = .featured; applyFilter() } }) {
                        Text("Featured")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedFilter == .featured ? .semibold : .regular)
                            .foregroundColor(selectedFilter == .featured ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }

                    Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selectedFilter = .prime; applyFilter() } }) {
                        Text("Prime")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(selectedFilter == .prime ? .semibold : .regular)
                            .foregroundColor(selectedFilter == .prime ? .white : DesignColors.tertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                }
            }
            .frame(height: 40)
            .background(DesignColors.background.opacity(0.1))
            .background(BlurView(style: .systemThinMaterialDark))
            .clipShape(Capsule())
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.top, DesignSpacing.lg)
            .padding(.bottom, DesignSpacing.md)

            if isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(Color("AccentColor"))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = errorMessage {
                VStack {
                    Spacer()
                    Text("Error: \(error)")
                        .foregroundColor(Color("AccentColor"))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !hasSearched {
                VStack {
                    Spacer()
                    Text("Enter a search term")
                        .foregroundColor(DesignColors.tertiary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filteredProducts.isEmpty {
                VStack {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(DesignColors.tertiary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredProducts) { product in
                            ProductRow(product: product)
                                .borderBottom(DesignColors.divider)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(DesignColors.secondaryBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            // Search bar that floats above keyboard - always visible
            if showSearchOverlay {
                VStack(spacing: 0) {
                    Spacer()

                    HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color("AccentColor"),
                                            Color("AccentColor").opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )

                    VStack(spacing: 0) {
                        HStack {
                            TextField("Search products...", text: $searchText)
                                .textFieldStyle(.plain)
                                .foregroundColor(DesignColors.primary)
                                .submitLabel(.search)
                                .focused($isSearchFocused)
                                .onSubmit {
                                    Task {
                                        await performSearch()
                                    }
                                }

                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(DesignColors.tertiary)
                                }
                            }
                        }
                        .padding(DesignSpacing.sm)
                        .background(
                            Capsule()
                                .fill(DesignColors.tertiaryBackground)
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, DesignSpacing.md)
                .padding(.bottom, 10)
                .background(DesignColors.secondaryBackground)
                .frame(maxWidth: .infinity, alignment: .leading)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear {
            showSearchOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
        .onDisappear {
            isSearchFocused = false
        }
        .onChange(of: isLoading) { newValue in
            if !newValue && hasSearched {
                isSearchFocused = false
            }
        }
    }

    private func performSearch() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        do {
            isLoading = true
            errorMessage = nil
            hasSearched = true
            products = try await client.searchProducts(query: searchText)
            applyFilter()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func applyFilter() {
        switch selectedFilter {
        case .all:
            filteredProducts = products
        case .featured:
            filteredProducts = products.filter { $0.is_featured ?? false }
        case .prime:
            filteredProducts = products.filter { $0.is_prime_bonus ?? false }
        }
    }
}


struct FilterPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(DesignTypography.caption1)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : DesignColors.tertiary)
                .padding(.horizontal, DesignSpacing.md)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    AnyView(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("AccentColor"),
                                Color("AccentColor").opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(12)
                    ) :
                    AnyView(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignColors.divider, lineWidth: 1)
                    )
                )
        }
    }
}

#Preview {
    @Namespace var ns
    return SearchView(client: SupabaseClient(), isSearchActive: .constant(true), searchAnimation: ns)
}
