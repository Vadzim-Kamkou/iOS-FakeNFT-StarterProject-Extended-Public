import Foundation

struct ProfileResponseDTO: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension ProfileResponseDTO {
    func toDomain() -> ProfileStruct {
        ProfileStruct(
            name: name,
            description: description,
            site: website,
            urlString: avatar,
            allNfts: [],
            nftIds: nfts,
            likeIds: likes
        )
    }
}


