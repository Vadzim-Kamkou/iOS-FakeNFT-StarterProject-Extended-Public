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

#Preview {
    CatalogView()
}
