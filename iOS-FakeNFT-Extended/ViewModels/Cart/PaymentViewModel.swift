//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 18.02.2026.
//
import Observation

@MainActor
@Observable final class PaymentViewModel {
    
    // MARK: - Dependencies
    private let paymentService: PaymentService
    private let dataStore: CartDataStore
    
    // MARK: - State Properties
    var cryptoPaymentArray: [PaymentModel]? = nil
    var paymentScreenState: ScreenState = .Unused
    var selectedCrypto: String? = nil
    
    var isActivePayment: Bool { selectedCrypto != nil }
    var paymentTypeIsLoaded: Bool {
        if let cryptoPaymentArray, !cryptoPaymentArray.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    init(paymentService: PaymentService, dataStore: CartDataStore) {
        self.paymentService = paymentService
        self.dataStore = dataStore
    }
    
    // MARK: Load CryptoArray
    func loadPaymentType() async {
        paymentScreenState = .Loading
        let paymentArray = try? await paymentService.loadPaymentType()
        if let paymentArray {
            cryptoPaymentArray = paymentArray
            paymentScreenState = .Unused
        } else {
            paymentScreenState = .UnSuccess
        }
    }
    
    // MARK: - Data Loading
    func processPayment() async {
        guard let selectedCrypto else { return }
        paymentScreenState = .Loading
        do {
            try await paymentService.paymentStatus(forType: selectedCrypto)
            let actualNftInCart: [String] = dataStore.loadActualNFTArray()
            try await paymentService.paymentActon(nftToPay: actualNftInCart)
            dataStore.needToUpdateUpdateNFTArray(status: true)
            paymentScreenState = .Success
        } catch {
            print("[PaymentViewModel/processPayment]: Неудачная загрузка")
            paymentScreenState = .UnSuccess
        }
        
    }
    
    // MARK: - Screen State (управление состоянием экрана)
    func changeScreenState(by actualState: ScreenState) {
        paymentScreenState = actualState
    }
    
    func changeStateToSelectedCrypto(crypto: PaymentModel) {
        selectedCrypto = crypto.id
    }
}

extension PaymentViewModel: AlertProtocol {
    
    var alertTitle: String {
        String(localized: "Payment failed")
    }
    
    func cancelPaymentRequest() {
        paymentScreenState = .Unused
        selectedCrypto = nil
    }
    
    func repeatNetworkRequest() async {
        await processPayment()
    }
}
