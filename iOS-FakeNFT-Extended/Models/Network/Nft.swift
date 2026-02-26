import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let images: [URL]
}
