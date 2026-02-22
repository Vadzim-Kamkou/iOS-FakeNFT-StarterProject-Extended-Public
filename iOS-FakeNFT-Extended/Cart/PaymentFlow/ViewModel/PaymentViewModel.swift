//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 18.02.2026.
//
import Observation

@Observable final class PaymentViewModel {
    
    // MARK: - Dependencies
    private let dataStore: CartDataStore
    private var paymentModel: PaymentModel? {
        dataStore.paymentModel
    }
    
    // MARK: - State Properties
    let cryptoPaymentArray: [Crypto]
    var paymentScreenState: ScreenState = .Unused
    var selectedCrypto: Crypto? = nil
    var isActivePayment: Bool { selectedCrypto != nil }
    
    init(dataStore: CartDataStore) {
        self.cryptoPaymentArray = Crypto.createCryptoArray()
        self.dataStore = dataStore
    }
    
    // MARK: - Data Loading
    func processPayment() async {
        paymentScreenState = .Loading
        try? await Task.sleep(nanoseconds: 1_500_000_000) // временно для теста ProgressHUD
        paymentScreenState = .Success //  менять для проверки разных состояний
    }
    
    // MARK: - Screen State (управление состоянием экрана)
    func changeScreenState(by actualState: ScreenState) {
        paymentScreenState = actualState
    }
    
    func changeStateToSelectedCrypto(crypto: Crypto) {
        dataStore.updatePayment(method: PaymentType(crypto: crypto))
        selectedCrypto = crypto
    }
}

extension PaymentViewModel: AlertProtocol {
    
    var alertTitle: String {
        String(localized: "Payment failed")
    }
    
    func cancelPaymentRequest() {
        paymentScreenState = .Unused
        selectedCrypto = nil
        dataStore.updatePayment(method: nil)
    }
    
    func repeatNetworkRequest() async {
        await processPayment()
    }
}
