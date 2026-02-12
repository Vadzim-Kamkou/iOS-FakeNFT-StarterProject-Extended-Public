//
//  Extension+Double.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 12.02.2026.
//

extension Double {
    
    var roundedTwoDecimals: Double {
        (self * 100).rounded() / 100
    }
    
    func changeMark() -> String {
        let newMark = String(self).split(separator: ".")
        return newMark.joined(separator: ",")
    }
}
