//
//  MessageBubbleView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct ScreenshotMessageBubbleView: View {
    let message: String
    var body: some View {
        ZStack {
            if message == Constants.loadingMessage {
                LoadingIndicator(
                    animation: .threeBalls,
                    color: Color.black,
                    size: .small
                )
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color.white)
                .shadow(radius: 3)
                .cornerRadius(20)
            } else {
                Text(message)
                    .foregroundColor(Color(.black))
                    .padding()
                    .background(Color("ChatBubbleColor"))
                    .cornerRadius(20)
            }
        }.padding()
    }
}

#Preview {
    ScreenshotMessageBubbleView(message: "test string")
}
