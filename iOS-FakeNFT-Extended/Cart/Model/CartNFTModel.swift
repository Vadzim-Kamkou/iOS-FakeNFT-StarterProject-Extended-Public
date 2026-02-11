//
//  CartNFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//

import Foundation

struct CartNFTModel: Identifiable {
    let id = UUID()
    let name: String
    let countStars: Int
    let price: Int
}
