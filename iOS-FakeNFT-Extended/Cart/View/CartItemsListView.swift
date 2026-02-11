//
//  CartItemsListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//
import SwiftUI

struct CartItemsListView: View {
    let nftsMocks: [Int]
    var body: some View {
        List() {
            ForEach(1..<5) { _ in // временно заменить на прямую с массивом  NFT
                Section {
                    CartCellView()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(16)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.clear
            .background(.backgroundForView)
        CartItemsListView(nftsMocks: [1,2,3,4])
    }
}
