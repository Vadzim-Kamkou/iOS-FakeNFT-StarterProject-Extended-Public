//
//  ActionButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//

import SwiftUI

enum ButtonColorStyle {
    case white
    case red
}

struct ActionButton: View {
    let title: LocalizedStringKey
    let isBoldTextButton: Bool
    let cornerRadius: CGFloat
    let textColor: ButtonColorStyle
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(textColor == .white ? .buttonText : .removeButton)
                .font(isBoldTextButton ? .bodyBold : .bodyRegular)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(.buttonBackground)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    ZStack {
        Color.clear
            .background(.backgroundForView)

        VStack {
            ActionButton(title: "К оплате", isBoldTextButton: true, cornerRadius: 16, textColor: .white) {
                print("Нажата")}
    
            ActionButton(title: "Удалить", isBoldTextButton: false, cornerRadius: 12, textColor: .red) {
                print("Нажата")}
        }
        .padding(20)
    }
     
}
