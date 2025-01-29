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
                    color: Color.black,
                    size: .small
                )
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color("ChatBubbleColor"))
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
    MessageBubbleView(message: "test string")
}
