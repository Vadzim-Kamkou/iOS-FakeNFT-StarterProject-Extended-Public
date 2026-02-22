//
//  SuccessPaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 13.02.2026.
//

import SwiftUI

struct SuccessPaymentView: View {
    
    @Binding var navigationPath: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 20) {
                Image(.catSuccess)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 13)
                Text("Success! Payment completed, congratulations on your purchase!")
                    .font(.headline3)
                    .foregroundStyle(.text)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 36)
            Spacer()
            ActionButton(title: "Return to cart",
                         verticalPadding: 19,
                         isBoldTextButton: true,
                         cornerRadius: 16,
                         textColor: .white) {
                navigationPath.removeAll()
            }
                         .padding([.horizontal,.bottom], 16)
        }
        .navigationBarHidden(true)
        .background(.backgroundForView)
    }
}

#Preview {
    @Previewable @State var navigationPath = [String]()
    SuccessPaymentView(navigationPath: $navigationPath)
}
