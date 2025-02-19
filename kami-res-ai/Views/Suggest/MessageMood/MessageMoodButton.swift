//
//  MessageMoodButton.swift
//  kami-res-ai
//
//  Created by KJ on 2/5/25.
//


import SwiftUI
import SuperwallKit

struct MessageMoodButton: View {
    @Binding var showMessageMoodChange: Bool
    @Binding var mood: MessageMood
    @State private var scale: CGFloat = 1.0
    @State private var canPressButton = true

    var body: some View {
        Button(action: {
            if canPressButton {
                withAnimation(.default) {
                    canPressButton = false
                    toggleMoodAlways()
                    scale = 1.2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.default) { // Fade out animation
                        showMessageMoodChange = false
                        scale = 1.0
                        canPressButton = true
                    }
                }
            }
        }) {
            Text(mood.emoji)
                .scaleEffect(scale)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.white))
                .foregroundColor(.white)
                .shadow(radius: 2)
                .transition(.scale)
        }
    }

    private func toggleMoodIfNeeded() {
        if Superwall.shared.subscriptionStatus == .active {
            let moods = MessageMood.allCases
            if let currentIndex = moods.firstIndex(of: mood) {
                let nextIndex = (currentIndex + 1) % moods.count
                mood = moods[nextIndex]
            }
        } else {
            Superwall.shared.register(event: "campaign_trigger")
        }
    }
    
    /// テスト用
    private func toggleMoodAlways() {
        let moods = MessageMood.allCases
        if let currentIndex = moods.firstIndex(of: mood) {
            let nextIndex = (currentIndex + 1) % moods.count
            mood = moods[nextIndex]
        }
        showMessageMoodChange = true
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageMoodButton(
//            showMessageMoodChange: Binding.constant(false),
//        )
//    }
//}
