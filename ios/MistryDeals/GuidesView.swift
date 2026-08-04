import SwiftUI
import WebKit

struct GuidesView: View {
    @ObservedObject var client: SupabaseClient
    @State private var guides: [Guide] = []
    @State private var filteredGuides: [Guide] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSearchModal = false
    @State private var searchText = ""
    @State private var showSearchBox = false
    @State private var navigationPath: [Guide] = []
    @State private var showSettings = false
    @AppStorage("isDarkModeOverride") private var isDarkModeOverride = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                HStack {
                    Text("Buying Guides")
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
                            .foregroundColor(DesignColors.tabBarActiveFill)
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
                                            .foregroundColor(DesignColors.iconDefault)

                                        TextField("Search guides...", text: $searchText)
                                            .textFieldStyle(.plain)
                                            .foregroundColor(DesignColors.textPrimary)
                                            .submitLabel(.search)
                                            .onSubmit {
                                                performSearch()
                                            }
                                    }
                                    .padding(DesignSpacing.sm)
                                    .background(DesignColors.surfaceThumb)
                                    .cornerRadius(DesignRadius.sm)

                                    HStack(spacing: 8) {
                                        Button(action: {
                                            searchText = ""
                                            performSearch()
                                        }) {
                                            Text("Clear")
                                                .font(DesignTypography.caption1)
                                                .foregroundColor(DesignColors.textPrimary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(DesignColors.surfaceThumb)
                                                .cornerRadius(DesignRadius.sm)
                                        }

                                        Button(action: {
                                            showSearchBox = false
                                            searchText = ""
                                            performSearch()
                                        }) {
                                            Text("Close")
                                                .font(DesignTypography.caption1)
                                                .foregroundColor(DesignColors.textPrimary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(DesignColors.tabBarActiveFill)
                                                .cornerRadius(DesignRadius.sm)
                                        }
                                    }
                                }
                                .padding(DesignSpacing.lg)
                            }

                            LazyVStack(spacing: DesignSpacing.md) {
                                ForEach(filteredGuides) { guide in
                                    GuideCardWrapper(guide: guide)
                                }
                            }
                            .padding(DesignSpacing.lg)
                            .padding(.top, DesignSpacing.md)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 66)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignColors.surfaceBackground)
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

struct GuideCardWrapper: View {
    let guide: Guide

    var body: some View {
        NavigationLink(destination: GuideDetailScreenView(guide: guide)) {
            GuideCard(guide: guide)
        }
    }
}

