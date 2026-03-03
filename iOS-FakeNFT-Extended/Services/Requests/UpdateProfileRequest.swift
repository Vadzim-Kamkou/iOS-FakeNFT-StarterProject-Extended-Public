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

struct ProfileUpdateRequest: NetworkRequest {
    let id: String
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
    
    init(id: String, name: String?, description: String?, website: String?, avatar: String?, nfts: [String]?, likes: [String]) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts ?? []
        self.likes = likes
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }

    var formData: [String: [String]]? {
        var data: [String: [String]] = [:]

        if let name {
            data["name"] = [name]
        }
        if let avatar {
            data["avatar"] = [avatar]
        }
        if let description {
            data["description"] = [description]
        }
        if let website {
            data["website"] = [website]
        }
        if !nfts.isEmpty {
            data["nfts"] = nfts
        }
        if !likes.isEmpty {
            data["likes"] = likes
        }

        return data.isEmpty ? nil : data
    }
}
