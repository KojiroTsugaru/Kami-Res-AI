//
//  MessageMoodButton.swift
//  kami-res-ai
//
//  Created by KJ on 2/5/25.
//


import SwiftUI
import SuperwallKit

struct MessageMoodButton: View {
    @Binding var showMessageMoodChangeModal: Bool
    @State private var mood: MessageMood = MessageMood.defaultMood
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) { // Fade in animation
                showMessageMoodChangeModal = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.3)) { // Fade out animation
                    showMessageMoodChangeModal = false
                }
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                toggleMoodAlways()
                scale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    scale = 1.0
                }
            }
        }) {
            Text(mood.emoji)
                .scaleEffect(scale)
                .frame(width: 40, height: 40)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMoodButton(showMessageMoodChangeModal: Binding.constant(false))
    }
}
