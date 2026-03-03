//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

protocol OrderService {
    func getOrder() async throws -> Order
    func updateCart(_ nfts: [String]) async throws -> Order
}

actor OrderServiceImpl: OrderService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getOrder() async throws -> Order {
        let request = OrderRequest()
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func updateCart(_ nfts: [String]) async throws -> Order {
        let request = UpdateOrderRequest(nfts: nfts)
        let order: Order = try await networkClient.send(request: request)
        return order
    }
}
