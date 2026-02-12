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
    let nft: NftId
    
    var body: some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                if let url = URL(string: nft.logo) {
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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.toggleLike(for: nft.id)
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
                    .padding(.bottom, 4)
                
                StarRatingView(rating: nft.rating)
                    .padding(.bottom, 5)
                
                HStack {
                    Text(nft.price)
                    Text("ETH")
                }
                .font(.caption1)
            }
        }
    }
}
#Preview {
    
        FavoriteNftCell(nft:  NftId(
            name: "Lion",
            logo: "https://fivmagazine.com/wp-content/uploads/2022/04/nft-non-fungible-token-token-collection-bored-ape-yacht-club-example-army-monkey.jpg",
            price: "1.25",
            rating: 4,
            creater: "William Martinez",
            isLiked: true
        ) )
        
        
    
    
}

