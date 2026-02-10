//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//
import SwiftUI

struct CollectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedNft: CollectionItem?
    
    let catalog: CatalogItem
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            Image(catalog.imageName)
                .resizable()
                .scaledToFit()
                .clipped()
                .clipShape(RoundedBottomCorners(radius: 12))
            
            VStack (alignment: .leading, spacing: 4) {
                Text(catalog.title)
                    .font(.body22Bold)
                
                HStack {
                    Text("Автор коллекции:")
                        .font(.regular13)
                    Text("\(catalog.autor)")
                        .font(.regular15)
                        .foregroundColor(.blueUniversal)
                }
                Text("\(catalog.description)")
                    .font(.regular13)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(catalog.collection) { item in
                    CollectionNftView(collectionItem: item)
                        .onTapGesture {
                            selectedNft = item
                        }
                }
            }
            .padding(.horizontal, 16)
            
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(item: $selectedNft) { item in
            NftDetailBridgeView()
        }
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
    CollectionView(catalog: mockCatalogs[0])
}
