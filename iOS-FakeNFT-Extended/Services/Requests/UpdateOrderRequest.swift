//
//  UpdateOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    
    private let nfts: [String]
    
    init(nfts: [String]) {
        self.nfts = nfts
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var formData: [String: [String]]? {
        ["nfts": nfts]
    }
}
