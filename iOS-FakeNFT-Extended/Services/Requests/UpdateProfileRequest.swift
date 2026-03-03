import Foundation

struct UpdateProfileRequest: NetworkRequest {
    
    private let likes: [String]
    
    init(likes: [String]) {
        self.likes = likes
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var formData: [String: [String]]? {
        ["likes": likes]
    }
}

struct ProfileUpdateRequestDTO: Encodable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let likes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name, avatar, description, website, likes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(website, forKey: .website)
        try container.encodeIfPresent(likes, forKey: .likes)
    }
}

struct ProfileUpdateRequest: NetworkRequest {
    let id: String
    let dto: Encodable?
    
    init(id: String, name: String?, description: String?, website: String?, avatar: String?, likes: [String]) {
        self.id = id
        self.dto = ProfileUpdateRequestDTO(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes
        )
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
}
