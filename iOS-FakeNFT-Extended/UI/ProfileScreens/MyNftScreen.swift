//
//  MyNFT.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/11/26.
//
import SwiftUI

struct MyNftScreen: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(ServicesAssembly.self) private var services
    @State private var showSortDialog = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.allNftsList.isEmpty {
                    VStack(spacing: 20) {
                        
                        
                        Text("У вас ещё нет NFT")
                            .font(.bodyBold)
                            .foregroundColor(.primary)
                            
                            
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.sortedMyNfts) { nft in
                                MyNftCell(nft: nft)
                            }
                        }
                        .padding(.trailing, 39)
                        .padding(.top, 20)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
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
                    Text("Мои NFT")
                        .font(.bodyBold)
                        .foregroundColor(.primary)
                        .opacity(viewModel.allNftsList.isEmpty ? 0 : 1)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.allNftsList.isEmpty {
                        Button {
                            showSortDialog = true
                        } label: {
                            Image(.sortIcon)
                                .renderingMode(.template)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            // 1. Загружаем профиль, чтобы получить ID всех NFT
            await viewModel.loadProfile(using: services.profileService, id: "1")
            // 2. Загружаем данные для каждого NFT по их ID
            await viewModel.loadMyNfts(using: services.nftService)
        }
        .confirmationDialog("Сортировка",
                            isPresented: $showSortDialog,
                            titleVisibility: .visible) {
            Button("По цене") {
                viewModel.myNftSortOption = .price
            }
            Button("По рейтингу") {
                viewModel.myNftSortOption = .rating
            }
            Button("По названию") {
                viewModel.myNftSortOption = .name
            }
            Button("Закрыть", role: .cancel) { }
        }
    }
}
