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
            let loadedNfts = try await nftService.loadNfts(ids: collection.nfts)
            
            var uniqueNfts: [Nft] = []
            var seenIds = Set<String>()
            
            for nft in loadedNfts {
                if !seenIds.contains(nft.id) {
                    uniqueNfts.append(nft)
                    seenIds.insert(nft.id)
                }
            }
            
            nfts = uniqueNfts
            isLoading = false
        } catch {
            errorMessage = "Ошибка загрузки NFT"
            print("Error loading NFTs: \(error)")
        }
        
        isLoading = false
    }
    
    func loadFavoritesIfNeeded(profileService: ProfileService) async {
        let cachedFavoritesJSON = UserDefaults.standard.string(forKey: "user_favorites") ?? "[]"
        let cachedFavorites = cachedFavoritesJSON.toStringArray()
        
        guard cachedFavorites.isEmpty else {
            return
        }
        
        do {
            let profile = try await profileService.getProfile()
            
            // Сохраняем в кэш
            let favoritesJSON = profile.likes.toJSONString()
            UserDefaults.standard.set(favoritesJSON, forKey: "user_favorites")
        } catch {
            // При ошибке тихо продолжаем работу с пустым кэшем
        }
    }
    
    func loadCartIfNeeded(cartService: CartService) async {
        let cachedCartJSON = UserDefaults.standard.string(forKey: "user_cart") ?? "[]"
        let cachedCart = cachedCartJSON.toStringArray()
        
        guard cachedCart.isEmpty else {
            return
        }
        
        do {
            let cartArray = try await cartService.loadCartArray()
            
            let cartJSON = cartArray.nfts.toJSONString()
            UserDefaults.standard.set(cartJSON, forKey: "user_cart")
        } catch {
        }
    }
}
