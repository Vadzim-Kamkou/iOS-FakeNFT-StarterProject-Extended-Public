import Foundation
import Logging

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case incorrectRequest(String)
}

protocol NetworkClient {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest) async throws -> T
}

actor DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func send(request: NetworkRequest) async throws -> Data {
        let urlRequest = try create(request: request)
        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            Logger.shared.info("Ошибка в send - urlSessionError")
            throw NetworkClientError.urlSessionError
        }
        guard 200 ..< 300 ~= response.statusCode else {
            Logger.shared.info("Ошибка в send - код ошибки 200 ..< 300")
            throw NetworkClientError.httpStatusCode(response.statusCode)
        }
        return data
    }
    
    func send<T: Decodable & Sendable>(request: NetworkRequest) async throws -> T {
        let data = try await send(request: request)
        return try await parse(data: data)
    }
    
    // MARK: - Private
    
    private enum ContentType {
        static let formURLEncoded = "application/x-www-form-urlencoded"
        static let json = "application/json"
    }
    
    private func create(request: NetworkRequest) throws -> URLRequest {
        guard let endpoint = request.endpoint else {
            Logger.shared.info("create - отсутствует endpoint")
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        try createBodyAndSetValueFor(urlRequest: &urlRequest, request: request)
        
        if urlRequest.httpBody == nil {
            if let formData = request.formData,
               let formBody = createURLEncodedBody(from: formData) {
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = formBody
            }
        }

        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return urlRequest
    }
    
    private func createBodyAndSetValueFor(urlRequest: inout URLRequest, request: NetworkRequest) throws {
        switch request {
        case let cartRequest as PutOrderRequest:
            urlRequest.setValue(ContentType.formURLEncoded, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = cartRequest.nfts.isEmpty
            ? nil
            : "nfts=\(cartRequest.nfts.joined(separator: ","))".data(using: .utf8)
            
        case let paymentRequest as PostPaymentActionRequest:
            urlRequest.setValue(ContentType.formURLEncoded, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = "nfts=\(paymentRequest.nfts.joined(separator: ","))".data(using: .utf8)
            
        default:
            if let dto = request.dto {
                urlRequest.setValue(ContentType.json, forHTTPHeaderField: "Content-Type")
                guard let dtoEncoded = try? encoder.encode(dto) else {
                    Logger.shared.info("createBodyAndSetValueFor - не удалось загрузить DTO")
                    throw NetworkClientError.incorrectRequest("[DefaultNetworkClient]: Failed to encode DTO")
                }
                urlRequest.httpBody = dtoEncoded
            } else if let body = request.body {
                urlRequest.httpBody = body
                if let headers = request.headers {
                    for (key, value) in headers {
                        urlRequest.setValue(value, forHTTPHeaderField: key)
                    }
                }
            }
        }
    }
    
    private func createURLEncodedBody(from formData: [String: [String]]) -> Data? {
        var components: [String] = []
        
        for (key, values) in formData {
            for value in values {
                guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else { continue }
                
                components.append("\(encodedKey)=\(encodedValue)")
            }
        }
        
        let bodyString = components.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }

    private func parse<T: Decodable>(data: Data) async throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            Logger.shared.info("parse - не удалось распарсить в модель \(T.self)")
            throw NetworkClientError.parsingError
        }
    }
}
