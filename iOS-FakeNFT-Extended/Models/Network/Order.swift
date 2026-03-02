//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

struct Order: Decodable, Sendable {
    let id: String
    let nfts: [String]
}
