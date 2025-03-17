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
                color: Color.black,
                size: .small
            )
            Text("メッセージを生成しています...")
                .foregroundColor(.black)
                .font(.caption)
                .bold()
                .padding(.horizontal, 16)
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.5), radius: 1, x: 2, y: 2)
    }
}

#Preview {
    SuggestLoadigView()
}
