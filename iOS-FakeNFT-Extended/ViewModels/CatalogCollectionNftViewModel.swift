//
//  CatalogCollectionNftViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 20.02.26.
//

import Foundation
import Combine

@MainActor
final class CatalogCollectionNftViewModel: ObservableObject {
    
    @Published var isFavouriteActive: Bool = false
    @Published var isInCartActive: Bool = false
    
    private let nft: Nft
    
    init(nft: Nft) {
        self.nft = nft
    }
    
    func toggleFavourite() {
        isFavouriteActive.toggle()
    }
    func toggleCart() {
        isInCartActive.toggle()
        
    }
}