struct GuideDetailScreenView: View {
    @Environment(\.dismiss) var dismiss
    let guide: Guide

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Guide")
                    }
                    .font(DesignTypography.headline2)
                    .foregroundColor(DesignColors.textPrimary)
                }
                Spacer()
            }
            .padding(.horizontal, DesignSpacing.lg)
            .frame(height: 56)
            .background(DesignColors.secondaryBackground)
            .borderBottom(DesignColors.divider)

            ScrollView {
                VStack(alignment: .leading, spacing: DesignSpacing.lg) {
                    // Guide title and subtitle
                    VStack(alignment: .center, spacing: DesignSpacing.sm) {
                        Text(guide.guideContent?.title ?? guide.title)
                            .font(DesignTypography.displaySmall)
                            .foregroundColor(DesignColors.textPrimary)
                            .multilineTextAlignment(.center)

                        if let subtitle = guide.guideContent?.subtitle {
                            Text(subtitle)
                                .font(DesignTypography.bodyMedium)
                                .foregroundColor(DesignColors.secondary)
                                .multilineTextAlignment(.center)
                        } else if let description = guide.description {
                            Text(description)
                                .font(DesignTypography.bodyMedium)
                                .foregroundColor(DesignColors.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                    }
                    .padding(.horizontal, DesignSpacing.lg)
                    .frame(maxWidth: .infinity)

                    // Intro paragraphs
                    if let intro = guide.guideContent?.intro {
                        VStack(alignment: .leading, spacing: DesignSpacing.md) {
                            ForEach(intro, id: \.self) { paragraph in
                                Text(paragraph)
                                    .font(DesignTypography.bodyMedium)
                                    .foregroundColor(DesignColors.secondary)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal, DesignSpacing.lg)
                    }

                    // Quick Answers: The Best Picks - 2-column grid with product boxes
                    if !guide.products.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSpacing.md) {
                            Text("Quick Answers: The Best Picks")
                                .font(DesignTypography.headline2)
                                .foregroundColor(DesignColors.textPrimary)
                                .padding(.horizontal, DesignSpacing.lg)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSpacing.md) {
                                ForEach(guide.products) { product in
                                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                        // Product thumbnail
                                        if let imageUrl = product.image_url, let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    DesignColors.surfaceThumb
                                                        .frame(height: 120)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(height: 120)
                                                        .clipped()
                                                case .failure:
                                                    DesignColors.surfaceThumb
                                                        .frame(height: 120)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .cornerRadius(DesignRadius.md)
                                        } else {
                                            DesignColors.surfaceThumb
                                                .frame(height: 120)
                                                .cornerRadius(DesignRadius.md)
                                        }

                                        // Product title
                                        Text(product.display_title ?? product.truncatedTitle)
                                            .font(DesignTypography.bodySmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(DesignColors.textPrimary)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)

                                        // Price and rating
                                        HStack(spacing: 8) {
                                            Text("$\(product.priceDouble, specifier: "%.2f")")
                                                .font(DesignTypography.price)
                                                .foregroundColor(Color("PriceColor"))

                                            if product.ratingDouble > 0 {
                                                HStack(spacing: 2) {
                                                    Text("★")
                                                        .font(DesignTypography.caption2)
                                                        .foregroundColor(Color("StarRatingColor"))

                                                    Text(String(format: "%.1f", product.ratingDouble))
                                                        .font(DesignTypography.caption2)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(Color("StarRatingColor"))
                                                }
                                            }

                                            Spacer()
                                        }

                                        // Original price and discount
                                        HStack(spacing: 8) {
                                            if product.originalPriceDouble > 0 {
                                                Text("$\(product.originalPriceDouble, specifier: "%.2f")")
                                                    .font(DesignTypography.caption1)
                                                    .foregroundColor(Color("OriginalPriceColor"))
                                                    .strikethrough()
                                            }

                                            if product.discountPercent > 0 {
                                                Text("\(product.discountPercent)% OFF")
                                                    .font(DesignTypography.caption2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 3)
                                                    .background(Color("DiscountBadgeColor"))
                                                    .cornerRadius(DesignRadius.sm)
                                            }

                                            Spacer()
                                        }
                                    }
                                    .padding(DesignSpacing.md)
                                    .background(DesignColors.surfaceThumb)
                                    .cornerRadius(DesignRadius.md)
                                }
                            }
                            .padding(.horizontal, DesignSpacing.lg)
                        }
                        .padding(.bottom, DesignSpacing.xl)
                    }

                    // Product Details - horizontal layout with thumbnail, title, and description
                    if !guide.products.isEmpty && guide.products.contains(where: { $0.description != nil && !($0.description?.isEmpty ?? true) }) {
                        VStack(alignment: .leading, spacing: DesignSpacing.md) {
                            Text("Product Details")
                                .font(DesignTypography.headline2)
                                .foregroundColor(DesignColors.textPrimary)
                                .padding(.horizontal, DesignSpacing.lg)

                            VStack(spacing: DesignSpacing.md) {
                                ForEach(guide.products.filter { $0.description != nil && !($0.description?.isEmpty ?? true) }) { product in
                                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                        HStack(alignment: .top, spacing: DesignSpacing.md) {
                                            // Product thumbnail
                                            if let imageUrl = product.image_url, let url = URL(string: imageUrl) {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        DesignColors.surfaceThumb
                                                            .frame(width: 80, height: 80)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 80, height: 80)
                                                            .clipped()
                                                    case .failure:
                                                        DesignColors.surfaceThumb
                                                            .frame(width: 80, height: 80)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .cornerRadius(DesignRadius.md)
                                            } else {
                                                DesignColors.surfaceThumb
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(DesignRadius.md)
                                            }

                                            // Title
                                            VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                                                Text(product.display_title ?? product.truncatedTitle)
                                                    .font(DesignTypography.bodySmall)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(DesignColors.textPrimary)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)

                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        }

                                        // Product description
                                        if let description = product.description {
                                            Text(description)
                                                .font(DesignTypography.bodySmall)
                                                .foregroundColor(DesignColors.secondary)
                                                .lineSpacing(4)
                                        }
                                    }
                                    .padding(DesignSpacing.md)
                                    .background(DesignColors.surfaceThumb)
                                    .cornerRadius(DesignRadius.md)
                                }
                            }
                            .padding(.horizontal, DesignSpacing.lg)
                        }
                    }

                    // Sections
                    if let sections = guide.guideContent?.sections {
                        VStack(alignment: .leading, spacing: DesignSpacing.lg) {
                            ForEach(sections) { section in
                                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                    Text(section.title)
                                        .font(DesignTypography.headline2)
                                        .foregroundColor(DesignColors.textPrimary)

                                    Text(section.content)
                                        .font(DesignTypography.bodyMedium)
                                        .foregroundColor(DesignColors.secondary)
                                        .lineSpacing(4)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.lg)
                    }

                    // How-to list
                    if let howto = guide.guideContent?.howto {
                        VStack(alignment: .leading, spacing: DesignSpacing.md) {
                            Text("How To")
                                .font(DesignTypography.headline2)
                                .foregroundColor(DesignColors.textPrimary)

                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                ForEach(howto, id: \.self) { item in
                                    HStack(alignment: .top, spacing: DesignSpacing.md) {
                                        Text("•")
                                            .foregroundColor(DesignColors.accent)
                                        Text(item)
                                            .font(DesignTypography.bodyMedium)
                                            .foregroundColor(DesignColors.secondary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.lg)
                    }

                    // FAQ
                    if let faq = guide.guideContent?.faq {
                        VStack(alignment: .leading, spacing: DesignSpacing.md) {
                            Text("FAQ")
                                .font(DesignTypography.headline2)
                                .foregroundColor(DesignColors.textPrimary)

                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                ForEach(faq) { item in
                                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                        Text(item.question)
                                            .font(DesignTypography.headline3)
                                            .foregroundColor(DesignColors.textPrimary)

                                        Text(item.answer)
                                            .font(DesignTypography.bodySmall)
                                            .foregroundColor(DesignColors.secondary)
                                    }
                                    .padding(DesignSpacing.md)
                                    .background(DesignColors.surfaceThumb)
                                    .cornerRadius(DesignRadius.md)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.lg)
                    }
                }
                .padding(.vertical, DesignSpacing.lg)
            }
            .background(DesignColors.surfaceBackground)
        }
        .background(DesignColors.background)
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct GuideCard: View {
    let guide: Guide
    @State private var isTapped = false

    var body: some View {
        HStack(alignment: .top, spacing: DesignSpacing.md) {
            // Left: Thumbnail image
            if let imageUrl = guide.image_url, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        DesignColors.surfaceThumb
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                    case .failure:
                        DesignColors.surfaceThumb
                            .frame(width: 80, height: 80)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(DesignRadius.md)
            }

            // Right: Title and description
            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                Text(guide.title)
                    .font(DesignTypography.headline3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if let description = guide.description {
                    Text(description)
                        .font(DesignTypography.caption1)
                        .foregroundColor(DesignColors.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)

            Spacer()
        }
        .padding(DesignSpacing.md)
        .glassEffect()
        .cornerRadius(DesignRadius.lg)
        .opacity(isTapped ? 0.5 : 1.0)
    }
}

struct GuideSearchModalView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    let onSearch: () -> Void

    var body: some View {
        ZStack {
            DesignColors.secondaryBackground.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Search Guides")
                        .font(DesignTypography.headline2)
                        .foregroundColor(DesignColors.textPrimary)
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DesignColors.textPrimary)
                    }
                }
                .padding(DesignSpacing.lg)
                .background(DesignColors.secondaryBackground)

                VStack(spacing: DesignSpacing.lg) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(DesignColors.iconDefault)

                        TextField("Search guides...", text: $searchText)
                            .textFieldStyle(.plain)
                            .foregroundColor(DesignColors.textPrimary)
                            .submitLabel(.search)
                            .onSubmit {
                                onSearch()
                                isPresented = false
                            }

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(DesignColors.iconDefault)
                            }
                        }
                    }
                    .padding(DesignSpacing.md)
                    .background(DesignColors.surfaceThumb)
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

#Preview {
    GuidesView(client: SupabaseClient())
}
