//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/10/26.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var websiteDisplay: String
    @Published var avatarURL: String
    @Published var websiteFullURL: String = "https://practicum.yandex.ru/ios-developer/?from=catalog"
    
    @Published var myNftCount: Int
    @Published var favoriteNftCount: Int
    
    @Published var allNfts: [NftId]
    
    init() {
        let mock = ProfileStruct.mock
        self.name = mock.name
        self.description = mock.description
        self.websiteDisplay = mock.site
        self.avatarURL = mock.url
        self.allNfts = []
        self.myNftCount = 0
        self.favoriteNftCount = 0
        self.allNfts = NftId.mockAllNfts
        self.myNftCount = self.allNfts.count
        self.favoriteNftCount = self.allNfts.filter { $0.isLiked }.count
    }
    
    func toggleLike(for nftId: UUID) {
        if let index = allNfts.firstIndex(where: { $0.id == nftId }) {
            allNfts[index].isLiked.toggle()
            favoriteNftCount = allNfts.filter { $0.isLiked }.count
        }
    }
    
    var favoriteNfts: [NftId] {
        allNfts.filter { $0.isLiked }
    }
    
    var allNftsList: [NftId] {
        allNfts
    }
    
    func saveChanges(name: String, description: String, website: String, avatarURL: String) {
        self.name = name
        self.description = description
        self.websiteDisplay = website
        self.avatarURL = avatarURL
        self.myNftCount = allNfts.count
        self.favoriteNftCount = allNfts.filter { $0.isLiked }.count
    }
}
