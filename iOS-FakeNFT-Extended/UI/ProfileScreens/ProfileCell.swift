//
//  ProfileCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/9/26.
//
import SwiftUI

struct ProfileCell<Destination: View>: View {
    let text: String
    let number: Int
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: 8) {
                Text(text)
                    .font(.bodyBold)
                    .foregroundColor(.primary)
                
                Text("(\(number))")
                    .font(.bodyBold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.bodyBold)
                    .foregroundColor(.primary)
            }
            .frame(height: 54)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 0) {
            ProfileCell(text: "Мои NFT", number: 112) {
                Text("Экран моих NFT")
                    .navigationBarBackButtonHidden(true)
            }
            ProfileCell(text: "Избранные NFT", number: 10) {
                Text("Экран избранного")
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 0) {
            ProfileCell(text: "Мои NFT", number: 112) {
                Text("Экран моих NFT")
            }
            ProfileCell(text: "Избранные NFT", number: 10) {
                Text("Экран избранного")
            }
        }
    }
}
