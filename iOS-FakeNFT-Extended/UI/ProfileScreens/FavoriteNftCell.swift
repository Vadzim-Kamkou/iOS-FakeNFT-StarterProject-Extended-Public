//
//  FavoriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/11/26.
//
import SwiftUI
import Kingfisher

struct FavoriteNftCell: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(ServicesAssembly.self) private var services
    let nft: NftId
    
    var body: some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                if let url = URL(string: nft.logoUrlString) {
                    KFImage(url)
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    Task {
                        await viewModel.toggleLike(for: nft.id, using: services.profileService)
                    }
                } label: {
                    Image(.likeActive) // Всегда активный лайк в избранном
                        .resizable()
                        .scaledToFill()
                        .frame(width: 21, height: 18)
                        .scaleEffect(1.1)
                }
                .offset(x: -5, y: 5)
            }
            
            VStack(alignment: .leading) {
                Text(nft.name)
                    .font(.bodyBold)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                
                StarRatingView(rating: nft.rating)
                    .padding(.bottom, 5)
                
                HStack {
                    Text(nft.price)
                    Text("ETH")
                }
                .font(.caption1)
                .lineLimit(1)
            }
        }
    }
}

#Preview {
    let networkClient = DefaultNetworkClient()
    let nftStorage = NftStorageImpl()
    
    FavoriteNftCell(nft:  NftId(
        name: "Lion",
        logoUrlString: "https://fivmagazine.com/wp-content/uploads/2022/04/nft-non-fungible-token-token-collection-bored-ape-yacht-club-example-army-monkey.jpg",
        price: "1.25",
        rating: 4,
        creater: "William Martinez",
        isLiked: true
    ) )
    .environmentObject(ProfileViewModel())
    .environment(ServicesAssembly(
        networkClient: networkClient,
        nftStorage: nftStorage
    ))
}
