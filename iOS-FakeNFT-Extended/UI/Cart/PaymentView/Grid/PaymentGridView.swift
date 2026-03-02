//
//  PaymentGridView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 16.02.2026.
//

import SwiftUI

struct PaymentGridView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let viewModel: PaymentViewModel
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 7) {
            if let array = viewModel.cryptoPaymentArray  {
                ForEach(array, id: \.self) { element in
                    PaymentTypeCell(element:element, border: viewModel.selectedCrypto == element.id)
                        .onTapGesture {
                            viewModel.changeStateToSelectedCrypto(crypto: element)
                        }
                }
            }
        }
    }
}
