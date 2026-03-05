//
//  CartNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//
import Foundation
import Combine
import Logging

@MainActor
@Observable
final class CartNFTViewModel {
    
    // MARK: - Dependencies
    private let dataStore: CartDataStore
    private let cartService: CartService
    private let filterStorage = FilterUserDefaults()
    
    // MARK: - State Properties
    private(set) var NFTArray: [CartNFTModel]? = nil
    private var nftToRemove: CartNFTModel? = nil
    private var cancelLables = Set<AnyCancellable>()
    
    var cartScreenState: ScreenState = .Unused
    var isShowingDeleteConfirmation = false
    var isHiddenFilter = false
    var NFTArrayIsLoaded: Bool { NFTArray != nil }
    
    var nftToRemoveImageName: String {
        guard let nftToRemove else { return "" }
        return nftToRemove.imageName
    }
    
    var NFTArrayIsEmpty : Bool {
        guard let NFTArray, NFTArray.isEmpty else { return false }
        return true
    }
    
    var NFTCounts: Int {
        guard let NFTArray else { return 0 }
        return NFTArray.count
    }
    
    init(dataStore: CartDataStore, cartService: CartService) {
        self.cartService = cartService
        self.dataStore = dataStore
        addSubscribing()
    }
    
    // MARK: - Data Loading
    private func updateLocal(array: CartArrayModel) async -> [NftForCartModel] {
        await withTaskGroup(of: NftForCartModel?.self) { group in
            for id in array.nfts {
                group.addTask { [cartService] in
                    try? await cartService.loadNftForCart(id: id)
                }
            }
            return await group.reduce(into: []) { $0 += [$1].compactMap { $0 } }
        }
    }
    
    func loadNFT() async {
        cartScreenState = .Loading
        
        do {
            let nftArray = try await cartService.loadCartArray()
            let localArray = await updateLocal(array: nftArray)
            let convertToNftForCart = convert(array: localArray)
            
            NFTArray = convertToNftForCart
            
            if let actualFilterType = filterFromStorage() {
                filter(by: actualFilterType)
            }
            
            updateDataStore(new: convertToNftForCart)
            cartScreenState = .Unused
        } catch {
            cartScreenState = .UnSuccess
            Logger.shared.info("createMocksNFTArray: Ошибка при загрузке, cartScreenState -> \(cartScreenState)")
        }
    }
    
    func reloadNFTArray() async {
        do {
            let _ = await remove(newArray: [])
            let nftArray = try await cartService.loadCartArray()
            let localArray = await updateLocal(array: nftArray)
            let convertToNftForCart = convert(array: localArray)
            
            NFTArray = convertToNftForCart
            updateDataStore(new: convertToNftForCart)
        } catch {
            Logger.shared.info("reloadNFTArray: Не удалось удалить данные")
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
    
    func confirmDeletion(_ confirm: Bool) async {
        if let nftToRemove, let oldArray = NFTArray, confirm {
            
            cartScreenState = .Loading
            
            let arrayForUpdating = oldArray.filter { $0.id != nftToRemove.id }
            let canRemove = await remove(newArray: arrayForUpdating)
            
            if canRemove {
                cartScreenState = .Unused
                NFTArray = arrayForUpdating
                updateDataStore(new: arrayForUpdating)
            } else {
                cartScreenState = .UnSuccess
            }
        }
        reuseRemovingState()
    }
    
    private func remove(newArray: [CartNFTModel]) async -> Bool {
        
        if let _ = try? await cartService.updateCart(newArray.map({ $0.id })) {
            return true
        } else {
            return false
        }
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
    
    func tapOnFilterButton(_ value: SortVariation ) {
        tapOnFilterButton()
        filter(by: value)
    }
    
    func filter(by value:SortVariation) {
        switch value {
        case .byName: NFTArray = NFTArray?.sorted { $0.nftName < $1.nftName }
        case .byPrice: NFTArray = NFTArray?.sorted { $0.price > $1.price }
        case .byRating: NFTArray = NFTArray?.sorted { $0.countStars > $1.countStars }
        }
        
        saveFilterType(value)
    }
    
    private func filterFromStorage() -> SortVariation? {
        if let actualFilterType = filterStorage.load() {
            return actualFilterType
        } else {
            return nil
        }
    }
    
    private func saveFilterType(_ value: SortVariation) {
        filterStorage.save(value)
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

extension CartNFTViewModel {
    private func convert(array: [NftForCartModel]) -> [CartNFTModel] {
        var NFTArray = [CartNFTModel]()
        
        for i in array {
            NFTArray.append(CartNFTModel(id: i.id, imageName: i.images.first ?? "", nftName: i.name, countStars: i.rating, price: i.price))
        }
        return NFTArray
    }
    
    private func addSubscribing(){
        dataStore.needCleanCartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                Task {
                    if status {
                        await self?.reloadNFTArray()
                    }
                }
            }
            .store(in: &cancelLables)
    }
    
    private func updateDataStore(new array: [CartNFTModel]) {
        dataStore.update(nftArray: array)
        dataStore.needToUpdateUpdateNFTArray(status: false)
    }
}
