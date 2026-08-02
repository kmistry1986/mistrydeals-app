import Foundation

class SupabaseClient: ObservableObject {
    private let baseURL = "https://qolksrytidvxarrlygyy.supabase.co"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFvbGtzcnl0aWR2eGFycmx5Z3l5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3MzAyNDcsImV4cCI6MjA3ODMwNjI0N30.126SOE0Mi6tB2ywtDzOYPUzqZ5cUl6Sk5QXgUGjMR0g"

    func fetchProducts(type: String) async throws -> [Product] {
        let query: String
        switch type {
        case "featured":
            query = "select=*&is_featured=eq.true&order=last_price_sync.desc&limit=500&offset=0"
        case "prime":
            query = "select=*&is_prime_bonus=eq.true&order=last_price_sync.desc&limit=500&offset=0"
        default:
            query = "select=*&order=last_price_sync.desc&limit=500&offset=0"
        }

        let urlString = "\(baseURL)/rest/v1/products?\(query)"
        print("🔍 Fetching: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("✅ Response: \(response)")
            let products = try JSONDecoder().decode([Product].self, from: data)
            print("📊 Fetched \(products.count) products for type: \(type)")
            return products
        } catch {
            print("❌ Error: \(error)")
            throw error
        }
    }

    func searchProducts(query: String) async throws -> [Product] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "\(baseURL)/rest/v1/products?title=ilike.*\(encoded)*&select=*&limit=50")!

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Product].self, from: data)
    }

    func fetchGuides() async throws -> [Guide] {
        let urlString = "\(baseURL)/rest/v1/guide_calendar?select=id,title,caption,guide_url,content&published=eq.true&order=published_at.desc"
        print("🔍 Fetching guides: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("✅ Guides response: \(response)")

            struct GuideCalendarRow: Codable {
                let id: String
                let title: String
                let caption: String?
                let guide_url: String?
                let content: GuideContent?
            }

            let rows = try JSONDecoder().decode([GuideCalendarRow].self, from: data)
            print("📖 Fetched \(rows.count) guides")

            let guides = rows.map { row in
                let parsedContent = row.content
                let imageUrl = extractFirstProductImage(from: parsedContent?.products)
                let description = row.caption ?? (parsedContent?.intro?.first ?? nil)
                let fullGuideUrl: String?
                if let guideUrl = row.guide_url {
                    if guideUrl.hasPrefix("http") {
                        fullGuideUrl = guideUrl
                    } else {
                        fullGuideUrl = "http://www.mistrydeals.com\(guideUrl)"
                    }
                } else {
                    fullGuideUrl = nil
                }

                var guide = Guide(
                    id: row.id,
                    title: row.title,
                    description: description,
                    image_url: imageUrl,
                    content: nil,
                    created_at: nil,
                    guide_url: fullGuideUrl
                )
                guide.products = parsedContent?.products ?? []
                guide.guideContent = parsedContent
                print("📚 Guide: \(guide.title)")
                return guide
            }

            print("📖 Fetched \(guides.count) guides")
            return guides
        } catch {
            print("❌ Error fetching guides: \(error)")
            throw error
        }
    }

    private func extractFirstProductImage(from products: [Product]?) -> String? {
        return products?.first?.image_url
    }

}
