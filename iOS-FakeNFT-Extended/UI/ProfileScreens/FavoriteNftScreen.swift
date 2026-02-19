//
//  FavoriteNftScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/11/26.
//
import SwiftUI

struct FavoriteNftScreen: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
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
                                    .environmentObject(viewModel)
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let viewModel = ProfileViewModel()
    
    FavoriteNftScreen()
        .environmentObject(viewModel)
}

#Preview("Пустой список") {
    let viewModel = ProfileViewModel()
    viewModel.allNfts = []
    
    return FavoriteNftScreen()
        .environmentObject(viewModel)
}
