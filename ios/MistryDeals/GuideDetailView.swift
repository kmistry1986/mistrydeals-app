import SwiftUI

struct GuideDetailView: View {
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
                        .foregroundColor(DesignColors.primary)
                    }
                    Spacer()
                }
                .padding(.horizontal, DesignSpacing.lg)
                .frame(height: 56)
                .background(DesignColors.secondaryBackground)
                .borderBottom(DesignColors.divider)

                ScrollView {
                    VStack(alignment: .leading, spacing: DesignSpacing.lg) {
                        if let imageUrl = guide.image_url, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    DesignColors.tertiaryBackground
                                        .frame(height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                case .failure:
                                    DesignColors.tertiaryBackground
                                        .frame(height: 200)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .cornerRadius(DesignRadius.md)
                        }

                        Text(guide.title)
                            .font(DesignTypography.displaySmall)
                            .foregroundColor(DesignColors.primary)

                        if let description = guide.description {
                            Text(description)
                                .font(DesignTypography.bodyMedium)
                                .foregroundColor(DesignColors.secondary)
                        }

                        if let content = guide.content {
                            Text(content)
                                .font(DesignTypography.bodySmall)
                                .foregroundColor(DesignColors.secondary)
                                .lineSpacing(4)
                        }

                        if !guide.products.isEmpty {
                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                Text("Products in this guide")
                                    .font(DesignTypography.headline2)
                                    .foregroundColor(DesignColors.primary)

                                VStack(spacing: 0) {
                                    ForEach(guide.products) { product in
                                        ProductRow(product: product)
                                            .borderBottom(DesignColors.divider)
                                    }
                                }
                                .background(DesignColors.tertiaryBackground)
                                .cornerRadius(DesignRadius.md)
                            }
                        }
                    }
                    .padding(DesignSpacing.lg)
                }
                .background(DesignColors.background)
            }
            .background(DesignColors.background)
    }
}

#Preview {
    GuideDetailView(guide: Guide(
        id: "1",
        title: "Best Gaming Laptops",
        description: "Find the perfect gaming laptop",
        image_url: nil,
        content: "This is a guide about gaming laptops",
        created_at: nil,
        products: []
    ))
}
