//
//  SortVariationType.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 17.02.2026.
//

enum SortVariation: String, CaseIterable {
    case byPrice = "By Price"
    case byRating = "By Rating"
    case byName = "By name"
    
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue))
    }
}
