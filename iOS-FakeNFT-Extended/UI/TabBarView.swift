import SwiftUI

struct TabBarView: View {
    
    @State private var selectedTab = 0
    @State private var stateCurt = false
    
    init() {
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
            Text("Каталог")
                .onAppear {
                    stateCurt = false
                }
                .tabItem {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                        Text("Каталог")
                            .font(.caption2)
                    }
                }
                .tag(1)
            CartMainView()
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
    }
}

#Preview {
    TabBarView()
}
