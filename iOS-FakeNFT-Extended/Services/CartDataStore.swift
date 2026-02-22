//
//  CartDataStore.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 19.02.2026.
//
import Observation

@Observable final class CartDataStore {
    private var paymentMethodIsSelected: PaymentType?
    private var count: Double?
    
    var paymentModel: PaymentModel?
    
    func updatePayment(method: PaymentType?) {
        paymentMethodIsSelected = method
        checkSate()
    }
    
    func updateNFT(totalPrice: Double) {
        count = totalPrice
    }
    
    private func checkSate() {
        guard let paymentMethodIsSelected, let count else { return }
        paymentModel = PaymentModel(count: count, type: paymentMethodIsSelected)
    }
}

