//
//  FavoriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/11/26.
//
import SwiftUI
import Kingfisher

struct FavoriteNftCell: View {
    @Environment(ProfileViewModel.self) private var viewModel
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
                    Image(.likeActive)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 30)
                        .scaleEffect(1.1)
                }
                .offset(x: 4, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nft.name)
                    .font(.bodyBold)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                
                StarRatingView(rating: nft.rating)
                    .padding(.bottom, 5)
                
                Text(nft.price + " ETH")
                    .font(.caption1)
                    .lineLimit(1)
            }
        }
    }
}
