//
//  CartItemsListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//
import SwiftUI

struct CartItemsListView: View {
    let viewModel: CartNFTViewModel
    
    var body: some View {
        List() {
            ForEach(viewModel.NFTArray) { nft in
                Section {
                    CartCellView(viewModel: viewModel, nft: nft)
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
    @Previewable @State var viewModel = CartNFTViewModel(nftService: MockNFTService())
    
    ZStack {
        Color.clear
            .background(.backgroundForView)
        CartItemsListView(viewModel: viewModel)
    }
    .onAppear {
        Task {
            await viewModel.createMocksNFTArray()
        }
    }
}
