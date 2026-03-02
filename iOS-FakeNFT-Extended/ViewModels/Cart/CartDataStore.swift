//
//  CartDataStore.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 19.02.2026.
//
import Observation
import Combine

@MainActor
@Observable final class CartDataStore {
    
    private var actualCartArray: [CartNFTModel] = []
    private let needCleanCartSubject = CurrentValueSubject<Bool, Never>(false)
    
    var needCleanCartPublisher: AnyPublisher<Bool, Never> {
        needCleanCartSubject.eraseToAnyPublisher()
    }
    
    func update(nftArray: [CartNFTModel]) {
        actualCartArray = nftArray
    }
    
    func loadActualNFTArray() -> [String] {
        let actualArrayConvertToString = actualCartArray.map { $0.id }
        return actualArrayConvertToString
    }
    
    func needToUpdateUpdateNFTArray(status: Bool) {
        needCleanCartSubject.send(status)
    }
}
