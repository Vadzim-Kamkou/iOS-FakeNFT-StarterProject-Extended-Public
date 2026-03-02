//
//  CartStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//

protocol CartStorage {
    func saveCartNFt(for cart:NftForCartModel) async
    func getCartNft(with id: String) async -> NftForCartModel?
}

actor CartStorageImpl: CartStorage {
    private var cartStorage: [String: NftForCartModel] = [:]
    
    func saveCartNFt(for cart:NftForCartModel) async {
        return cartStorage[cart.id] = cart
    }
    
    func getCartNft(with id: String) async -> NftForCartModel? {
        return cartStorage[id]
    }
}
