//
//  CatalogListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
}

struct CatalogListView: View {
    
//    @Environment(ServicesAssembly.self) var servicesAssembly
//    @State private var presentingNft = false
//    @State private var selectedNft: Nft?

    @State private var selectedItem: CatalogItem?
    @StateObject private var viewModel = CatalogViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.catalogs) { catalog in
                    NavigationLink {
                        CollectionView()
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
    
//        .sheet(item: $selectedItem) { item in
//            Text("\(item.title)")
//            //NftDetailBridgeView()
//        }
    
 
    func showNft() {
        //  presentingNft = true
    }
    
}

#Preview {
    NavigationStack {
        CatalogListView()
    }
    .buttonStyle(.plain)
//        .environment(
//            ServicesAssembly(
//                networkClient: DefaultNetworkClient(),
//                nftStorage: NftStorageImpl()
//            )
//        )
}
