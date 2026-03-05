//
//  CartCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 09.02.2026.
//

import SwiftUI
import Kingfisher

struct CartCellView:View {
    let viewModel: CartNFTViewModel
    let nft: CartNFTModel
    
    var body: some View {
        HStack(spacing: 0) {
            cartItemInfo
            Spacer()
            removeButton
        }
    }
    
    private var removeButton: some View {
        Image(.removeNFT)
            .resizable()
            .frame(width: 40, height: 40)
            .onTapGesture {
                viewModel.removeButtonTapped(for: nft)
            }
    }
    
    private var cartItemInfo: some View {
        HStack(spacing: 20) {
            KFImage(URL(string: nft.imageName))
                .placeholder {
                    ProgressView()
                        .frame(width: 108, height: 108)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 108, height: 108)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 12) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(nft.nftName))
                        .font(.bodyBold)
                        .foregroundStyle(.text)
                    starRatingView
                }
                
                VStack(alignment: .leading, spacing: 2)  {
                    Text("Price")
                        .font(.caption2)
                        .foregroundStyle(.text)
                    Text(nft.price.changeMark() + " ETH")
                        .font(.bodyBold)
                        .foregroundStyle(.text)
                }
            }
        }
        .frame(maxHeight: 108)
    }
    
    private var starRatingView: some View {
        HStack(spacing: 2) {
            ForEach(1..<6) { hasNFTStars in
                if hasNFTStars <= nft.countStars {
                    Image(.activeStar)
                        .resizable()
                        .frame(width: 12, height: 12)
                } else {
                    Image(.unActiveStar)
                        .resizable()
                        .frame(width: 12, height: 12)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.clear
            .background(.backgroundForView)
        CartCellView(viewModel: CartNFTViewModel(dataStore: CartDataStore(), cartService: ServicesAssembly.preview.cartService), nft: CartNFTModel(id: "", imageName:"https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Daisy/3.png", nftName: "NFT 1" , countStars: 5, price: 1.2))
            .padding(20)
    }
}
