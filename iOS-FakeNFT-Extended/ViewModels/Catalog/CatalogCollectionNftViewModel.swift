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
    @AppStorage("user_cart") private var cartJSON: String = "[]"
    
    
    private let nft: Nft
    private let profileService: ProfileService
    private let cartService: CartService
    
    
    private var favorites: [String] {
        favoritesJSON.toStringArray()
    }
    
    private var cart: [String] {
        cartJSON.toStringArray()
    }
    
    init(
        nft: Nft,
        profileService: ProfileService,
        cartService: CartService
    ) {
        self.nft = nft
        self.profileService = profileService
        self.cartService = cartService
        
        self.isFavouriteActive = favorites.contains(nft.id)
        self.isInCartActive = cart.contains(nft.id)
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
    
    func toggleCart() async {
        let previousState = isInCartActive
        let previousCart = cart
        
        isInCartActive.toggle()
        
        var newCart = cart
        if newCart.contains(nft.id) {
            newCart.removeAll { $0 == nft.id }
        } else {
            newCart.append(nft.id)
        }
        
        saveCart(newCart)
        
        do {
            let updatedCart = try await cartService.updateCart(newCart)
            saveCart(updatedCart.nfts)
            print("Корзина обновлена на сервере")
        } catch {
            print("Ошибка обновления корзины: \(error)")
            isInCartActive = previousState
            saveCart(previousCart)
        }
    }
    
    private func saveFavorites(_ favorites: [String]) {
        favoritesJSON = favorites.toJSONString()
    }
    
    private func saveCart(_ cart: [String]) {
        cartJSON = cart.toJSONString()
    }
}
