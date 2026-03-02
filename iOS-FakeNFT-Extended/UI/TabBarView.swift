import SwiftUI
import Logging

struct TabBarView: View {
    
    @State private var selectedTab = 0
    @State private var stateCurt = false
    private let cartDataStore: CartDataStore
    
    let servicesAssembly: ServicesAssembly
    
    @State var cartViewModel: CartNFTViewModel
    @State var paymentViewModel: PaymentViewModel
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.cartDataStore = CartDataStore()
        
        _cartViewModel = State(
            initialValue: CartNFTViewModel(
                dataStore: cartDataStore,
                cartService: servicesAssembly.cartSevice
            )
        )
        _paymentViewModel = State(
            initialValue: PaymentViewModel(
                paymentService: servicesAssembly.paymentService,
                dataStore: cartDataStore
            )
        )
    }
    
    var body: some View {
        TabView {
            Text("Профиль")
                .onAppear {
                    stateCurt = false
                }
                .tabItem {
                    VStack(spacing: 0) {
                        Image(systemName:  "person.fill")
                        Text("Профиль")
                            .font(.caption2)
                    }
                }
                .tag(0)
            CatalogView()
                .environment(servicesAssembly)
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                    .onAppear {
                        stateCurt = false
                    }
                }
                .tag(1)
            CartMainView(viewModel: cartViewModel, paymentViewModel: paymentViewModel)
                .onAppear {
                    stateCurt = true
                }
                .tabItem {
                    VStack(spacing: 0) {
                        Image(stateCurt ? .cartTabBarActive : .cartTabBarUnActive)
                            .frame(width: 24, height: 24)
                        
                        Text("Cart")
                            .font(.caption3)
                            .foregroundStyle(stateCurt ? .blueUniversal : .red)
                    }
                }
                .tag(2)
            Text("Статистика")
                .onAppear {
                    stateCurt = false
                }
                .tabItem {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                        Text("Статистика")
                            .font(.caption2)
                    }
                }
                .tag(3)
        }
        .disabled(cartViewModel.cartScreenState == .Loading ? true : false)
    }
}

#Preview {
    TabBarView(servicesAssembly: ServicesAssembly.preview)
}
