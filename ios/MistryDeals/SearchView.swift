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
    @State private var keyboardHeight: CGFloat = 0

    enum SearchFilter {
        case all
        case featured
        case prime
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Search")
                    .font(DesignTypography.headline1)
                    .foregroundColor(DesignColors.primary)
                Spacer()

                Button(action: {
                    isSearchFocused = false
                    isSearchActive = false
                    searchText = ""
                }) {
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

            // Filter pills - pill container like navigation bar
            HStack(spacing: 0) {
                Button(action: { withAnimation(.easeInOut(duration: 0.3)) { selectedFilter = .all; applyFilter() } }) {
                    Text("All")
                        .font(DesignTypography.bodySmall)
                        .fontWeight(selectedFilter == .all ? .semibold : .regular)
                        .foregroundColor(selectedFilter == .all ? .white : DesignColors.tertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedFilter == .all ?
                            AnyView(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                DesignColors.accent,
                                                Color(red: 0.3, green: 0.8, blue: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            ) :
                            AnyView(Color.clear)
                        )
                }

                Button(action: { withAnimation(.easeInOut(duration: 0.3)) { selectedFilter = .featured; applyFilter() } }) {
                    Text("Featured")
                        .font(DesignTypography.bodySmall)
                        .fontWeight(selectedFilter == .featured ? .semibold : .regular)
                        .foregroundColor(selectedFilter == .featured ? .white : DesignColors.tertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedFilter == .featured ?
                            AnyView(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                DesignColors.accent,
                                                Color(red: 0.3, green: 0.8, blue: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            ) :
                            AnyView(Color.clear)
                        )
                }

                Button(action: { withAnimation(.easeInOut(duration: 0.3)) { selectedFilter = .prime; applyFilter() } }) {
                    Text("Prime")
                        .font(DesignTypography.bodySmall)
                        .fontWeight(selectedFilter == .prime ? .semibold : .regular)
                        .foregroundColor(selectedFilter == .prime ? .white : DesignColors.tertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedFilter == .prime ?
                            AnyView(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                DesignColors.accent,
                                                Color(red: 0.3, green: 0.8, blue: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            ) :
                            AnyView(Color.clear)
                        )
                }
            }
            .frame(height: 40)
            .background(Color.white.opacity(0.1))
            .background(BlurView(style: .systemThinMaterialDark))
            .clipShape(Capsule())
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.top, DesignSpacing.lg)
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
            }
        }
        .background(Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            // Search bar that floats above keyboard - always visible
            VStack(spacing: DesignSpacing.md) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignColors.tertiary)

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
                .matchedGeometryEffect(id: "searchButton", in: searchAnimation)
            }
            .padding(.horizontal, 0)
            .padding(.vertical, DesignSpacing.md)
            .padding(.bottom, keyboardHeight + 10)
            .background(Color.black)
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            isSearchFocused = true
        }
        .onReceive(Publishers.keyboardHeight) { height in
            keyboardHeight = height
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

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return Publishers.Merge(willShow, willHide)
            .debounce(for: .milliseconds(10), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
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
