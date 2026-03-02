import Foundation

struct Collection: Decodable, Identifiable, Sendable, Hashable {
    let id: String
    let name: String
    let cover: String
    let description: String
    let author: String
    let website: String
    let nfts: [String]
    let createdAt: String
    
    var coverURL: URL? {
        URL(string: cover)
    }
    
    var nftCount: Int {
        nfts.count
    }
    
    var uniqueNftsCount: Int {
        Set(nfts).count
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        lhs.id == rhs.id
    }
}
