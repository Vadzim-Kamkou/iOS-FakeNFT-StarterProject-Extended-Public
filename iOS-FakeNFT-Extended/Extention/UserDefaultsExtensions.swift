//
//  UserDefaultsExtensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

extension Array where Element == String {
    func toJSONString() -> String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return string
    }
}

extension String {
    func toStringArray() -> [String] {
        guard let data = self.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: data)
        else {
            return []
        }
        return array
    }
}
