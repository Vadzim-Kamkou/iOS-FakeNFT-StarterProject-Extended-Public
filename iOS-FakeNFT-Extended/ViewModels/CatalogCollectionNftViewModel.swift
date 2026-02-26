//
//  CatalogCollectionNftViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 20.02.26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class CatalogCollectionNftViewModel: ObservableObject {
    
    @Published var isFavouriteActive: Bool = false
    @Published var isInCartActive: Bool = false
    @Published var isLoading: Bool = false
    
    @AppStorage("user_favorites") private var favoritesJSON: String = "[]"
    
    
    private let nft: Nft
    private let profileService: ProfileService
    private var favorites: [String] {
        favoritesJSON.toStringArray()
    }
    
    
    init(
        nft: Nft,
        profileService: ProfileService
    ) {
        self.nft = nft
        self.profileService = profileService
        self.isFavouriteActive = favorites.contains(nft.id)
    }
    
    func toggleFavourite() async {
        let previousState = isFavouriteActive
        let previousFavorites = favorites
        
        isFavouriteActive.toggle()
        
        var newFavorites = favorites
        if newFavorites.contains(nft.id) {
            newFavorites.removeAll { $0 == nft.id }
        } else {
            newFavorites.append(nft.id)
        }
        
        saveFavorites(newFavorites)
        
        do {
            let updatedProfile = try await profileService.updateLikes(newFavorites)
            
            saveFavorites(updatedProfile.likes)
            print("Избранное обновлено на сервере")
        } catch {
            print("Ошибка обновления избранного: \(error)")
            isFavouriteActive = previousState
            saveFavorites(previousFavorites)
        }
    }
    
    func toggleCart() {
        isInCartActive.toggle()
    }
    
    private func saveFavorites(_ favorites: [String]) {
        favoritesJSON = favorites.toJSONString()
    }
}
