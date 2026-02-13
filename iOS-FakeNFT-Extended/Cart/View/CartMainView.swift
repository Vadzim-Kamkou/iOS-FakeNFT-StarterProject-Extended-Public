//
//  CartMainView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//
import ProgressHUD
import SwiftUI

struct CartMainView: View {
    @State private var path: [String] = []
    @Bindable var viewModel: CartNFTViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ZStack {
                Color.backgroundForView.ignoresSafeArea()
                if viewModel.NFTArrayIsEmpty {
                    EmptyCartView
                } else {
                    mainCartView
                        .fullScreenCover(isPresented: $viewModel.isShowingDeleteConfirmation) {
                            DeleteConfirmationView(viewModel: viewModel)
                        }
                }
            }
            .withDestination(path: $path)
        }
        .onAppear {
            Task {
                if viewModel.NFTArrayIsEmpty {
                    ProgressHUD.animate()
                    try? await Task.sleep(nanoseconds: 1_500_000_000) // временно для теста ProgressHUD
                    await viewModel.createMocksNFTArray()
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    private var mainCartView: some View {
        VStack(spacing: 0) {
            filterButton
            CartItemsListView(viewModel: viewModel)
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
                print("[CartMainView]: filterButton - Фильтруем данные")
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
                Text(String(viewModel.NFTCounts).NFTStyleFormater)
                    .font(.caption1)
                    .foregroundStyle(.text)
                Text(viewModel.cartNFTTotalPrice.changeMark().ETHStyleFormater)
                    .font(.bodyBold)
                    .foregroundStyle(.greenUniversal)
            }
            ActionButton(title: "For payment", isBoldTextButton: true, cornerRadius: 16, textColor: .white) {
                path.append("Payment")
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
    @Previewable @State var viewModel = CartNFTViewModel(nftService: MockNFTService())
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
            CartMainView(viewModel: viewModel)
                .tabItem {
                    Label("Корзина", systemImage: "cart")
                }
        }
    }
    .progressHUD()
}

#Preview("Russian") {
    @Previewable @State var viewModel = CartNFTViewModel(nftService: MockNFTService())
    
    CartMainView(viewModel: viewModel)
        .environment(\.locale, .init(identifier: "ru"))
}

#Preview("English") {
    @Previewable @State var viewModel = CartNFTViewModel(nftService: MockNFTService())
    
    CartMainView(viewModel: viewModel)
        .environment(\.locale, .init(identifier: "en"))
}
