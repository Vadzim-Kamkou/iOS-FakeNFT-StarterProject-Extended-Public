import Foundation

struct ProfileRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}

struct ProfileUpdateRequest: NetworkRequest {
    let id: String
    let name: String?
    let description: String?
    let website: String?
    let avatar: String?
    let likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod { .put }

    var body: Data? {
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        if let name { queryItems.append(URLQueryItem(name: "name", value: name)) }
        if let description { queryItems.append(URLQueryItem(name: "description", value: description)) }
        if let website { queryItems.append(URLQueryItem(name: "website", value: website)) }
        if let avatar { queryItems.append(URLQueryItem(name: "avatar", value: avatar)) }
        for like in likes {
            queryItems.append(URLQueryItem(name: "likes", value: like))
        }
        components.queryItems = queryItems
        return components.query?.data(using: .utf8)
    }

    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
