//
//  ProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
