import Foundation

struct Nft: Decodable, Identifiable, Sendable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String
    let createdAt: String
    
    var imageURLs: [URL] {
        images.compactMap { URL(string: $0) }
    }
    
    var firstImageURL: URL? {
        imageURLs.first
    }
}
