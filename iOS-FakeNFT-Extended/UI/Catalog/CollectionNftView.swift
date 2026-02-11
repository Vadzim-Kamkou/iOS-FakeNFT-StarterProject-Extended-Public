//
//  CollectionNftView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI


struct CollectionNftView: View {
    
    let collectionItem: CollectionItem
    @State private var isFavouriteActive: Bool
    @State private var isInCartActive: Bool
    
    init(collectionItem: CollectionItem) {
        self.collectionItem = collectionItem
        _isFavouriteActive = State(initialValue: collectionItem.isFavourite)
        _isInCartActive = State(initialValue: collectionItem.isInCart)
        
    }
    
    private var favouriteImage: Image {
        isFavouriteActive ? Image(.favouritesIcon) : Image(.favouritesIconNo)
    }
    
    var rating: Text {
        switch collectionItem.ratings {
        case 1:
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive))
        case 2:
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive))
        case 3:
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive))
        case 4:
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarNoActive))
        case 5:
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive)) +
            Text(Image(.ratingStarActive))
        default:
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive)) +
            Text(Image(.ratingStarNoActive))
        }
    }
    
    
    private var cartImage: Image {
        isInCartActive ? Image(.cartNoActive) : Image(.cartActive)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(collectionItem.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    Button {
                        isFavouriteActive.toggle()
                    } label: {
                        favouriteImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .offset(x: 33, y: -33)
                    }
                        .buttonStyle(.plain)
                )
            rating
            HStack {
                VStack (alignment: .leading, spacing: 4) {
                    Text("\(collectionItem.title)")
                        .font(.bodyBold)
                    Text("\(collectionItem.price) \(collectionItem.currency)")
                        .font(.medium10)
                }
                Spacer()
                Button {
                    isInCartActive.toggle()
                } label: {
                    cartImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                
                
                
                
            }
        }
        .frame(width: 108)
    }
}

#Preview {
    CollectionNftView(collectionItem: mockCollection[0])
}
