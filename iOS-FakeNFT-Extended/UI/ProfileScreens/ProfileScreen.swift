//
//  ProfileScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/9/26.
//

import SwiftUI
import Kingfisher

struct ProfileScreen: View {
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    NavigationLink {
                        EditProfileScreen()
                            .navigationBarBackButtonHidden(true)
                            .environment(viewModel)
                    } label: {
                        Image(.editIcon)
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                            .frame(width: 42, height: 42)
                    }
                }
                .padding(.trailing, 9)
                .padding(.top, 2)
                .padding(.bottom, 20)
                
                HStack {
                    KFImage(URL(string: viewModel.avatarURL))
                        .placeholder {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    Text(viewModel.name)
                        .font(.headline3)
                        .foregroundColor(.primary)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.description)
                        .font(.caption2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let fullURL = URL(string: viewModel.websiteFullURL) {
                        NavigationLink {
                            WebViewScreen(url: fullURL)
                        } label: {
                            Text(viewModel.websiteDisplay)
                                .font(.caption1)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
                

                VStack(spacing: 0) {
                    ProfileCell(text: "Мои NFT", number: viewModel.myNftCount) {
                        MyNftScreen()
                            .navigationBarBackButtonHidden(true)
                            .environment(viewModel)
                    }
                    
                    ProfileCell(text: "Избранные NFT", number: viewModel.favoriteNftCount) {
                        FavoriteNftScreen()
                            .navigationBarBackButtonHidden(true)
                            .environment(viewModel)
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
        }
        .task {
            await viewModel.loadProfile(using: services.profileService, id: "1")
        }
    }
}

#Preview {
    ProfileScreen()
        .environment(ServicesAssembly.preview)
}
