//
//  NftForCartModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//

struct NftForCartModel: Decodable, Sendable {
    let id: String
    let name: String
    let rating: Int
    let price: Double
    let images: [String]
}
