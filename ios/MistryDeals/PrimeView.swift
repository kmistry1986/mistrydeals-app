import SwiftUI

struct PrimeView: View {
    @ObservedObject var client: SupabaseClient
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSearchModal = false
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Prime Deals")
                    .font(DesignTypography.headline1)
                    .foregroundColor(DesignColors.primary)

                HStack {
                    Spacer()
                    Button(action: { showSearchModal = true }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DesignColors.accent)
                    }
                    .padding(.horizontal, DesignSpacing.lg)
                }
            }
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.top, DesignSpacing.lg)
            .padding(.bottom, DesignSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(DesignColors.secondaryBackground)
            .borderBottom(DesignColors.divider)
            .padding(.top, 35)

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
            } else {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: []) {
                        ForEach(filteredProducts) { product in
                            ProductRow(product: product)
                                .borderBottom(DesignColors.divider)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 66)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignColors.background)
        .ignoresSafeArea()
        .sheet(isPresented: $showSearchModal) {
            PrimeSearchModalView(
                isPresented: $showSearchModal,
                searchText: $searchText,
                onSearch: performSearch
            )
        }
        .task {
            await loadProducts()
        }
    }

    private func loadProducts() async {
        do {
            isLoading = true
            errorMessage = nil
            products = try await client.fetchProducts(type: "prime")
            filteredProducts = products
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func performSearch() {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        if query.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                product.title.lowercased().contains(query)
            }
        }
    }
}

struct PrimeSearchModalView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    let onSearch: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Search Prime Deals")
                        .font(DesignTypography.headline2)
                        .foregroundColor(DesignColors.primary)
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DesignColors.primary)
                    }
                }
                .padding(DesignSpacing.lg)
                .background(DesignColors.secondaryBackground)

                VStack(spacing: DesignSpacing.lg) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(DesignColors.tertiary)

                        TextField("Search deals...", text: $searchText)
                            .textFieldStyle(.plain)
                            .foregroundColor(DesignColors.primary)
                            .submitLabel(.search)
                            .onSubmit {
                                onSearch()
                                isPresented = false
                            }

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(DesignColors.tertiary)
                            }
                        }
                    }
                    .padding(DesignSpacing.md)
                    .background(DesignColors.tertiaryBackground)
                    .cornerRadius(DesignRadius.md)

                    Button(action: {
                        onSearch()
                        isPresented = false
                    }) {
                        Text("Search")
                            .font(DesignTypography.headline3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(DesignSpacing.md)
                            .background(DesignColors.accent)
                            .cornerRadius(DesignRadius.md)
                    }

                    Spacer()
                }
                .padding(DesignSpacing.lg)
                .background(DesignColors.background)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .glassEffect()
            .cornerRadius(DesignRadius.lg)
            .padding(DesignSpacing.lg)
        }
    }
}

#Preview {
    PrimeView(client: SupabaseClient())
}
