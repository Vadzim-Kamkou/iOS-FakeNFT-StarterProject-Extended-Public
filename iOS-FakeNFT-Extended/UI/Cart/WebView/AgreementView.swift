import SwiftUI
import WebKit
import ProgressHUD

struct AgreementView: View {
    
    @Binding var navigationPath: [String]
    @State private var isLoading = true
    
    private enum Constants {
        static let agreementURL = URL(string: "https://practicum.yandex.ru/ios-developer/")!
    }
    
    var body: some View {
        ZStack {
            Color.backgroundForView
                .ignoresSafeArea()
            VStack(spacing: 0) {
                navigationBar
                WebViewForAgreementView(url: Constants.agreementURL, isLoading: $isLoading)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            ProgressHUD.animate()
        }
        .onChange(of: isLoading) { _, newValue in
            if !newValue {
                ProgressHUD.dismiss()
            }
        }
        .onDisappear {
            ProgressHUD.dismiss()
        }
    }
    
    private var navigationBar: some View {
        HStack(spacing: 0) {
            Button {
                navigationPath.removeLast()
            } label: {
                Image(.backwardChevron)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.buttonBackground)
            }
            .padding([.leading, .vertical], 9)
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var path = ["Agreement"]
    AgreementView(navigationPath: $path)
}
