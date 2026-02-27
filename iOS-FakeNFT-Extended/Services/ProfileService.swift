import Foundation

protocol ProfileService {
    func loadProfile(id: String) async throws -> ProfileStruct
    func updateProfile(id: String, name: String?, avatar: String?, description: String?, website: String?, nfts: [String]?, likes: [String]?) async throws -> ProfileStruct
}

@MainActor
final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(id: String) async throws -> ProfileStruct {
        let request = ProfileRequest(id: id)
        let dto: ProfileResponseDTO = try await networkClient.send(request: request)
        return dto.toDomain()
    }
    
    func updateProfile(id: String, name: String?, avatar: String?, description: String?, website: String?, nfts: [String]?, likes: [String]?) async throws -> ProfileStruct {
         let request = ProfileUpdateRequest(
            id: id,
            name: name,
            description: description,
            website: website,
            avatar: avatar,
            likes: likes ?? []
        )
        
        let responseDTO: ProfileResponseDTO = try await networkClient.send(request: request)
        return responseDTO.toDomain()
    }
}
