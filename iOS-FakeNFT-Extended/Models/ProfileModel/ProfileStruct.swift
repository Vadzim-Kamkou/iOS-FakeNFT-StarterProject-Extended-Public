//
//  ProfileStruct.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/9/26.
//
import Foundation

struct ProfileStruct: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let site: String
    let urlString: String
    let allNfts: [NftId]
    let nftIds: [String]
    let likeIds: [String]
}

struct NftId: Hashable, Identifiable {
    let id = UUID()
    var remoteId: String? = nil
    let name: String
    let logoUrlString: String
    let price: String
    let rating: Int
    let creater: String
    var isLiked: Bool
}


extension NftId {
    static let mockAllNfts: [NftId] = [
       
        NftId(
            name: "Archie",
            logoUrlString: "https://example.com/archie.jpg",
            price: "1,78",
            rating: 5,
            creater: "Creator A",
            isLiked: true
        ),
        NftId(
            name: "Pixi",
            logoUrlString: "https://example.com/pixi.jpg",
            price: "1,78",
            rating: 4,
            creater: "Creator B",
            isLiked: true
        ),
        NftId(
            name: "Melissa",
            logoUrlString: "https://example.com/melissa.jpg",
            price: "1,78",
            rating: 5,
            creater: "Creator C",
            isLiked: true
        ),
        NftId(
            name: "April",
            logoUrlString: "https://fivmagazine.com/wp-content/uploads/2022/04/nft-non-fungible-token-token-collection-bored-ape-yacht-club-example-army-monkey.jpg",
            price: "1,78",
            rating: 4,
            creater: "Creator D",
            isLiked: true
        ),
        NftId(
            name: "Daisy",
            logoUrlString: "https://fivmagazine.com/wp-content/uploads/2022/04/nft-non-fungible-token-token-collection-bored-ape-yacht-club-example-army-monkey.jpg",
            price: "1,78",
            rating: 5,
            creater: "Creator E",
            isLiked: true
        ),
        NftId(
            name: "Lilo",
            logoUrlString: "https://fivmagazine.com/wp-content/uploads/2022/04/nft-non-fungible-token-token-collection-bored-ape-yacht-club-example-army-monkey.jpg",
            price: "1,78",
            rating: 5,
            creater: "Creator F",
            isLiked: true
        ),
        NftId(
            name: "Cosmic Cat",
            logoUrlString: "https://example.com/cosmic_cat.jpg",
            price: "2.45",
            rating: 4,
            creater: "John Doe",
            isLiked: false
        ),
        NftId(
            name: "Neon Dragon",
            logoUrlString: "https://example.com/neon_dragon.jpg",
            price: "0.99",
            rating: 3,
            creater: "Alice Smith",
            isLiked: true
        ),
        NftId(
            name: "Golden Phoenix",
            logoUrlString: "https://example.com/golden_phoenix.jpg",
            price: "5.00",
            rating: 5,
            creater: "Bob Johnson",
            isLiked: false
        ),
        NftId(
            name: "Mystic Owl",
            logoUrlString: "https://example.com/mystic_owl.jpg",
            price: "1.50",
            rating: 4,
            creater: "Emma Wilson",
            isLiked: false
        ),
        NftId(
            name: "Cyber Fox",
            logoUrlString: "https://example.com/cyber_fox.jpg",
            price: "3.20",
            rating: 4,
            creater: "Michael Brown",
            isLiked: false
        ),
        NftId(
            name: "Shadow Wolf",
            logoUrlString: "https://example.com/shadow_wolf.jpg",
            price: "0.75",
            rating: 3,
            creater: "Sophia Davis",
            isLiked: true
        ),
        NftId(
            name: "Ice Bear",
            logoUrlString: "https://example.com/ice_bear.jpg",
            price: "4.10",
            rating: 5,
            creater: "James Miller",
            isLiked: false
        ),
        NftId(
            name: "Fire Eagle",
            logoUrlString: "https://example.com/fire_eagle.jpg",
            price: "2.00",
            rating: 4,
            creater: "Olivia Garcia",
            isLiked: false
        ),
        NftId(
            name: "Thunder Lion",
            logoUrlString: "https://example.com/thunder_lion.jpg",
            price: "1.25",
            rating: 4,
            creater: "William Martinez",
            isLiked: true
        ),
        NftId(
            name: "Star Whale",
            logoUrlString: "https://example.com/star_whale.jpg",
            price: "6.50",
            rating: 5,
            creater: "Isabella Rodriguez",
            isLiked: false
        )
    ]
}

extension ProfileStruct {
    static let mock = ProfileStruct(
        name: "Joaquin Phoenix",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        site: "Joaquin Phoenix.com",
        urlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYU7QQ7VBlAXdZIKSFWJlG7c7pPitNPBpU-Q&s",
        allNfts: NftId.mockAllNfts,
        nftIds: [],
        likeIds: []
    )
}


