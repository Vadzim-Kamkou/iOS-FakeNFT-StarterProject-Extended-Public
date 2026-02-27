//
//  PaymentTypeCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 13.02.2026.
//

import SwiftUI
import Kingfisher

struct PaymentTypeCell:View {
    
    let element:PaymentModel
    var border: Bool
    var body: some View {
        
        HStack(spacing: 4) {
            KFImage(URL(string: element.image))
                .placeholder {
                    ProgressView()
                        .frame(width: 36, height: 36)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.leading, 12)
                .padding(.vertical, 5)
            VStack(alignment: .leading, spacing: 0) {
                Text(element.title)
                    .font(.caption2)
                    .foregroundStyle(.text)
                Text(element.name)
                    .font(.caption2)
                    .foregroundStyle(.greenUniversal)
            }
            Spacer()
        }
        .background(.lightGrey)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(border ? .text : .clear, lineWidth: 1)
        )
    }
}

#Preview {
    let border = true
    
    ZStack {
        Color.backgroundForView.ignoresSafeArea()
        PaymentTypeCell(element:PaymentModel(id: "SOL", title: "Solana", name: "SOL", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Solana_(SOL).png"), border: border)
            .padding(16)
    }
}
