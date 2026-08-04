import SwiftUI

@available(iOS 16.0, *)
struct PrimeView: View {
    @ObservedObject var client: SupabaseClient
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSearchModal = false
    @State private var searchText = ""
    @State private var showSearchBox = false
    @State private var showSettings = false
    @AppStorage("isDarkModeOverride") private var isDarkModeOverride = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Prime Deals")
                        .font(DesignTypography.headline1)
                        .foregroundColor(DesignColors.textPrimary)

                    Spacer()

                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DesignColors.iconDefault)
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.lg)
                .frame(maxWidth: .infinity)
                .background(DesignColors.surfaceBackground)
                .borderBottom(DesignColors.ruleStrong, width: 2)
                .padding(.top, 48)

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
                        VStack(spacing: 0) {
                            if showSearchBox {
                                VStack(spacing: 8) {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(DesignColors.tertiary)

                                        TextField("Search products...", text: $searchText)
                                            .textFieldStyle(.plain)
                                            .foregroundColor(DesignColors.primary)
                                            .submitLabel(.search)
                                            .onSubmit {
                                                performSearch()
                                            }
                                    }
                                    .padding(DesignSpacing.sm)
                                    .background(DesignColors.tertiaryBackground)
                                    .cornerRadius(DesignRadius.sm)

                                    HStack(spacing: 8) {
                                        Button(action: {
                                            searchText = ""
                                            performSearch()
                                        }) {
                                            Text("Clear")
                                                .font(DesignTypography.caption1)
                                                .foregroundColor(DesignColors.primary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(DesignColors.tertiaryBackground)
                                                .cornerRadius(DesignRadius.sm)
                                        }

                                        Button(action: {
                                            showSearchBox = false
                                            searchText = ""
                                            performSearch()
                                        }) {
                                            Text("Close")
                                                .font(DesignTypography.caption1)
                                                .foregroundColor(DesignColors.primary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(DesignColors.accentSecondary)
                                                .cornerRadius(DesignRadius.sm)
                                        }
                                    }
                                }
                                .padding(DesignSpacing.lg)
                            }

                            LazyVStack(spacing: 0, pinnedViews: []) {
                                ForEach(filteredProducts) { product in
                                    ProductRow(product: product)
                                        .borderBottom(DesignColors.ruleHairline)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 0)
                        }
                    }
                    .refreshable {
                        await loadProducts()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 66)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignColors.surfaceBackground)
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
    }

    private func loadProducts() async {
        do {
            isLoading = true
            errorMessage = nil
            products = try await client.fetchProducts(type: "prime")
            products.sort { ($0.last_price_sync ?? "") > ($1.last_price_sync ?? "") }
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

@available(iOS 16.0, *)
struct PrimeSearchModalView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    let onSearch: () -> Void

    var body: some View {
        ZStack {
            DesignColors.background.opacity(0.6)
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
                .background(DesignColors.surfaceBackground)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .glassEffect()
            .cornerRadius(DesignRadius.lg)
            .padding(DesignSpacing.lg)
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    PrimeView(client: SupabaseClient())
}
