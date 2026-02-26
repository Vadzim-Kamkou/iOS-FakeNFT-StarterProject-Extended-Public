//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 6.02.26.
//

import Foundation
import SwiftUI

@MainActor
final class CatalogViewModel: ObservableObject {
    
    @Published var collections: [Collection] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    @AppStorage("catalogSortType") private var sortTypeRawValue: String = SortType.byCount.rawValue
    
    var sortType: SortType {
        get { SortType(rawValue: sortTypeRawValue) ?? .byCount }
        set { sortTypeRawValue = newValue.rawValue }
    }
    
    private let collectionService: CollectionService
    private var currentPage = 0
    private let pageSize = 10
    private var canLoadMore = true
    
    enum SortType: String, CaseIterable {
        case byName = "byName"
        case byCount = "byCount"
        
        var title: String {
            switch self {
            case .byName: return "По названию"
            case .byCount: return "По количеству NFT"
            }
        }
    }
    
    init(collectionService: CollectionService) {
        self.collectionService = collectionService
    }
    
    func loadInitialCollections() async {
        guard !isLoading else { return }
        
        isLoading = true
        currentPage = 0
        canLoadMore = true
        errorMessage = nil
        
        do {
            let newCollections = try await collectionService.loadCollections(
                page: currentPage,
                size: pageSize
            )
            collections = newCollections
            applySorting()
            canLoadMore = newCollections.count == pageSize
        } catch {
            errorMessage = "Ошибка загрузки коллекций"
            print("Error loading collections: \(error)")
        }
        
        isLoading = false
    }
    
    func loadMoreCollections() async {
        guard !isLoadingMore && canLoadMore && !isLoading else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        do {
            let newCollections = try await collectionService.loadCollections(
                page: currentPage,
                size: pageSize
            )
            collections.append(contentsOf: newCollections)
            applySorting()
            canLoadMore = newCollections.count == pageSize
        } catch {
            errorMessage = "Ошибка загрузки дополнительных коллекций"
            print("Error loading more collections: \(error)")
            currentPage -= 1
        }
        
        isLoadingMore = false
    }
    
    func changeSortType(_ newType: SortType) {
        sortType = newType
        applySorting()
    }
 
    private func applySorting() {
        switch sortType {
        case .byCount:
            collections.sort { $0.uniqueNftsCount > $1.uniqueNftsCount }
        case .byName:
            collections.sort { $0.name < $1.name }
        }
    }
}
