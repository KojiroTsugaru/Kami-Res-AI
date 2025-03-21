//
//  SuggestLoadigView.swift
//  kami-res-ai
//
//  Created by KJ on 3/17/25.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct SuggestLoadigView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            LoadingIndicator(
                animation: .threeBalls,
                color: Color.white,
                size: .small
            )
            GradientText(
                "メッセージを生成しています...",
                font: .caption.bold(),
                gradient: Constants.ColorAsset
                    .createGradient(from: .topLeading, to: .bottomTrailing)
            )
            .padding(.horizontal, 16)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
    }
}

#Preview {
    SuggestLoadigView()
}
