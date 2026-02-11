import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    
    var body: some View {
        NavigationStack {
            CatalogListView(viewModel: viewModel)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: viewModel.catalogSorting) {
                            Image(.iconSort)
                        }
                    }
                }
        }
    }
}

extension Font {
    static var bodyBold = Font.system(size: 17, weight: .bold)
    static var body22Bold = Font.system(size: 22, weight: .bold)
    static var medium10 = Font.system(size: 10, weight: .regular)
    static var regular13 = Font.system(size: 13, weight: .regular)
    static var regular15 = Font.system(size: 15, weight: .regular)
}

extension Color {
    static let blueUniversal = Color(red: 10.0 / 255.0, green: 132.0 / 255.0, blue: 255.0 / 255.0)
}

#Preview {
    CatalogView()
}
