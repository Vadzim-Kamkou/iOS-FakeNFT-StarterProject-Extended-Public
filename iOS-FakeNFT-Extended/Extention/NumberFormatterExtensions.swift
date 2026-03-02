//
//  NumberFormatterExtensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 27.02.26.
//

import Foundation

extension NumberFormatter {
    static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
