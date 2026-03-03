//
//  PutOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//
import Foundation

struct PutOrderRequest: NetworkRequest, Sendable {
    let nfts: [String]
    
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod { .put }
    var dto: Encodable? { CartArrayModel(nfts: nfts) }
}
