//
//  CatalogCollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 17.02.26.
//

import Foundation

@MainActor
final class CatalogCollectionViewModel: ObservableObject {
    
    @Published var nfts: [Nft] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let nftService: NftService
    private let collection: Collection
    
    init(collection: Collection, nftService: NftService) {
        self.collection = collection
        self.nftService = nftService
    }
    
    func loadNfts() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            nfts = try await nftService.loadNfts(ids: collection.nfts)
        } catch {
            errorMessage = "Ошибка загрузки NFT"
            print("Error loading NFTs: \(error)")
        }
        
        isLoading = false
    }
}
