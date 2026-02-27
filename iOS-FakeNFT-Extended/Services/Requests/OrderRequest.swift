//
//  OrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

struct OrderRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
