//
//  CartNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//
import Foundation

@Observable
final class CartNFTViewModel {
    
    // MARK: - Dependencies
    private let dataStore: CartDataStore
    private let nftService: NFTServiceProtocol
    
    // MARK: - State Properties
    private(set) var NFTArray: [CartNFTModel]? = nil
    private var nftToRemove: CartNFTModel? = nil
    
    var cartScreenState: ScreenState = .Unused
    var isShowingDeleteConfirmation = false
    var isHiddenFilter = false
    
    var NFTArrayIsLoaded: Bool { NFTArray != nil }
    var NFTArrayIsEmpty : Bool {
        guard let NFTArray, NFTArray.isEmpty else { return false }
        return true
    }
    
    var NFTCounts: Int {
        guard let NFTArray else { return 0 }
        return NFTArray.count
    }
    
    init(dataStore: CartDataStore, nftService: NFTServiceProtocol) {
        self.nftService = nftService
        self.dataStore = dataStore
    }
    
    // MARK: - Data Loading
    func loadNFT() async {
        cartScreenState = .Loading
        try? await Task.sleep(nanoseconds: 1_500_000_000) // временно для теста ProgressHUD
        await createMocksNFTArray()
        cartScreenState = .Unused // менять для проверки разных состояний
    }
    
    func createMocksNFTArray() async {
        do {
            NFTArray = try await nftService.fetchNFTForCart()
            dataStore.updateNFT(totalPrice: cartNFTTotalPrice)
        } catch {
            cartScreenState = .UnSuccess
            print("[CartNFTViewModel /createMocksNFTArray]: Failed to load items cartScreenState -> \(cartScreenState)")
        }
    }
    
    // MARK: - Screen State (управление состоянием экрана)
    func changeScreenState(by actualState: ScreenState) {
        cartScreenState = actualState
    }
}

// MARK: Calculating
extension CartNFTViewModel {
    var cartNFTTotalPrice: Double {
        NFTArray?
            .reduce(0) { $0 + $1.price }
            .roundedTwoDecimals ?? 0
    }
}

// MARK: Remove
extension CartNFTViewModel {
    func removeButtonTapped(for nft: CartNFTModel) {
        nftToRemove = nft
        isShowingDeleteConfirmation = true
    }
    
    func confirmDeletion(_ confirm: Bool) {
        if let nftToRemove, let oldArray = NFTArray, confirm {
            let arrayForUpdating = oldArray.filter { $0.id != nftToRemove.id }
            NFTArray = arrayForUpdating
            dataStore.updateNFT(totalPrice: cartNFTTotalPrice)
        }
        reuseRemovingState()
    }
    
    private func reuseRemovingState() {
        nftToRemove = nil
        isShowingDeleteConfirmation = false
    }
}

// MARK: Filter
extension CartNFTViewModel {
    func tapOnFilterButton() {
        isHiddenFilter.toggle()
    }
    
    func filterBy(_ value: SortVariation ) {
        tapOnFilterButton()
        
        switch value {
        case .byName: NFTArray = NFTArray?.sorted { $0.nftName > $1.nftName }
        case .byPrice: NFTArray = NFTArray?.sorted { $0.price > $1.price }
        case .byRating: NFTArray = NFTArray?.sorted { $0.countStars > $1.countStars }
        }
    }
}

extension CartNFTViewModel: AlertProtocol  {
    
    var alertTitle: String {
        String(localized: "Load NFT failed")
    }
    
    func cancelPaymentRequest() {
        cartScreenState = .Unused
    }
    
    func repeatNetworkRequest() async {
        await loadNFT()
    }
}
