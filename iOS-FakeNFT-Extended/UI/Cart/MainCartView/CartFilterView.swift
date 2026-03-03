//
//  CartFilterView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 16.02.2026.
//

import SwiftUI

struct CartFilterView: View {
    
    let viewModel:CartNFTViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing: 8) {
                Spacer()
                menu
                closeButton
            }
            .padding([.horizontal, .top], 8)
        }
    }
    
    private var menu: some View {
        VStack(spacing: 0) {
            Text("Sorting")
                .font(.caption2)
                .foregroundStyle(.sortMenuTitle)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            separator
            ForEach(SortVariation.allCases, id: \.self) { value in
                Text(value.localized)
                    .foregroundStyle(.blueUniversal)
                    .font(.headline5)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.tapOnFilterButton(value)
                    }
                separator
                    .opacity(value == .byName ? 0 : 1)
            }
        }
        .customBackground()
    }
    
    private var separator: some View {
        Divider()
            .frame(height: 0.5)
            .foregroundStyle(.customSeparator)
    }
    
    private var closeButton: some View {
        Button {
            viewModel.tapOnFilterButton()
        } label: {
            VStack(spacing: 0) {
                Text("Close")
                    .font(.headline4)
                    .foregroundStyle(.blueUniversal)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .infinity)
        .customBackground()
    }
}


#Preview {
    @Previewable @State var needSelectFilter = false
    @Previewable @State var viewModel = CartNFTViewModel(dataStore: CartDataStore(), cartService: ServicesAssembly.preview.cartService)
    
    ZStack {
        Color
            .backgroundForView
            .ignoresSafeArea()
        VStack {
            Button("Показать меню фильтрации") {
                needSelectFilter = true
            }
        }
        CartFilterView(viewModel:viewModel)
            .opacity(needSelectFilter ? 1 : 0)
    }
}
