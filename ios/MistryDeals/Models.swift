import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let title: String
    let display_title: String?
    let image_url: String?
    let price: Double
    let original_price: Double?
    let rating: Double?
    let amazon_asin: String
    let is_featured: Bool?
    let is_prime: Bool?
    let last_price_sync: String?

    var priceDouble: Double {
        price
    }

    var originalPriceDouble: Double {
        original_price ?? 0
    }

    var ratingDouble: Double {
        rating ?? 0
    }

    var discountPercent: Int {
        guard originalPriceDouble > 0 else { return 0 }
        return Int(((originalPriceDouble - priceDouble) / originalPriceDouble) * 100)
    }

    var truncatedTitle: String {
        var titleToUse = (display_title ?? title).trimmingCharacters(in: .whitespacesAndNewlines)
        // Remove multiple spaces and normalize whitespace
        titleToUse = titleToUse.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        let maxLength = 60
        if titleToUse.count > maxLength {
            return String(titleToUse.prefix(maxLength)) + "..."
        }
        return titleToUse
    }

    var amazonURL: URL? {
        URL(string: "https://www.amazon.com/dp/\(amazon_asin)?tag=mistrydealshp-20")
    }
}

struct Guide: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let image_url: String?
    let content: String?
    let created_at: String?

    var products: [Product] = []
}

enum TabSelection {
    case featured
    case prime
    case guides
    case search
}
