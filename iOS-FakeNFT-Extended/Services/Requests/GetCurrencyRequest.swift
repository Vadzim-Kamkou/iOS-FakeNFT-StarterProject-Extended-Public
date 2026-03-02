//
//  GetCurrencyRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//
import Foundation

struct GetCurrencyRequest: NetworkRequest, Sendable {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
