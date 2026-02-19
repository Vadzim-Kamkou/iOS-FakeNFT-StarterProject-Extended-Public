//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/10/26.
//

import Foundation
import Combine
import ProgressHUD


final class ProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var websiteDisplay: String
    @Published var avatarURL: String
    @Published var websiteFullURL: String = "https://practicum.yandex.ru/ios-developer/?from=catalog"
    
    @Published var myNftCount: Int
    @Published var favoriteNftCount: Int
    
    @Published var allNfts: [NftId]
    @Published var nftIds: [String]
    @Published var likeIds: [String]
    @Published var favoriteNfts: [NftId] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        self.name = ""
        self.description = ""
        self.websiteDisplay = ""
        self.avatarURL = ""
        self.allNfts = []
        self.nftIds = []
        self.likeIds = []
        self.myNftCount = 0
        self.favoriteNftCount = 0
    }
    
    @MainActor
    func toggleLike(for nftId: UUID, using service: ProfileService) async {
        // 1. Находим NFT для лайка/дизлайка в любом из списков
        guard let nft = (allNfts.first { $0.id == nftId } ?? favoriteNfts.first { $0.id == nftId }) else {
            print("Error: NFT with id \(nftId) not found to toggle like.")
            return
        }
        guard let remoteId = nft.remoteId else { return }

        // 2. Определяем, лайкаем мы или дизлайкаем
        let isCurrentlyLiked = self.likeIds.contains(remoteId)

        ProgressHUD.animate()

        // 3. Готовим новый список лайков для отправки на сервер
        let newLikes: [String]
        if isCurrentlyLiked {
            newLikes = self.likeIds.filter { $0 != remoteId }
        } else {
            newLikes = self.likeIds + [remoteId]
        }

        do {
            // 4. Отправляем запрос на сервер
            let profile = try await service.updateProfile(
                id: "1",
                name: nil,
                avatar: nil,
                description: nil,
                website: nil,
                nfts: nil,
                likes: newLikes
            )

            // 5. Обновляем локальное состояние из ответа сервера
            self.likeIds = profile.likeIds

            // Обновляем статус isLiked в общем списке NFT
            if let index = allNfts.firstIndex(where: { $0.id == nftId }) {
                allNfts[index].isLiked = !isCurrentlyLiked
            }

            // Обновляем список избранных NFT
            if isCurrentlyLiked {
                favoriteNfts.removeAll { $0.remoteId == remoteId }
            } else {
                var likedNft = nft
                likedNft.isLiked = true
                favoriteNfts.append(likedNft)
            }
            self.favoriteNftCount = self.favoriteNfts.count

            ProgressHUD.dismiss()
        } catch {
            ProgressHUD.dismiss()
            self.errorMessage = "Не удалось изменить лайк"
            print("Failed to toggle like for NFT: \(error)")
        }
    }
    
    var allNftsList: [NftId] {
        allNfts
    }
        
    @MainActor
    func loadProfile(using service: ProfileService, id: String) async {
        isLoading = true
        errorMessage = nil
        ProgressHUD.animate()
        defer {
            isLoading = false
            ProgressHUD.dismiss()
        }
        
        do {
            let profile = try await service.loadProfile(id: id)
            name = profile.name
            description = profile.description
            websiteDisplay = profile.site
            avatarURL = profile.urlString
            websiteFullURL = profile.site

            // API возвращает ID в виде одной строки ["1,2,3"], парсим их в массив
            nftIds = profile.nftIds.flatMap { $0.split(separator: ",") }.map { String($0).trimmingCharacters(in: .whitespaces) }
            likeIds = profile.likeIds.flatMap { $0.split(separator: ",") }.map { String($0).trimmingCharacters(in: .whitespaces) }

            myNftCount = nftIds.count
            favoriteNftCount = likeIds.count
        } catch {
            print("Profile load error:", error)
        }
    }

    @MainActor
    func loadMyNfts(using nftService: NftService) async {
        isLoading = true
        ProgressHUD.animate()
        defer {
            isLoading = false
            ProgressHUD.dismiss()
        }
        guard !nftIds.isEmpty else {
            allNfts = []
            return
        }

        // Используем TaskGroup для параллельной загрузки всех NFT
        allNfts = await withTaskGroup(of: NftId?.self, returning: [NftId].self) { group in
            for id in nftIds {
                group.addTask {
                    // Безопасно пытаемся загрузить каждый NFT. Если один упадет, процесс не прервется.
                    guard let nft = try? await nftService.loadNft(id: id) else { return nil }
                    return NftId(
                        remoteId: nft.id,
                        name: nft.name,
                        logoUrlString: nft.images.first?.absoluteString ?? "",
                        price: String(format: "%.2f", nft.price),
                        rating: nft.rating,
                        creater: nft.author,
                        isLiked: self.likeIds.contains(nft.id) // Проверяем, лайкнут ли этот NFT
                    )
                }
            }
            
            var loaded: [NftId] = []
            for await nft in group {
                if let nft { loaded.append(nft) }
            }
            return loaded
        }
    }

    @MainActor
    func loadFavoriteNfts(using nftService: NftService) async {
        isLoading = true
        ProgressHUD.animate()
        defer {
            isLoading = false
            ProgressHUD.dismiss()
        }
        // чистим старые данные
        favoriteNfts = []

        guard !likeIds.isEmpty else {
            favoriteNftCount = 0
            return
        }

        // Используем TaskGroup для параллельной загрузки
        favoriteNfts = await withTaskGroup(of: NftId?.self, returning: [NftId].self) { group in
            for id in likeIds {
                group.addTask {
                    guard let nft = try? await nftService.loadNft(id: id) else { return nil }
                    return NftId(
                        remoteId: nft.id,
                        name: nft.name,
                        logoUrlString: nft.images.first?.absoluteString ?? "",
                        price: String(format: "%.2f", nft.price),
                        rating: nft.rating,
                        creater: nft.author,
                        isLiked: true // Это избранное, значит лайк стоит
                    )
                }
            }
            
            var loaded: [NftId] = []
            for await nft in group {
                if let nft { loaded.append(nft) }
            }
            return loaded
        }
        favoriteNftCount = favoriteNfts.count
    }

    @MainActor
    func updateProfile(using service: ProfileService,
                       id: String,
                       name: String?,
                       description: String?,
                       website: String?,
                       avatarURL: String?) async {
        isLoading = true
        errorMessage = nil
        ProgressHUD.animate()
        defer {
            isLoading = false
            ProgressHUD.dismiss()
        }

        do {
            let profile = try await service.updateProfile(
                id: id,
                name: name,
                avatar: avatarURL,
                description: description,
                website: website,
                nfts: nil,
                likes: self.likeIds
            )
            self.name = profile.name
            self.description = profile.description
            self.websiteDisplay = profile.site
            self.avatarURL = profile.urlString
            self.websiteFullURL = profile.site
            self.allNfts = profile.allNfts
            self.nftIds = profile.nftIds
            self.likeIds = profile.likeIds
            self.myNftCount = nftIds.count
            self.favoriteNftCount = likeIds.count
        } catch {
            errorMessage = "Ошибка обновления профиля"
            print("Profile update error:", error)
        }
    }
}
