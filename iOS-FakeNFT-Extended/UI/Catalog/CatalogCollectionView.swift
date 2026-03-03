//
//  CatalogCollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI

struct CatalogCollectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @StateObject private var viewModel: CatalogCollectionViewModel
    @State private var selectedNft: Nft?
    @State private var showAuthorPage = false
    
    let collection: Collection
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    init(collection: Collection, nftService: NftService) {
        self.collection = collection
        _viewModel = StateObject(wrappedValue: CatalogCollectionViewModel(
            collection: collection,
            nftService: nftService
        ))
    }
    
    var body: some View {
        ScrollView {
            catalogCollectionCoverImage
            catalogCollectionDescription
            
            if viewModel.isLoading {
                ProgressView("Загрузка NFT...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                    Button("Повторить") {
                        Task {
                            await viewModel.loadNfts()
                        }
                    }
                }
                .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.nfts) { nft in
                        CatalogCollectionNftView(nft: nft, servicesAssembly: servicesAssembly)
                            .onTapGesture {
                                selectedNft = nft
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(.backButtonChevron)
                        .tint(.black)
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(item: $selectedNft) { nft in
            NftDetailBridgeView(nftId: nft.id)
        }
        .fullScreenCover(isPresented: $showAuthorPage) {
            authorWebView
        }
        .task {
            
            await viewModel.loadNfts()
            await viewModel.loadFavoritesIfNeeded(profileService: servicesAssembly.profileService)
            await viewModel.loadCartIfNeeded(cartService: servicesAssembly.cartService)

        }
    }
    
    private var catalogCollectionCoverImage: some View {
        AsyncImage(url: collection.coverURL) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 310)
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
            case .failure:
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 310)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(RoundedBottomCorners(radius: 12))
        .padding(.bottom, 8)
    }
    
    private var catalogCollectionDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(collection.name)
                .font(.body22Bold)
            
            HStack {
                Text("Автор коллекции:")
                    .font(.regular13)
                Text(collection.author)
                    .font(.regular15)
                    .foregroundColor(.blueUniversal)
                    .onTapGesture {
                        showAuthorPage = true
                    }
            }
            Text(collection.description)
                .font(.regular13)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
    
    private var authorWebView: some View {
        return NavigationStack {
            WebView(url: getFallbackURL())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showAuthorPage = false
                        } label: {
                            Image(.backButtonChevron)
                                .tint(.black)
                        }
                    }
                }
        }
    }
    
    private func getFallbackURL() -> URL {
        if let url = URL(string: collection.website),
           !collection.website.contains("fakenfts.org") {
            return url
        }
        return URL(string: "https://practicum.yandex.com/")!
    }
}

struct RoundedBottomCorners: Shape {
    var radius: CGFloat = 12
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        CatalogCollectionView(
            collection: Collection(
                id: "d4fea6b6-91f1-45ce-9745-55431e69ef5c",
                name: "Test Collection",
                cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
                description: "Test description for preview",
                author: "Test Author",
                website: "https://practicum.yandex.com/",
                nfts: ["c14cf3bc-7470-4eec-8a42-5eaa65f4053c"],
                createdAt: "2023-11-21T15:21:36.683Z[GMT]"
            ),
            nftService: NftServiceImpl(
                networkClient: DefaultNetworkClient(),
                storage: NftStorageImpl()
            )
        )
    }
}
