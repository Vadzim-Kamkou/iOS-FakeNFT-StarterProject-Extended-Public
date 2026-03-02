//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//

protocol CartService {
    func loadCartArray() async throws -> CartArrayModel
    func loadNftForCart(id: String) async throws -> NftForCartModel
    func updateCart(new array: CartArrayModel) async throws -> Bool
}

final class CartServiceImpl: CartService {
    private let networkClient: NetworkClient
    private let storage: CartStorage
    
    init(networkClient: NetworkClient, storage: CartStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadCartArray() async throws -> CartArrayModel {
        let request = GetOrderRequest()
        let nftArray: CartArrayModel = try await networkClient.send(request: request)
        return nftArray
    }
    
    func loadNftForCart(id: String) async throws -> NftForCartModel {
        if let nft = await storage.getCartNft(with: id) {
            return nft
        }
        
        let request = NFTRequest(id: id)
        let nft: NftForCartModel = try await networkClient.send(request: request)

        await storage.saveCartNFt(for: nft)
        
        return nft
    }
    
    func updateCart(new array: CartArrayModel) async throws -> Bool {
        let request = PutOrderRequest(nfts: array.nfts)
        do {
            let _: CartArrayModel = try await networkClient.send(request: request)
            return true
        } catch {
            return false
        }
    }
}
