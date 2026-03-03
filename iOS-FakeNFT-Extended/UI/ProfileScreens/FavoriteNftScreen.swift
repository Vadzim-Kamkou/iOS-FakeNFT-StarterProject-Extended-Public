//
//  FavoriteNftScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/11/26.
//
import SwiftUI

struct FavoriteNftScreen: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.favoriteNfts.isEmpty {
                    VStack() {
                        
                        Text("У Вас ещё нет избранных NFT")
                            .font(.bodyBold)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 7),
                                GridItem(.flexible())
                            ],
                            spacing: 20
                        ) {
                            ForEach(viewModel.favoriteNfts) { nft in
                                FavoriteNftCell(nft: nft)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.bodyBold)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Избранные NFT")
                        .font(.bodyBold)
                        .foregroundColor(.primary)
                        .opacity(viewModel.favoriteNfts.isEmpty ? 0 : 1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.loadFavoriteNfts(using: services.nftService)
        }
    }
}
