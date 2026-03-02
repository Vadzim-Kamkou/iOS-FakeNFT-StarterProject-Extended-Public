//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

struct Profile: Decodable, Sendable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
}
