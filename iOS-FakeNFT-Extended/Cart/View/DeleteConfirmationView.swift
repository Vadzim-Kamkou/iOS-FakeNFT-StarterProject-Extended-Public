//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 10.02.2026.
//

import SwiftUI

struct DeleteConfirmationView: View {
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial.opacity(0.99))
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(.mockNFT)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 108, maxHeight: 108)
                Text("Are you sure you want to delete this item from your trash?")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 180)
                    .frame(maxWidth: .infinity)
                HStack(spacing: 8) {
                    ActionButton(title: "Remove", isBoldTextButton: false, cornerRadius: 12, textColor: .red) {
                        print("Реально хотим удалить")
                        dismiss()                    }
                    ActionButton(title: "Cancel", isBoldTextButton: false, cornerRadius: 12, textColor: .white) {
                        print("Реально хотим вернуться не удаляя")
                        dismiss()                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 57)
//                Slider(value: $blurAmount, in: 0...30)
//                    .padding()
            }
        }
        .presentationBackground(.clear) // ← ВАЖНО! Для iOS 16.4+
        
    }
}

//#Preview {
//    @Previewable @State var status = true
//    ZStack {
//        Color.clear
//            .background(.red)
//        DeleteConfirmationView(isPresented: $status)
//
//    }
//}
