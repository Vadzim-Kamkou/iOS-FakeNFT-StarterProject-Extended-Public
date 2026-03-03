//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/9/26.
//

import SwiftUI

struct WebViewScreen: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.bodyBold)
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                }

                Spacer()
            }
            .frame(height:42)
            .padding([.leading, .vertical], 9)
            
            .background(Color.white)

            WebView1(url: url)
                .ignoresSafeArea(edges: .bottom)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
}
