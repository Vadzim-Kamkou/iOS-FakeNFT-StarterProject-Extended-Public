//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Vadzim on 26.02.26.
//

import Foundation

protocol ProfileService {
    func getProfile() async throws -> Profile
    func updateLikes(_ likes: [String]) async throws -> Profile
}

actor ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getProfile() async throws -> Profile {
        let request = ProfileRequest()
        let profile: Profile = try await networkClient.send(request: request)
        return profile
    }
    
    func updateLikes(_ likes: [String]) async throws -> Profile {
        let request = UpdateProfileRequest(likes: likes)
        let profile: Profile = try await networkClient.send(request: request)
        
        return profile
    }
}
