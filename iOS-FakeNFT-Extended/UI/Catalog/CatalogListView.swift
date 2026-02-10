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
        List(viewModel.catalogs) { catalog in
            CatalogRowView(catalog: catalog)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedItem = catalog
                }
                .listRowSeparator(.hidden)
            
        }
        .listSectionSpacing(0)
        .listStyle(.plain)
        .navigationDestination(item: $selectedItem) { catalog in
            CollectionView(catalog: catalog)
        }
    }
}

#Preview {
    NavigationStack {
        CatalogListView()
    }
}
