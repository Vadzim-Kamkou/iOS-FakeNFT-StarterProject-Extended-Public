import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest: Sendable {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
    var formData: [String: [String]]? { get }
}

extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var formData: [String: [String]]? { nil }
    var body: Data? { nil }
    var headers: [String: String]? { nil }
}