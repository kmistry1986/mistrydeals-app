import SwiftUI

struct ProductRow: View {
    let product: Product

    var body: some View {
        Link(destination: product.amazonURL ?? URL(string: "https://amazon.com")!) {
            HStack(alignment: .top, spacing: 12) {
                // Product image with glass effect
                ZStack {
                    Color.white.opacity(0.05)

                    if let imageUrl = product.image_url, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure, .empty:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(width: 70, height: 70)
                .cornerRadius(12)
                .clipped()
                .layoutPriority(1)

                VStack(alignment: .leading, spacing: 6) {
                    Text(product.truncatedTitle.trimmingCharacters(in: .whitespaces))
                        .font(DesignTypography.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignColors.primary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .padding(0)

                    HStack(spacing: 8) {
                        Text("$\(product.priceDouble, specifier: "%.2f")")
                            .font(DesignTypography.headline3)
                            .fontWeight(.bold)
                            .foregroundColor(DesignColors.accent)

                        if product.originalPriceDouble > 0 {
                            Text("$\(product.originalPriceDouble, specifier: "%.2f")")
                                .font(DesignTypography.caption1)
                                .foregroundColor(DesignColors.secondary)
                                .strikethrough()
                        }

                        if product.discountPercent > 0 {
                            Text("\(product.discountPercent)% OFF")
                                .font(DesignTypography.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            DesignColors.accentSecondary,
                                            Color(red: 0.9, green: 0.3, blue: 0.5)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(DesignRadius.sm)
                        }
                        
                        Spacer()
                    }
                }

                if product.ratingDouble > 0 {
                    VStack(spacing: 2) {
                        Text("★")
                            .font(DesignTypography.caption1)
                            .foregroundColor(DesignColors.success)

                        Text(String(format: "%.1f", product.ratingDouble))
                            .font(DesignTypography.caption1)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignColors.success)
                    }
                }
            }
            .padding(DesignSpacing.md)
            .background(DesignColors.tertiaryBackground.opacity(0.5))
            .cornerRadius(DesignRadius.md)
            .padding(.horizontal, DesignSpacing.xs)
            .padding(.vertical, DesignSpacing.xs)
        }
    }
}

#Preview {
    ProductRow(product: Product(
        id: "1",
        title: "Sample Product",
        display_title: nil,
        image_url: nil,
        price: 29.99,
        original_price: 49.99,
        rating: 4.5,
        amazon_asin: "B123456",
        is_featured: true,
        is_prime: true,
        last_price_sync: nil,
        description: nil
    ))
    .background(DesignColors.background)
}
