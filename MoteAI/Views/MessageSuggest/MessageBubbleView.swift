//
//  MessageBubbleView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct MessageBubbleView: View {
    let message: String
    var body: some View {
        ZStack {
            if message == Constants.loadingMessage {
                LoadingIndicator(
                    animation: .threeBalls,
                    color: Color.white,
                    size: .small
                )
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color.accentColor)
                .cornerRadius(24)
            } else {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(24)
            }
        }.padding()
    }
}

#Preview {
    MessageBubbleView(message: "test string")
}
