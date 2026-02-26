//
//  CatalogRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 6.02.26.
//

import SwiftUI

struct CatalogRowView: View {
    
    let collection: Collection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: collection.coverURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 140)
                        .overlay {
                            ProgressView()
                                .frame(width: 30, height: 30)
                        }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 140)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(12)
            
            Text("\(collection.name) (\(collection.uniqueNftsCount))")
                .font(.bodyBold)
        }
    }
}

#Preview {
    CatalogRowView(collection: Collection(
        id: "test-id",
        name: "Test Collection",
        cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
        description: "Test description",
        author: "Test Author",
        website: "https://test.com",
        nfts: ["1", "2", "3"],
        createdAt: "2023-11-21T15:21:36.683Z[GMT]"
    ))
}
