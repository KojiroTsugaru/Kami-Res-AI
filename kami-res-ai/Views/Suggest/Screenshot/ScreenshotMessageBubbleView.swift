//
//  MessageBubbleView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI

struct ScreenshotMessageBubbleView: View {
    let message: String
    var body: some View {
        ZStack {
            Text(message)
                .foregroundColor(Color(.black))
                .padding()
                .background(Color("AntiFlashWhite"))
                .cornerRadius(20)
        }.padding()
    }
}

#Preview {
    ScreenshotMessageBubbleView(message: "test string")
}
