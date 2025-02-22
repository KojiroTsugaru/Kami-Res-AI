//
//  MessageMoodLabel.swift
//  kami-res-ai
//
//  Created by KJ on 2/19/25.
//

import SwiftUI
import SuperwallKit

struct MessageMoodLabel: View {
    @Binding var moodType: MessageMood.MoodType
    var isSelected: Bool = false

    var body: some View {
        Text(moodType.emoji)
            .font(.title)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(.white)

            )
            .foregroundColor(.black)
            .overlay(
                Circle()
                    .stroke(
                        isSelected
                        ? Constants.ColorAsset.createGradient(from: .topLeading, to: .bottomTrailing)
                        : LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 3
                    )
            )
            .shadow(color: .gray, radius: isSelected ? 3 : 1)
            .animation(.easeInOut, value: isSelected)
    }
}

#Preview {
    MessageMoodLabel(moodType: Binding.constant(MessageMood.defaultMood.type))
}
