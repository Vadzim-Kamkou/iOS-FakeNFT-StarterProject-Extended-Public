//
//  CollectionItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import Foundation

struct CollectionItem: Identifiable {
    let id = UUID()
    let imageName: String
    let isFavourite: Bool
    let ratings: Int
    let title: String
    let price: Int
    let currency: String
    let isInCart: Bool
}
