//
//  MockNFTService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 12.02.2026.
//

final class MockNFTService: NFTServiceProtocol {
    func fetchNFTForCart() async throws -> [CartNFTModel] {
        var nftArray: [CartNFTModel] = []
        for i in 1...3 {
            let rangePrice =  Double.random(in: 0.1...5.0).roundedTwoDecimals
            let rangeStars = Int.random(in: 1...5)
            
            nftArray.append(CartNFTModel(imageName:"mockNFT", nftName: "NFT" + " \(i)", countStars: rangeStars, price: rangePrice))
        }
        return nftArray
    }
}
