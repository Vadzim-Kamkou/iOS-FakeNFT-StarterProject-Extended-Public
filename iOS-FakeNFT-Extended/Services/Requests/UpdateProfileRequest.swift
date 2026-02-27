//
//  UpdateProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    
    private let likes: [String]
    
    init(likes: [String]) {
        self.likes = likes
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }

    var formData: [String: [String]]? {
        ["likes": likes]
    }
}
