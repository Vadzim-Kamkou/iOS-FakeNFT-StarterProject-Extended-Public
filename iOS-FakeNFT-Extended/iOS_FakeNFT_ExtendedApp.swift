import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    private let networkClient = DefaultNetworkClient()
    private let nftStorage = NftStorageImpl()
    private let paymentStorage = PaymentStorageImpl()
    private let cartStorage = CartStorageImpl()
    private var servicesAssembly: ServicesAssembly {
        ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage,
            paymentStorage: paymentStorage,
            cartStorage: cartStorage
        )
    }
    
    init() {
        setupTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView(servicesAssembly: servicesAssembly)
                .progressHUD()
        }
    }
    
    func setupTabBarAppearance() {
        // Настройка цветов при инициализации
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Фон
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.backgroundForView)
        
        // Цвет неактивных иконок и текста
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(.text)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(.text),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Цвет активных иконок и текста
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(.blueUniversal)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(.blueUniversal),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
    }
}
