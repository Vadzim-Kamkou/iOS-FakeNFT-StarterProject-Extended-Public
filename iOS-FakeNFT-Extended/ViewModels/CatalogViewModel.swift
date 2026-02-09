//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 6.02.26.
//

import Foundation

final class CatalogViewModel: ObservableObject {
    
    @Published var catalogs: [CatalogItem] = mockCatalogs

    func catalogSorting() {
        print("CatalogView FilteringBtn Tapped")
    }
}
