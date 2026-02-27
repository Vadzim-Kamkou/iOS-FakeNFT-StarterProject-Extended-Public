//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//

import SwiftUI
import Kingfisher

struct DeleteConfirmationView: View {
    let viewModel: CartNFTViewModel
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial.opacity(0.99))
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                KFImage(URL(string: viewModel.nftToRemoveImageName))
                    .placeholder {
                        ProgressView()
                            .frame(width: 108, height: 108)
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text("Are you sure you want to delete this item from your trash?")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 180)
                HStack(spacing: 8) {
                    ActionButton(title: "Remove", verticalPadding: 11, isBoldTextButton: false, cornerRadius: 12, textColor: .red) {
                        Task {
                            await viewModel.confirmDeletion(true)
                        }
                    }
                    ActionButton(title: "Back", verticalPadding: 11, isBoldTextButton: false, cornerRadius: 12, textColor: .white) {
                        Task {
                            await viewModel.confirmDeletion(false)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 57)
            }
        }
        .presentationBackground(.clear)
        
    }
}
