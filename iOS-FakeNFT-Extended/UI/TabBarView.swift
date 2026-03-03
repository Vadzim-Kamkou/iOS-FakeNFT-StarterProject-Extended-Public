import SwiftUI
import Logging

struct TabBarView: View {
    @State private var selectTab: TabBarState = .catalog
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
                cartService: servicesAssembly.cartService
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
        TabView(selection: $selectTab) {
            ProfileScreen()
                .environment(ServicesAssembly.preview)
                .tabItem {
                    VStack(spacing: 0) {
                        Image(selectTab == .profile ? .profileTabBarActive : .profileTabBarUnActive)
                            .frame(width: 30, height: 30)
                        
                        Text("Profile")
                            .font(.caption3)
                            .foregroundStyle(selectTab == .profile ? .blueUniversal : .text)
                            .padding(.top, 4)
                    }
                    .frame(width: 76, height: 49)
                }
                .tag(TabBarState.profile)
            
            CatalogView()
                .environment(servicesAssembly)
                .tabItem {
                    VStack(spacing: 0) {
                        Image(selectTab == .catalog ? .catalogTabBArActive : .catalogTabBarUnActive)
                            .frame(width: 30, height: 30)
                        
                        Text("Catalog")
                            .font(.caption3)
                            .foregroundStyle(selectTab == .catalog ? .blueUniversal : .text)
                            .padding(.top, 4)
                    }
                    .frame(width: 76, height: 49)
                }
                .tag(TabBarState.catalog)
            
            CartMainView(viewModel: cartViewModel, paymentViewModel: paymentViewModel)
                .tabItem {
                    VStack(spacing: 0) {
                        Image(selectTab == .cart ? .cartTabBarActive : .cartTabBarUnActive)
                            .frame(width: 30, height: 30)
                        
                        Text("Cart")
                            .font(.caption3)
                            .foregroundStyle(selectTab == .cart ? .blueUniversal : .text)
                            .padding(.top, 4)
                    }
                    .frame(width: 76, height: 49)
                }
                .tag(TabBarState.cart)
        }
        .disabled(cartViewModel.cartScreenState == .Loading ? true : false)
    }
}

#Preview {
    TabBarView(servicesAssembly: ServicesAssembly.preview)
}

enum TabBarState {
    case cart
    case profile
    case catalog
}
