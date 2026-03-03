//
//  MyNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/10/26.
//
//
import SwiftUI
import Kingfisher

struct MyNftCell: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(ServicesAssembly.self) private var services
    let nft: NftId
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                if let url = URL(string: nft.logoUrlString) {
                    KFImage(url)
                        .placeholder {
                            Image(.nft)
                                .resizable()
                                .scaledToFill()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(.nft)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    Task {
                        await viewModel.toggleLike(for: nft.id, using: services.profileService)
                    }
                } label: {
                    Image(nft.isLiked ? .likeActive : .likeInactive)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .scaleEffect(nft.isLiked ? 1.1 : 1.0)
                }
            }
            .padding(.trailing, 20)
            
            VStack(alignment: .leading) {
                Text(nft.name)
                    .font(.bodyBold)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                
                StarRatingView(rating: nft.rating)
                    .padding(.bottom, 5)
                
                HStack(spacing: 0) {
                    Text("от")
                        .font(.caption1)
                        .padding(.trailing, 4)
                    
                    Text(nft.creater)
                        .font(.caption2)
                        .lineLimit(1)
                }
            }
            .padding(.trailing, 39)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Цена")
                    .font(.caption2)
                
                HStack(spacing: 5) {
                    Text(nft.price)
                    Text("ETH")
                }
                .font(.bodyBold)
            }
            
            Spacer()
        }
        .padding(16)
    }
}
struct StarRatingView: View {
    let rating: Int
    
    private let maxStars = 5
    private let fullStar = Image(.starfill)
    private let halfStar = Image("star_half")
    private let emptyStar = Image(.starsFillout)
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxStars, id: \.self) { index in
                starImage(for: index)
                    
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    @ViewBuilder
    private func starImage(for index: Int) -> some View {
        let value = rating - Int(index)
        
        if value >= 1 {
            fullStar
        } else if value > 0 {
            halfStar
        } else {
            emptyStar
        }
    }
}
