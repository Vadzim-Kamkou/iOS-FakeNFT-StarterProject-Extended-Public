//
//  Extension+View.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//

import SwiftUI

extension View {
    func withDestination(path: Binding<[String]>) -> some View {
        self.navigationDestination(for: String.self) { screenType in
            if screenType == "Payment" {
                PaymentMethodView(path: path)
            }
        }
    }
}
