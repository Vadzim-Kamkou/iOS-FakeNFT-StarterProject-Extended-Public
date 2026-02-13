//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//

import SwiftUI

struct DeleteConfirmationView: View {
    let viewModel: CartNFTViewModel
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial.opacity(0.99))
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(.mockNFT)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 108, maxHeight: 108)
                Text("Are you sure you want to delete this item from your trash?")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 180)
                    .frame(maxWidth: .infinity)
                HStack(spacing: 8) {
                    ActionButton(title: "Remove", isBoldTextButton: false, cornerRadius: 12, textColor: .red) {
                        viewModel.confirmDeletion(true)
                    }
                    ActionButton(title: "Cancel", isBoldTextButton: false, cornerRadius: 12, textColor: .white) {
                        viewModel.confirmDeletion(false)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 57)
            }
        }
        .presentationBackground(.clear)
        
    }
}

#Preview {
    @Previewable @State var viewModel = CartNFTViewModel(nftService: MockNFTService())
    
    ZStack {
        Color.clear
            .background(.white)
        DeleteConfirmationView(viewModel: viewModel)
    }
}
