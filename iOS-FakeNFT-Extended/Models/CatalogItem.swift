//
//  CatalogItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import Foundation

struct CatalogItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let count: Int
    let autor: String
    let description: String
    let collection : [CollectionItem]
}
