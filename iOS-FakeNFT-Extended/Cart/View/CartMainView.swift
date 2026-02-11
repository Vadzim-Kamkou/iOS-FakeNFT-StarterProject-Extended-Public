//
//  CartMainView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//
import ProgressHUD
import SwiftUI

struct CartMainView: View {
    @State private var isShowingDeleteConfirmation = false
    @State private var path: [String] = []
    @State var mocksArray = Array(repeating: 5, count: 0) // временно заменить на данные во viewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ZStack {
                Color.backgroundForView.ignoresSafeArea()
                if mocksArray.isEmpty {
                    EmptyCartView
                } else {
                    mainCartView
                        .fullScreenCover(isPresented: $isShowingDeleteConfirmation) {
                            DeleteConfirmationView()
                        }
                }
            }
            .withDestination(path: $path)
        }
        .onAppear {
            Task {
                ProgressHUD.animate()
                try? await Task.sleep(nanoseconds: 1_500_000_000) // временно для теста
                mocksArray = Array(repeating: 5, count: 5) // временно заменить на данные во viewModel
                ProgressHUD.dismiss()
            }
        }
    }
    
    private var mainCartView: some View {
        VStack(spacing: 0) {
            filterButton
            CartItemsListView(nftsMocks: mocksArray)
            paymentBlock
        }
    }
    
    private var EmptyCartView: some View {
        VStack(spacing: 0) {
            Text("The cart is empty")
                .font(.bodyBold)
                .foregroundStyle(.text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var filterButton: some View {
        HStack(spacing: 0) {
            Spacer()
            Button {
                print("Фильтруем данные")
            } label: {
                Image(.sortButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
            }
        }
        .padding(.trailing, 9)
    }
    
    private var paymentBlock: some View {
        HStack(spacing: 24) {
            VStack(alignment:.leading, spacing: 0) {
                Text("3 NFT")
                    .font(.caption1)
                    .foregroundStyle(.text)
                Text("5,34 ETH")
                    .font(.bodyBold)
                    .foregroundStyle(.greenUniversal)
            }
            ActionButton(title: "For payment", isBoldTextButton: true, cornerRadius: 16, textColor: .white) {
                path.append("Payment")
                print("🔵 path теперь: \(path)")
                
            }
        }
        .padding(16)
        .background(.lightGrey)
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 12,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 12
        ))
    }
}

#Preview {
    ZStack {
        Color.clear
            .background(.backgroundForView)
        TabView {
            Text("Профиль")
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
            Text("Каталог")
                .tabItem {
                    Label("Каталог", systemImage: "square.grid.2x2")
                }
            CartMainView()
                .tabItem {
                    Label("Корзина", systemImage: "cart")
                }
        }
    }
    .progressHUD()
}

#Preview("Russian") {
    CartMainView()
        .environment(\.locale, .init(identifier: "ru"))
}

#Preview("English") {
    CartMainView()
        .environment(\.locale, .init(identifier: "en"))
}


