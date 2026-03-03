//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/10/26.
//

import Foundation
import ProgressHUD

enum SortOption {
    case none, price, rating, name
}

@Observable
final class ProfileViewModel {
    var name: String
    var description: String
    var websiteDisplay: String
    var avatarURL: String
    var websiteFullURL: String = "https://practicum.yandex.ru/ios-developer/?from=catalog"
    
    var myNftCount: Int
    var favoriteNftCount: Int
    
    var allNfts: [NftId]
    var nftIds: [String]
    var likeIds: [String]
    var favoriteNfts: [NftId] = []
    
    // MARK: - Edit Profile State
    var editName: String = ""
    var editDescription: String = ""
    var editWebsite: String = ""
    var editAvatar: String = ""
    
    // MARK: - My NFT Sort State
    var myNftSortOption: SortOption = .none
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    var allNftsList: [NftId] {
        allNfts
    }
    
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
    
    var sortedMyNfts: [NftId] {
        let base = allNfts
        
        switch myNftSortOption {
        case .none:
            return base
        case .price:
            return base.sorted {
                let price1 = doublePrice(from: $0.price)
                let price2 = doublePrice(from: $1.price)
                if price1 != price2 {
                    return price1 > price2
                }
                return $0.name < $1.name
            }
        case .rating:
            return base.sorted {
                if $0.rating != $1.rating {
                    return $0.rating > $1.rating
                }
                return $0.name < $1.name
            }
        case .name:
            return base.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    var hasChanges: Bool {
        editName != name ||
        editDescription != description ||
        editWebsite != websiteDisplay ||
        editAvatar != avatarURL
    }
    
    @MainActor
    func startEditing() {
        editName = name
        editDescription = description
        editWebsite = websiteDisplay
        editAvatar = avatarURL
    }
    
    @MainActor
    func saveEditingProfile(using service: ProfileService) async {
        let newName = editName != name ? editName : nil
        let newDescription = editDescription != description ? editDescription : nil
        let newWebsite = editWebsite != websiteDisplay ? editWebsite : nil
        let newAvatar = editAvatar != avatarURL ? editAvatar : nil
        
        await updateProfile(using: service, id: "1", name: newName, description: newDescription, website: newWebsite, avatarURL: newAvatar)
    }
    
    @MainActor
    func toggleLike(for nftId: UUID, using service: ProfileService) async {
        guard let nft = (allNfts.first { $0.id == nftId } ?? favoriteNfts.first { $0.id == nftId }) else {
            print("Error: NFT with id \(nftId) not found to toggle like.")
            return
        }
        guard let remoteId = nft.remoteId else { return }

        let isCurrentlyLiked = self.likeIds.contains(remoteId)

        ProgressHUD.animate()

        let newLikes: [String]
        if isCurrentlyLiked {
            newLikes = self.likeIds.filter { $0 != remoteId }
        } else {
            newLikes = self.likeIds + [remoteId]
        }

        do {
            let profile = try await service.updateLikes(newLikes)

            self.likeIds = profile.likes

            if let index = allNfts.firstIndex(where: { $0.id == nftId }) {
                allNfts[index].isLiked = !isCurrentlyLiked
            }
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

        allNfts = await withTaskGroup(of: NftId?.self, returning: [NftId].self) { group in
            for id in nftIds {
                group.addTask {
                    guard let nft = try? await nftService.loadNft(id: id) else { return nil }
                    return NftId(
                        remoteId: nft.id,
                        name: nft.name,
                        logoUrlString: nft.firstImageURL?.absoluteString ?? "",
                        price: String(format: "%.2f", nft.price),
                        rating: nft.rating,
                        creater: nft.author,
                        isLiked: self.likeIds.contains(nft.id)
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
        favoriteNfts = []

        guard !likeIds.isEmpty else {
            favoriteNftCount = 0
            return
        }

        favoriteNfts = await withTaskGroup(of: NftId?.self, returning: [NftId].self) { group in
            for id in likeIds {
                group.addTask {
                    guard let nft = try? await nftService.loadNft(id: id) else { return nil }
                    return NftId(
                        remoteId: nft.id,
                        name: nft.name,
                        logoUrlString: nft.firstImageURL?.absoluteString ?? "",
                        price: String(format: "%.2f", nft.price),
                        rating: nft.rating,
                        creater: nft.author,
                        isLiked: true
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
                nfts: self.nftIds,
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
    
    private func doublePrice(from string: String) -> Double {
        Double(string.replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
}
