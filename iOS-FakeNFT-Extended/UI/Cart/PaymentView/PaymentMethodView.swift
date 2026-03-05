//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 11.02.2026.
//

import SwiftUI
import SafariServices
import ProgressHUD

struct PaymentMethodView: View {
    @Binding var path: [String]
    let viewModel: PaymentViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundForView.ignoresSafeArea()
            VStack(spacing: 20) {
                navigationBlock
                PaymentGridView(viewModel: viewModel)
                    .padding(.horizontal, 16)
                Spacer()
                paymentBlockWithButton
            }
            UnSuccessView(viewModel: viewModel)
                .opacity(viewModel.paymentScreenState == .UnSuccess ? 1 : 0)

            if viewModel.paymentScreenState == .Loading {
                Color.primary
                    .opacity(0.001)
                    .ignoresSafeArea()
                    .allowsHitTesting(true)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .background(.backgroundForView)
        .progressHUD()
        .task {
            await viewModel.loadPaymentType()
        }
        .onChange(of: viewModel.paymentScreenState) { _, newState in
            switch newState {
            case .Loading:
                ProgressHUD.animate()
            case .Unused, .UnSuccess:
                ProgressHUD.dismiss()
            case .Success:
                ProgressHUD.dismiss()
                viewModel.cancelPaymentRequest()
                path.append("SuccessPaymentView")
            }
        }
    }
    
    init(path: Binding <[String]>, viewModel: PaymentViewModel) {
        self._path = path
        self.viewModel = viewModel
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorBackground = .clear
    }
    
    var paymentBlockWithButton: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("By making a purchase, you agree to the terms")
                .font(.caption2)
            
            Text("User Agreement")
                .font(.caption2)
                .padding(.top, 4)
                .foregroundStyle(.blueUniversal)
                .onTapGesture {
                    path.append("UserAgreement")
                }
            
            ActionButton(title: "Pay",
                         verticalPadding: 19,
                         isBoldTextButton: true,
                         cornerRadius: 16,
                         textColor: .white) {
                Task {
                    await viewModel.processPayment()
                }}
                         .disabled(!viewModel.isActivePayment)
                         .padding(.top, 16)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(.lightGrey)
    }
    
    var navigationBlock: some View {
        HStack(spacing: 0) {
            Text("Select payment method")
                .font(.bodyBold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .padding(.top, 2)
        .overlay(alignment: .leading) {
            Button {
                viewModel.cancelPaymentRequest()
                path.removeLast()
            } label: {
                Image(.backwardChevron)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.buttonBackground)
            }
            .padding(.leading, 9)
        }
    }
}

#Preview {
    @Previewable @State var path = [String]()
    let paymentService = PaymentServices(networkClient: DefaultNetworkClient(), storage: PaymentStorageImpl())
    let viewModel = PaymentViewModel(paymentService: paymentService, dataStore: CartDataStore())
    ZStack {
        Color.backgroundForView
            .ignoresSafeArea()
        PaymentMethodView(path: $path, viewModel: viewModel)
    }
}
