//
//  PaymentServices.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//

protocol PaymentService {
    func loadPaymentType() async throws -> [PaymentModel]
    func paymentStatus(forType withId: String) async throws
    func paymentActon(nftToPay: [String]) async throws
}

@MainActor
final class PaymentServices: PaymentService {
    private let networkClient: NetworkClient
    private let storage: PaymentStorage
    
    init(networkClient: NetworkClient, storage: PaymentStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadPaymentType() async throws -> [PaymentModel] {
        if let hasTypeArray = await storage.getPaymentType() {
            return hasTypeArray
        }
        
        let request = GetCurrencyRequest()
        let paymentArray: [PaymentModel] = try await networkClient.send(request: request)
        await saveToStorage(newArray: paymentArray)
        
        return paymentArray
    }
    
    func paymentActon(nftToPay: [String]) async throws {
        for i in 0 ..< nftToPay.count {
            let request = PostPaymentActionRequest(nfts: [nftToPay[i]])
            _ = try await networkClient.send(request: request)
        }
    }
    
    func paymentStatus(forType withId: String) async throws {
        let request = GetPaymentStatusRequest(type: withId)
        _ = try await networkClient.send(request: request)
    }
    
    private func saveToStorage(newArray: [PaymentModel]) async  {
        for i in newArray {
            await storage.savePaymentType(i)
        }
    }
}
