//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//
import SwiftUI

struct CollectionView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    @Environment(\.dismiss) private var dismiss
    
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            Image(viewModel.catalogs[0].imageName)
                .resizable()
                .scaledToFit()
                .clipped()
                .clipShape(RoundedBottomCorners(radius: 12))
            
            VStack (alignment: .leading, spacing: 4) {
                Text(viewModel.catalogs[0].title)
                    .font(.body22Bold)
                
                HStack {
                    Text("Автор коллекции:")
                        .font(.regular13)
                    Text("\(viewModel.catalogs[0].autor)")
                        .font(.regular15)
                        .foregroundColor(.blueUniversal)
                }
                Text("\(viewModel.catalogs[0].description)")
                    .font(.regular13)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.catalogs[0].collection) { item in
                    CollectionNftView(collectionItem: item)
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
        
    }
    
}

#Preview {
    CollectionView()
}


struct RoundedBottomCorners: Shape {
    var radius: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
