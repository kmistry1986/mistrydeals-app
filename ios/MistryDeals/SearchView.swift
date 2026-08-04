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
    @Namespace private var filterAnimation
    @AppStorage("isDarkModeOverride") private var isDarkModeOverride = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var keyboardObservers: [NSObjectProtocol] = []

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
        ZStack {
            DesignColors.surfaceBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Search")
                        .font(DesignTypography.headline1)
                        .foregroundColor(DesignColors.textPrimary)

                    Spacer()

                    Button(action: {
                        isSearchFocused = false
                        isSearchActive = false
                        searchText = ""
                    }) {
                        Text("Close")
                            .font(DesignTypography.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignColors.actionClose)
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.lg)
                .frame(maxWidth: .infinity)
                .background(DesignColors.surfaceBackground)
                .borderBottom(DesignColors.ruleStrong, width: 2)
                .padding(.top, 48)

                // Filter pills
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(DesignColors.filterActiveBackground)
                        .matchedGeometryEffect(id: "filterBackground", in: filterAnimation)
                        .frame(maxWidth: (UIScreen.main.bounds.width - DesignSpacing.lg * 2) / 3)
                        .offset(x: filterOffset)
                        .padding(2)

                    HStack(spacing: 0) {
                        Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selectedFilter = .all; applyFilter() } }) {
                            Text("All")
                                .font(DesignTypography.bodySmall)
                                .fontWeight(selectedFilter == .all ? .semibold : .regular)
                                .foregroundColor(selectedFilter == .all ? DesignColors.filterActiveLabel : DesignColors.tabBarLabel)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }

                        Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selectedFilter = .featured; applyFilter() } }) {
                            Text("Featured")
                                .font(DesignTypography.bodySmall)
                                .fontWeight(selectedFilter == .featured ? .semibold : .regular)
                                .foregroundColor(selectedFilter == .featured ? DesignColors.filterActiveLabel : DesignColors.tabBarLabel)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }

                        Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selectedFilter = .prime; applyFilter() } }) {
                            Text("Prime")
                                .font(DesignTypography.bodySmall)
                                .fontWeight(selectedFilter == .prime ? .semibold : .regular)
                                .foregroundColor(selectedFilter == .prime ? DesignColors.filterActiveLabel : DesignColors.tabBarLabel)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .frame(height: 40)
                .background(DesignColors.filterInactiveBackground)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(DesignColors.ruleStrong, lineWidth: 1))
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.md)

                // Content
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(DesignColors.tabBarActiveFill)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = errorMessage {
                    VStack {
                        Spacer()
                        Text("Error: \(error)")
                            .foregroundColor(DesignColors.priceValue)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !hasSearched {
                    VStack {
                        Spacer()
                        Text("Enter a search term")
                            .foregroundColor(DesignColors.textSecondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredProducts.isEmpty {
                    VStack {
                        Spacer()
                        Text("No results found")
                            .foregroundColor(DesignColors.textSecondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredProducts) { product in
                                ProductRow(product: product)
                                    .borderBottom(DesignColors.ruleHairline)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Spacer()
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            // Search input bar - floats above keyboard
            VStack(spacing: 0) {
                HStack(spacing: DesignSpacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignColors.iconDefault)

                    TextField("Search products...", text: $searchText)
                        .textFieldStyle(.plain)
                        .foregroundColor(DesignColors.textPrimary)
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
                                .foregroundColor(DesignColors.iconDefault)
                        }
                    }
                }
                .padding(DesignSpacing.md)
                .background(DesignColors.inputBackground)
                .cornerRadius(DesignRadius.sm)
                .overlay(RoundedRectangle(cornerRadius: DesignRadius.sm).stroke(DesignColors.inputBorder, lineWidth: 1))
                .padding(DesignSpacing.md)
                .background(DesignColors.surfaceBackground)
            }
            .offset(y: -keyboardHeight)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
                UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
            }

            let showObserver = NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }

            let hideObserver = NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { _ in
                withAnimation {
                    keyboardHeight = 0
                }
            }

            keyboardObservers = [showObserver, hideObserver]
        }
        .onDisappear {
            isSearchFocused = false
            keyboardObservers.forEach { NotificationCenter.default.removeObserver($0) }
            keyboardObservers.removeAll()
        }
    }

    private func performSearch() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        do {
            isLoading = true
            errorMessage = nil
            hasSearched = true
            products = try await client.fetchProducts(type: "")
            applyFilter()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func applyFilter() {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        var filtered = products

        if !query.isEmpty {
            filtered = filtered.filter { product in
                product.title.lowercased().contains(query)
            }
        }

        switch selectedFilter {
        case .all:
            filteredProducts = filtered
        case .featured:
            filteredProducts = filtered.filter { $0.is_featured ?? false }
        case .prime:
            filteredProducts = filtered.filter { $0.is_prime_bonus ?? false }
        }
    }
}

#Preview {
    SearchView(client: SupabaseClient(), isSearchActive: .constant(true), searchAnimation: Namespace().wrappedValue)
}
