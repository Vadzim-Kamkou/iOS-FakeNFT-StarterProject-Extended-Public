//
//  CatalogListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI

struct CatalogListView: View {
    
    @State private var selectedItem: CatalogItem?
    @StateObject private var viewModel = CatalogViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.catalogs) { catalog in
                    NavigationLink {
                        CollectionView(catalog: catalog)
                    } label: {
                        CatalogRowView(catalog: catalog)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    NavigationStack {
        CatalogListView()
    }
}
