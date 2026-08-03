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
    let is_prime_bonus: Bool?
    let prime_cashback_percent: Int?
    let last_price_sync: String?
    let description: String?

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

struct GuideContent: Codable {
    let title: String
    let subtitle: String?
    let event_name: String?
    let intro: [String]?
    let products: [Product]?
    let sections: [GuideSection]?
    let faq: [GuideFAQ]?
    let howto: [String]?
}

struct GuideSection: Codable, Identifiable {
    let title: String
    let content: String
    let id: String

    init(title: String, content: String, id: String = UUID().uuidString) {
        self.title = title
        self.content = content
        self.id = id
    }

    enum CodingKeys: String, CodingKey {
        case title, content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        id = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
    }
}

struct GuideFAQ: Codable, Identifiable {
    let question: String
    let answer: String
    let id: String

    init(question: String, answer: String, id: String = UUID().uuidString) {
        self.question = question
        self.answer = answer
        self.id = id
    }

    enum CodingKeys: String, CodingKey {
        case question, answer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question)
        answer = try container.decode(String.self, forKey: .answer)
        id = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(question, forKey: .question)
        try container.encode(answer, forKey: .answer)
    }
}

struct Guide: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String?
    let image_url: String?
    let content: String?
    let created_at: String?
    let guide_url: String?

    var products: [Product] = []
    var guideContent: GuideContent?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Guide, rhs: Guide) -> Bool {
        lhs.id == rhs.id
    }
}

enum TabSelection {
    case featured
    case prime
    case guides
    case search
}
