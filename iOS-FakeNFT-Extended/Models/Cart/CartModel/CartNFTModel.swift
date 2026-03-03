//
//  CartNFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//

import Foundation

struct CartNFTModel: Identifiable, Sendable {
    let id: String
    let imageName: String
    let nftName: String
    let countStars: Int
    let price: Double
}
