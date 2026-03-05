//
//  FilterUserDefaults.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 26.02.2026.
//
import Foundation

final class FilterUserDefaults {
    private let userDefaults = UserDefaults.standard
    private let key = "actualType"
    
    func save(_ sort: SortVariation) {
        userDefaults.set(sort.rawValue, forKey: key)
    }
    
    func load() -> SortVariation? {
        guard let rawValue = userDefaults.string(forKey: key) else { return nil }
        return SortVariation(rawValue: rawValue)
    }
}
