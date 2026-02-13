//
//  CatalogRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 6.02.26.
//

import SwiftUI

struct CatalogRowView: View {
    
    let catalog: CatalogItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(catalog.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipped()
                .cornerRadius(12)
            Text("\(catalog.title) (\(catalog.count))")
                .font(.bodyBold)
        }
    }
}

#Preview {
    CatalogRowView(catalog: mockCatalogs[0])
}
