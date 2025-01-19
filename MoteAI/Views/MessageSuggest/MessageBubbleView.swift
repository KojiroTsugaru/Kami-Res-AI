//
//  MessageBubbleView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: String
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(24)
    }
}

#Preview {
    MessageBubbleView(message: "test string")
}
