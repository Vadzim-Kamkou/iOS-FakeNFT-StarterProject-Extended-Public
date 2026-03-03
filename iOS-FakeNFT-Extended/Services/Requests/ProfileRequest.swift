import Foundation

struct ProfileRequest: NetworkRequest {
let id: String

init(id: String = "1") {
self.id = id
}

var endpoint: URL? {
URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
}

var httpMethod: HttpMethod {
.get
}
}
