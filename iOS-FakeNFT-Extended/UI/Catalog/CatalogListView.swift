//
//  CatalogListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 9.02.26.
//

import SwiftUI

struct CatalogListView: View {
    
    @ObservedObject var viewModel: CatalogViewModel
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var selectedCollection: Collection?
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.collections.isEmpty {
                ProgressView("Загрузка коллекций...")
            } else if let error = viewModel.errorMessage, viewModel.collections.isEmpty {
                VStack(spacing: 16) {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Повторить") {
                        Task {
                            await viewModel.loadInitialCollections()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                List {
                    ForEach(viewModel.collections) { collection in
                        CatalogRowView(collection: collection)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCollection = collection
                            }
                            .listRowSeparator(.hidden)
                            .onAppear {
                                if collection.id == viewModel.collections.last?.id {
                                    Task {
                                        await viewModel.loadMoreCollections()
                                    }
                                }
                            }
                    }
                    
                    if viewModel.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView()
                                .frame(width: 30, height: 30)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listSectionSpacing(0)
                .listStyle(.plain)
                .navigationDestination(item: $selectedCollection) { collection in
                    CatalogCollectionView(
                        collection: collection,
                        nftService: servicesAssembly.nftService
                    )
                }
                .refreshable {
                    await viewModel.loadInitialCollections()
                }
            }
        }
        .task {
            if viewModel.collections.isEmpty {
                await viewModel.loadInitialCollections()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CatalogListView(viewModel: CatalogViewModel(
            collectionService: CollectionServiceImpl(networkClient: DefaultNetworkClient())
        ))
    }
    .environment(ServicesAssembly(networkClient: DefaultNetworkClient(),
                                  nftStorage: NftStorageImpl(),
                                  paymentStorage: PaymentStorageImpl(),
                                  cartStorage: CartStorageImpl()
    ))
}
