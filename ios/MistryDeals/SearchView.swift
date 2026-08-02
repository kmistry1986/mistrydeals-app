import SwiftUI

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

    enum SearchFilter {
        case all
        case featured
        case prime
    }

    var body: some View {
        VStack(spacing: 0) {
                HStack {
                    Text("Search Deals")
                        .font(DesignTypography.headline1)
                        .foregroundColor(DesignColors.primary)

                    Spacer()

                    Button(action: { isSearchActive = false; searchText = "" }) {
                        Text("Close")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignColors.accent)
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.lg)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .borderBottom(DesignColors.divider)
                .padding(.top, 48)

                VStack(spacing: DesignSpacing.md) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(DesignColors.tertiary)

                        TextField("Search products...", text: $searchText)
                            .textFieldStyle(.plain)
                            .foregroundColor(DesignColors.primary)
                            .submitLabel(.search)
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
                    .background(DesignColors.tertiaryBackground)
                    .cornerRadius(DesignRadius.sm)
                    .matchedGeometryEffect(id: "searchButton", in: searchAnimation)
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.vertical, DesignSpacing.md)

                // Filter pills
                HStack(spacing: DesignSpacing.md) {
                    FilterPill(
                        label: "All",
                        isSelected: selectedFilter == .all,
                        action: {
                            selectedFilter = .all
                            applyFilter()
                        }
                    )

                    FilterPill(
                        label: "Featured",
                        isSelected: selectedFilter == .featured,
                        action: {
                            selectedFilter = .featured
                            applyFilter()
                        }
                    )

                    FilterPill(
                        label: "Prime",
                        isSelected: selectedFilter == .prime,
                        action: {
                            selectedFilter = .prime
                            applyFilter()
                        }
                    )

                    Spacer()
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.md)

                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(DesignColors.accent)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = errorMessage {
                    VStack {
                        Spacer()
                        Text("Error: \(error)")
                            .foregroundColor(DesignColors.accentSecondary)
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
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 66)
                }
        }
        .background(Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
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
            filteredProducts = products.filter { $0.is_featured == true }
        case .prime:
            filteredProducts = products.filter { $0.is_prime == true }
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
                                DesignColors.accent,
                                Color(red: 0.3, green: 0.8, blue: 1.0)
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
