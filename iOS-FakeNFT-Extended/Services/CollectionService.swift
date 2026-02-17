//
//  CollectionService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 17.02.26.
//

import Foundation

protocol CollectionService {
    func loadCollections(page: Int, size: Int) async throws -> [Collection]
}

actor CollectionServiceImpl: CollectionService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(page: Int, size: Int) async throws -> [Collection] {
        let request = CollectionsRequest(page: page, size: size)
        return try await networkClient.send(request: request)
    }
}
