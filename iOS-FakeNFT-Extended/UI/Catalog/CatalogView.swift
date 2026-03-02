//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI

struct CatalogView: View {
    
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var viewModel: CatalogViewModel?
    @State private var showSortMenu = false
    
    var body: some View {
        NavigationStack {
            if let viewModel = viewModel {
                CatalogListView(viewModel: viewModel)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button(action: {
                                showSortMenu = true
                            }) {
                                Image(.iconSort)
                            }
                        }
                    }
                    .confirmationDialog(
                        "Сортировка",
                        isPresented: $showSortMenu,
                        titleVisibility: .visible
                    ) {
                        ForEach(CatalogViewModel.SortType.allCases, id: \.self) { sortType in
                            Button(sortType.title) {
                                viewModel.changeSortType(sortType)
                            }
                        }
                        Button("Закрыть", role: .cancel) {}
                    }
            } else {
                ProgressView()
                    .onAppear {
                        viewModel = CatalogViewModel(collectionService: servicesAssembly.collectionService)
                    }
            }
        }
    }
}

#Preview {
    CatalogView()
        .environment(ServicesAssembly(networkClient: DefaultNetworkClient(),
                                      nftStorage: NftStorageImpl(),
                                      paymentStorage: PaymentStorageImpl(),
                                      cartStorage: CartStorageImpl()
        ))
}
