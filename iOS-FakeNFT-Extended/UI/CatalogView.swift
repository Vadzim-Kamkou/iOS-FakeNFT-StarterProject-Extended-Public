import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    
    var body: some View {
        NavigationStack {
            CatalogListView()
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: viewModel.catalogSorting) {
                            Image(.iconSort)
                        }
                    }
                }
                .backgroundStyle(.background)
                //.sheet(isPresented: $presentingNft) {
                //  NftDetailBridgeView()
                //}
        }
    }
}

extension Font {
    static var bodyBold = Font.system(size: 17, weight: .bold)
}

#Preview {
    CatalogView()
}
