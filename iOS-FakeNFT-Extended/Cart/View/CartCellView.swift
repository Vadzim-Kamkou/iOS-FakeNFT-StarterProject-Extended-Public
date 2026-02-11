//
//  CartCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 09.02.2026.
//

import SwiftUI

struct CartCellView:View {
    var body: some View {
        HStack(spacing: 0) {
            cartItemInfo
            Spacer()
            removeButton
        }
    }
    
    private var removeButton: some View {
        Button {
            print("Удаляем объект")
        } label: {
            Image(.removeNFT)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
    
    private var cartItemInfo: some View {
        HStack(spacing: 20) {
            Image(.mockNFT)
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("April") // take at VM
                        .font(.bodyBold)
                        .foregroundStyle(.text)
                    starRatingView
                }
                
                VStack(alignment: .leading, spacing: 2)  {
                    Text("Price")
                        .font(.caption2)
                        .foregroundStyle(.text)
                    Text("1,78 ETH")
                        .font(.bodyBold)
                        .foregroundStyle(.text)
                }
            }
        }
        .frame(maxHeight: 108)
    }
    
    private var starRatingView: some View {
        HStack {
            ForEach(0..<5) { _ in
                Image(.activeStar)
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.clear
            .background(.backgroundForView)
        CartCellView()
            .padding(20)
    }
}
