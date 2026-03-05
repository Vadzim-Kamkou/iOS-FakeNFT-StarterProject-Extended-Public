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
    @Bindable var paymentViewModel: PaymentViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ZStack {
                Color.backgroundForView.ignoresSafeArea()
                if viewModel.NFTArrayIsEmpty {
                    emptyCartView
                } else {
                    mainCartView
                        .fullScreenCover(isPresented: $viewModel.isShowingDeleteConfirmation) {
                            DeleteConfirmationView(viewModel: viewModel)
                        }
                        .fullScreenCover(isPresented: $viewModel.isHiddenFilter) {
                            CartFilterView(viewModel: viewModel)
                                .presentationBackground(.clear)
                        }
                    UnSuccessView(viewModel: viewModel)
                        .opacity(viewModel.cartScreenState == .UnSuccess ? 1 : 0)
                }
                if viewModel.cartScreenState == .Loading {
                   blockingView
                }
            }
            .progressHUD()
            .withDestination(path: $path, paymentViewModel: paymentViewModel)
        }
        .onAppear {
            Task {
                await viewModel.loadNFT()
            }
        }
        .onChange(of: viewModel.cartScreenState) { _, newState in
            switch newState {
            case .Loading:
                ProgressHUD.animate()
            case .Unused, .UnSuccess, .Success:
                ProgressHUD.dismiss()
            }
        }
        .onDisappear {
            Task {
                ProgressHUD.dismiss()
                viewModel.changeScreenState(by: .Unused)
            }
        }
    }
    
    private var mainCartView: some View {
        VStack(spacing: 0) {
            filterButton
            CartItemsListView(viewModel: viewModel)
            paymentBlock
        }
        .opacity(viewModel.cartScreenState == .Unused ? 1 : 0)
    }
    
    private var blockingView: some View {
        Color.primary
            .opacity(0.001)
            .ignoresSafeArea()
            .allowsHitTesting(true)
    }
    
    private var emptyCartView: some View {
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
                viewModel.tapOnFilterButton()
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
            VStack(alignment:.leading, spacing: 2) {
                Text(String(viewModel.NFTCounts).NFTStyleFormater)
                    .font(.caption1)
                    .foregroundStyle(.text)
                Text(viewModel.cartNFTTotalPrice.changeMark().ETHStyleFormater)
                    .font(.bodyBold)
                    .foregroundStyle(.greenUniversal)
            }
            ActionButton(title: "For payment",
                         verticalPadding: 11,
                         isBoldTextButton: true,
                         cornerRadius: 16,
                         textColor: .white) {
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
    @Previewable @State var viewModel = CartNFTViewModel(dataStore: CartDataStore(), cartService: ServicesAssembly.preview.cartService)
    
    let paymentService = PaymentServices(networkClient: DefaultNetworkClient(), storage: PaymentStorageImpl())
    let paymentViewModel = PaymentViewModel(paymentService: paymentService, dataStore: CartDataStore())
    
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
            CartMainView(viewModel: viewModel, paymentViewModel: paymentViewModel)
                .tabItem {
                    Label("Корзина", systemImage: "cart")
                }
        }
    }
    .progressHUD()
}

#Preview("Russian") {
    @Previewable @State var viewModel = CartNFTViewModel(dataStore: CartDataStore(), cartService: ServicesAssembly.preview.cartService)
    
    let paymentService = PaymentServices(networkClient: DefaultNetworkClient(), storage: PaymentStorageImpl())
    let paymentViewModel = PaymentViewModel(paymentService: paymentService, dataStore: CartDataStore())
    
    CartMainView(viewModel: viewModel, paymentViewModel: paymentViewModel)
        .environment(\.locale, .init(identifier: "ru"))
}

#Preview("English") {
    @Previewable @State var viewModel = CartNFTViewModel(dataStore: CartDataStore(), cartService: ServicesAssembly.preview.cartService)
    
    let paymentService = PaymentServices(networkClient: DefaultNetworkClient(), storage: PaymentStorageImpl())
    let paymentViewModel = PaymentViewModel(paymentService: paymentService, dataStore: CartDataStore())
    
    CartMainView(viewModel: viewModel, paymentViewModel: paymentViewModel)
        .environment(\.locale, .init(identifier: "en"))
}
