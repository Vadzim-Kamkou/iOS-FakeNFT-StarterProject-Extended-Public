//
//  CartNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//
import Foundation

@Observable
final class CartNFTViewModel {
    
    var isShowingDeleteConfirmation : Bool = false
    private(set) var NFTArray: [CartNFTModel] = []
    
    var NFTArrayIsEmpty: Bool {
        NFTArray.isEmpty
    }
    
    var NFTCounts: Int {
        NFTArray.count
    }
    
    var cartNFTTotalPrice: Double {
        NFTArray.reduce(0) { $0 + $1.price }.roundedTwoDecimals
    }
    private let nftService: NFTServiceProtocol
    private var nftToRemove: CartNFTModel? = nil
    
    init(nftService: NFTServiceProtocol) {
        self.nftService = nftService
    }
    
    func createMocksNFTArray() async {
        do {
            NFTArray = try await nftService.fetchNFTForCart()
        } catch {
            print("[CartNFTViewModel]: createMocksNFTArray - Failed to load items: \(error)")
        }
    }
    
    func removeButtonTapped(for nft: CartNFTModel) {
        nftToRemove = nft
        isShowingDeleteConfirmation = true
    }
    
    func confirmDeletion(_ confirm: Bool) {
        if confirm, let nftToRemove  {
            let arrayForUpdating = NFTArray.filter {$0.id != nftToRemove.id }
            NFTArray = arrayForUpdating
        }
        nftToRemove = nil
        isShowingDeleteConfirmation = false
    }
}
