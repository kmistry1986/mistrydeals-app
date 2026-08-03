import SwiftUI

struct ProductRow: View {
    let product: Product

    var body: some View {
        Link(destination: product.amazonURL ?? URL(string: "https://amazon.com")!) {
            HStack(alignment: .top, spacing: 12) {
                // Product image with date below
                VStack(alignment: .center, spacing: 0) {
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

                    if let dateString = product.last_price_sync {
                        Text(formatDate(dateString))
                            .font(.system(size: 8, weight: .regular))
                            .foregroundColor(DesignColors.tertiary)
                            .lineLimit(1)
                            .padding(.top, 6)
                    }
                }
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
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text("$\(product.priceDouble, specifier: "%.2f")")
                                    .font(DesignTypography.price)
                                    .foregroundColor(Color("PriceColor"))

                                if product.originalPriceDouble > 0 {
                                    Text("$\(product.originalPriceDouble, specifier: "%.2f")")
                                        .font(DesignTypography.caption1)
                                        .foregroundColor(Color("OriginalPriceColor"))
                                        .strikethrough()
                                }

                                if product.discountPercent > 0 {
                                    Text("\(product.discountPercent)% OFF")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color("DiscountBadgeColor"))
                                        .cornerRadius(DesignRadius.sm)
                                }
                            }

                            if let cashback = product.prime_cashback_percent, cashback > 0 {
                                Text("+\(cashback)% Cashback with Prime Credit Card")
                                    .font(DesignTypography.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color("PrimeCashbackColor"))
                                    .cornerRadius(DesignRadius.sm)
                                    .padding(.top, 4)
                            }
                        }

                        Spacer()
                    }
                }

                if product.ratingDouble > 0 {
                    VStack(spacing: 2) {
                        Text("★")
                            .font(DesignTypography.caption1)
                            .foregroundColor(Color("StarRatingColor"))

                        Text(String(format: "%.1f", product.ratingDouble))
                            .font(DesignTypography.caption1)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("StarRatingColor"))
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

    private func formatDate(_ dateString: String) -> String {
        // Extract just the date part (YYYY-MM-DD) from ISO8601 string
        let datePart = String(dateString.prefix(10))

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.timeZone = TimeZone(identifier: "America/New_York")
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = inputFormatter.date(from: datePart) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM/dd/yyyy"
            displayFormatter.timeZone = TimeZone(identifier: "America/New_York")
            displayFormatter.locale = Locale(identifier: "en_US_POSIX")
            return displayFormatter.string(from: date)
        }
        return datePart
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
        is_prime_bonus: true,
        prime_cashback_percent: 5,
        last_price_sync: nil,
        description: nil
    ))
    .background(DesignColors.background)
}
