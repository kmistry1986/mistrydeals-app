import SwiftUI

struct SearchView: View {
    @ObservedObject var client: SupabaseClient
    @State private var searchText = ""
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var hasSearched = false

    var body: some View {
        VStack(spacing: 0) {
                ZStack {
                    Text("Search Deals")
                        .font(DesignTypography.headline1)
                        .foregroundColor(DesignColors.primary)
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.lg)
                .frame(maxWidth: .infinity)
                .background(DesignColors.secondaryBackground)
                .borderBottom(DesignColors.divider)
                .padding(.top, 35)

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
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.vertical, DesignSpacing.md)

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
                } else if products.isEmpty {
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
                            ForEach(products) { product in
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
        .background(DesignColors.background)
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
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

#Preview {
    SearchView(client: SupabaseClient())
}
