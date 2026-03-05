//
//  CatalogCollectionNftView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI

struct CatalogCollectionNftView: View {
    
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    let nft: Nft
    @StateObject private var viewModel: CatalogCollectionNftViewModel
    
    init(nft: Nft, servicesAssembly: ServicesAssembly) {
        self.nft = nft
        self._viewModel = StateObject(wrappedValue: CatalogCollectionNftViewModel(
            nft: nft,
            profileService: servicesAssembly.profileService,
            cartService: servicesAssembly.cartService
        ))
    }
    
    private var favouriteImage: Image {
        viewModel.isFavouriteActive ? Image(.favouritesIcon) : Image(.favouritesIconNo)
    }
    
    private var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(index <= nft.rating ? .ratingStarActive : .ratingStarNoActive)
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    private var cartImage: Image {
        viewModel.isInCartActive ? Image(.cartNoActive) : Image(.cartActive)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: nft.firstImageURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 108, height: 108)
                        .overlay {
                            ProgressView()
                                .frame(width: 30, height: 30)
                        }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 108, height: 108)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(12)
            .overlay(
                Button {
                    Task {
                        await viewModel.toggleFavourite()
                    }
                } label: {
                    favouriteImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .offset(x: 33, y: -33)
                }
                    .buttonStyle(.plain)
            )
            
            ratingView
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(nft.name)
                        .font(.bodyBold)
                        .lineLimit(1)
                    Text("\(NumberFormatter.priceFormatter.string(from: NSNumber(value: nft.price)) ?? "0.00") ETH")
                        .font(.medium10)
                }
                Spacer()
                Button {
                    Task {
                        await viewModel.toggleCart()
                    }
                } label: {
                    cartImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 108, height: 192)
//        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(),
                                            nftStorage: NftStorageImpl(),
                                            paymentStorage: PaymentStorageImpl(),
                                            cartStorage: CartStorageImpl()
    )
    
    CatalogCollectionNftView(
        nft: Nft(
            id: "test-id",
            name: "Test NFT",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png"],
            rating: 5,
            description: "Test description",
            price: 39.37,
            author: "Test Author",
            website: "https://test.com",
            createdAt: "2023-09-27T23:48:21.462Z[GMT]"
        ),
        servicesAssembly: servicesAssembly
    )
}
