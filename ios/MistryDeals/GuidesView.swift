import SwiftUI

struct GuidesView: View {
    @ObservedObject var client: SupabaseClient
    @State private var guides: [Guide] = []
    @State private var filteredGuides: [Guide] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSearchModal = false
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
                ZStack {
                    Text("Buying Guides")
                        .font(DesignTypography.headline1)
                        .foregroundColor(DesignColors.primary)

                    HStack {
                        Spacer()
                        Button(action: { showSearchModal = true }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(DesignColors.accent)
                        }
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
                        LazyVStack(spacing: DesignSpacing.md) {
                            ForEach(filteredGuides) { guide in
                                NavigationLink(destination: GuideDetailView(guide: guide)) {
                                    GuideCard(guide: guide)
                                }
                            }
                        }
                        .padding(DesignSpacing.lg)
                        .padding(.top, DesignSpacing.md)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 66)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignColors.background)
            .ignoresSafeArea()
            .sheet(isPresented: $showSearchModal) {
                GuideSearchModalView(
                    isPresented: $showSearchModal,
                    searchText: $searchText,
                    onSearch: performSearch
                )
            }
            .task {
                await loadGuides()
            }
    }

    private func loadGuides() async {
        do {
            isLoading = true
            errorMessage = nil
            guides = try await client.fetchGuides()
            filteredGuides = guides
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func performSearch() {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        if query.isEmpty {
            filteredGuides = guides
        } else {
            filteredGuides = guides.filter { guide in
                guide.title.lowercased().contains(query) ||
                (guide.description?.lowercased().contains(query) ?? false)
            }
        }
    }
}

struct GuideCard: View {
    let guide: Guide

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.md) {
            if let imageUrl = guide.image_url, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        DesignColors.tertiaryBackground
                            .frame(height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                    case .failure:
                        DesignColors.tertiaryBackground
                            .frame(height: 150)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(DesignRadius.md)
            }

            Text(guide.title)
                .font(DesignTypography.headline2)
                .foregroundColor(DesignColors.primary)

            if let description = guide.description {
                Text(description)
                    .font(DesignTypography.bodySmall)
                    .foregroundColor(DesignColors.secondary)
                    .lineLimit(2)
            }
        }
        .padding(DesignSpacing.md)
        .glassEffect()
        .cornerRadius(DesignRadius.lg)
    }
}

struct GuideSearchModalView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    let onSearch: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Search Guides")
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

                        TextField("Search guides...", text: $searchText)
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
    GuidesView(client: SupabaseClient())
}
