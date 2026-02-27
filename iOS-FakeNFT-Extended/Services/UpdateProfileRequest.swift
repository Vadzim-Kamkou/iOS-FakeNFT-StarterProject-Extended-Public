import Foundation

struct UpdateProfileRequestDTO: Encodable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let likes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name, avatar, description, website, nfts, likes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(website, forKey: .website)
        try container.encodeIfPresent(nfts, forKey: .nfts)
        try container.encodeIfPresent(likes, forKey: .likes)
    }
}

struct UpdateProfileRequest: NetworkRequest {
    let id: String
    let dto: UpdateProfileRequestDTO
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
}

