import Foundation

struct NFTRequest: NetworkRequest, Sendable {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
