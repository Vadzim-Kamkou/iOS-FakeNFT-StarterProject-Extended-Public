//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//

import SwiftUI

struct PaymentMethodView: View {
    
    @Binding var path: [String]
    
    var body: some View {
        VStack {
            navigationBlockView
            Spacer()
        }
        .navigationBarHidden(true)
        .background(.backgroundForView)
    }
    
    var navigationBlockView: some View {
        Text("Select payment method")
            .font(.bodyBold)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.buttonBackground)
                }
                .padding(.leading, 9)
            }
            .padding(.vertical, 9)
    }
}

#Preview {
    @Previewable @State var path = [String]()
    
    ZStack {
        Color.backgroundForView
            .ignoresSafeArea()
        PaymentMethodView(path: $path)
    }
}
