//
//  GetPaymentStatusRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//
import Foundation

struct GetPaymentStatusRequest: NetworkRequest, Sendable {
    let type: String
    
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(type)")
    }
}
