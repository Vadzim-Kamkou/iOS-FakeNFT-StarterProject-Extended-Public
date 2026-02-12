//
//  NFTServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 12.02.2026.
//

protocol NFTServiceProtocol {
    func fetchNFTForCart() async throws -> [CartNFTModel]
}
