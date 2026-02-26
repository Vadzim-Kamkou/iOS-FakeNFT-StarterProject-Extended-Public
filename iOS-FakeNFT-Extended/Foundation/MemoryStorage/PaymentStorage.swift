//
//  PaymentStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//

protocol PaymentStorage {
    func savePaymentType(_ nft: PaymentModel) async
    func getPaymentType() async -> [PaymentModel]?
}

actor PaymentStorageImpl: PaymentStorage {
    private var storage: [String: PaymentModel] = [:]
    
    func savePaymentType(_ type: PaymentModel) async {
        storage[type.id] = type
    }
    
    func getPaymentType() async -> [PaymentModel]? {
        var arrayToReturn = [PaymentModel]()
        for (_, value) in storage {
            arrayToReturn.append(value)
        }
        
        if !arrayToReturn.isEmpty {
            return arrayToReturn
        }
        
        return nil
    }
}
