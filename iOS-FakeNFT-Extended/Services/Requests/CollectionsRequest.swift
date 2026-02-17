//
//  CollectionsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 17.02.26.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)api/v1/collections")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        return components?.url
    }
}
