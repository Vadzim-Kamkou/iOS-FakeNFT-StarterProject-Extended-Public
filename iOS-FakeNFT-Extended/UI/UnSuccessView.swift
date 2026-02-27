//
//  UnSuccessPaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 13.02.2026.
//
import SwiftUI

struct UnSuccessView: View {
    let viewModel: AlertProtocol
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                alertTitle
                horizontalSeparator
                HStack(spacing: 0) {
                    button(withKey: "Cancel") {
                        viewModel.cancelPaymentRequest()
                    }
                    verticalSeparator
                    button(withKey: "Error.repeat") {
                        Task {
                            await viewModel.repeatNetworkRequest()
                        }
                    }
                }
                .frame(height: 40)
            }
            .background(.alertBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 52)
            .frame(minHeight: 270)
        }
    }
    
    private var alertTitle: some View {
        Text(viewModel.alertTitle)
            .font(.bodyBold)
            .foregroundStyle(.blackUniversal)
            .multilineTextAlignment(.center)
            .padding(16)
            .frame(maxWidth: .infinity)
    }
    
    private var horizontalSeparator: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundStyle(.alertSeparator)
            .frame(maxWidth: .infinity)
    }
    
    private var verticalSeparator: some View {
        Rectangle()
            .frame(width: 0.5)
            .foregroundStyle(.alertSeparator)
            .frame(height: 40)
    }
    
    private func button(withKey key: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(NSLocalizedString(key, comment: ""))
                .font(key == "Error.repeat" ? .bodyBold : .bodyRegular)
                .foregroundStyle(.blueUniversal)
        }
        .padding(.vertical, 11)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var showAlert = false
    let paymentService = PaymentServices(networkClient: DefaultNetworkClient(), storage: PaymentStorageImpl())
    let viewModel = PaymentViewModel(paymentService: paymentService, dataStore: CartDataStore())

    ZStack {
        Color
            .backgroundForView
            .ignoresSafeArea()
        VStack {
            Button("Показать ошибку") {
                showAlert = true
            }
        }
        
        if showAlert {
            UnSuccessView(viewModel: viewModel)
            
        }
    }
}
