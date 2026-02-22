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
            ForEach(viewModel.cryptoPaymentArray, id: \.self) { element in
                PaymentTypeCell(element:PaymentType(crypto: element), border: viewModel.selectedCrypto == element)
                    .onTapGesture {
                        viewModel.changeStateToSelectedCrypto(crypto: element)
                    }
            }
        }
    }
}

#Preview {
    let viewModel = PaymentViewModel(dataStore: CartDataStore())
    
    ZStack {
        Color.backgroundForView.ignoresSafeArea()
        PaymentGridView(viewModel: viewModel)
            .padding(16)
    }
}
