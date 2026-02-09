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
        List(viewModel.catalogs) { catalog in
            CatalogRowView(catalog: catalog)
                .listRowSeparator(.hidden)
                .contentShape(Rectangle())
                .onTapGesture { selectedItem = catalog }
        }
        .listSectionSpacing(0)
        .listStyle(.plain)
        .sheet(item: $selectedItem) { item in
            Text("\(item.title)")
            //NftDetailBridgeView()
        }
    }
    
    
    func showNft() {
        //  presentingNft = true
    }
    
}

#Preview {
    CatalogListView()
//        .environment(
//            ServicesAssembly(
//                networkClient: DefaultNetworkClient(),
//                nftStorage: NftStorageImpl()
//            )
//        )
}
