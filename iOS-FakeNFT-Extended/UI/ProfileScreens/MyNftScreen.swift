//
//  MyNFT.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/11/26.
//
import SwiftUI

struct MyNftScreen: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(ServicesAssembly.self) private var services
    @State private var sortOption: SortOption = .none
    @State private var showSortDialog = false
    @Environment(\.dismiss) private var dismiss
    
    private enum SortOption {
        case none, price, rating, name
    }
    
    private func doublePrice(from string: String) -> Double {
        Double(string.replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
    
    private var sortedNfts: [NftId] {
        let base = viewModel.allNftsList
        
        switch sortOption {
        case .none:
            return base
        case .price:
            return base.sorted { (nft1: NftId, nft2: NftId) -> Bool in
                let price1 = doublePrice(from: nft1.price)
                let price2 = doublePrice(from: nft2.price)
                if price1 != price2 {
                    return price1 > price2
                }
                return nft1.name < nft2.name
            }
        case .rating:
            return base.sorted { (nft1: NftId, nft2: NftId) -> Bool in
                if nft1.rating != nft2.rating {
                    return nft1.rating > nft2.rating
                }
                return nft1.name < nft2.name
            }
        case .name:
            return base.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.allNftsList.isEmpty {
                    // 👇 ТОЧНО ПО ЦЕНТРУ ЭКРАНА
                    VStack(spacing: 20) {
                        
                        
                        Text("У вас ещё нет NFT")
                            .font(.bodyBold)
                            .foregroundColor(.primary)
                            
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(sortedNfts) { nft in
                                MyNftCell(nft: nft)
                                    .environmentObject(viewModel)
                            }
                        }
                        .padding(.trailing, 39)
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
                    Text("Мои NFT")
                        .font(.bodyBold)
                        .foregroundColor(.primary)
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
                sortOption = .price
            }
            Button("По рейтингу") {
                sortOption = .rating
            }
            Button("По названию") {
                sortOption = .name
            }
            Button("Закрыть", role: .cancel) { }
        }
    }
}

#Preview {
    let viewModel = ProfileViewModel()
    let networkClient = DefaultNetworkClient()
    let nftStorage = NftStorageImpl()
    
    MyNftScreen()
        .environmentObject(viewModel)
        .environment(ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage
        ))
}

#Preview("Пустой список") {
    let viewModel: ProfileViewModel = {
        let vm = ProfileViewModel()
        vm.allNfts = []
        return vm
    }()
    let networkClient = DefaultNetworkClient()
    let nftStorage = NftStorageImpl()
    
    MyNftScreen()
        .environmentObject(viewModel)
        .environment(ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage
        ))
}
