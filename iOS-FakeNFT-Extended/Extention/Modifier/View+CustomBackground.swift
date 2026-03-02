//
//  View+CustomBackground.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 17.02.2026.
//
import SwiftUI

struct CustomBackgroundModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func customBackground(cornerRadius: CGFloat = 12) -> some View {
        modifier(CustomBackgroundModifier(cornerRadius: cornerRadius))
    }
}
