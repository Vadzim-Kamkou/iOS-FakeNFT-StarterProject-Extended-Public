import Foundation

struct NftForProfile1: Decodable {
    let createdAt: String
    let name: String
    let id: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: URL
}
