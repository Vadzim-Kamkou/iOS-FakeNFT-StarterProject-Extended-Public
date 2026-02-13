//
//  CatalogCollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//
import SwiftUI

struct CatalogCollectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedNft: CollectionItem?
    @State private var showAuthorPage = false
    
    
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
                .padding(.bottom, 8)
            
            
            VStack (alignment: .leading, spacing: 8) {
                Text(catalog.title)
                    .font(.body22Bold)
                
                
                HStack {
                    Text("Автор коллекции:")
                        .font(.regular13)
                    Text("\(catalog.autor)")
                        .font(.regular15)
                        .foregroundColor(.blueUniversal)
                        .onTapGesture {
                            showAuthorPage = true
                        }
                        .fullScreenCover(isPresented: $showAuthorPage) {
                            NavigationStack {
                                WebView(url: URL(string: "https://practicum.yandex.com/")!)
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
                }
                Text("\(catalog.description)")
                    .font(.regular13)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(catalog.collection) { item in
                    CatalogCollectionNftView(collectionItem: item)
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
                    Image(.backButtonChevron)
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
    CatalogCollectionView(catalog: mockCatalogs[0])
}
