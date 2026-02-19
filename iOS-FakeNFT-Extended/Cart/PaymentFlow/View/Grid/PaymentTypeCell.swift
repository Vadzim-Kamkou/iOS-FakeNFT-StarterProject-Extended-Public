//
//  PaymentTypeCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 13.02.2026.
//

import SwiftUI

struct PaymentTypeCell:View {
    
    let element:PaymentType
    var border: Bool
    var body: some View {
        
        HStack(spacing: 4){
            Image(element.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .padding(.leading, 12)
                .padding(.vertical, 5)
            VStack(alignment: .leading, spacing: 0) {
                Text(element.type)
                    .font(.caption2)
                    .foregroundStyle(.text)
                Text(element.shotForm)
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
        PaymentTypeCell(element:PaymentType(crypto: Crypto.Bitcoin), border: border)
            .padding(16)
    }
}
