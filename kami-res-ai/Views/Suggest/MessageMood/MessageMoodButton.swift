//
//  MessageMoodButton.swift
//  kami-res-ai
//
//  Created by KJ on 2/5/25.
//


import SwiftUI
import SuperwallKit

struct MessageMoodButton: View {
    @Binding var mood: MessageMood
    @Binding var showMoodModal: Bool
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Button(action: {
            withAnimation(.default) {
                scale = 1.2
                showMoodModal = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.default) { // Fade out animation
                    scale = 1.0
                }
            }
        }) {
            Text(mood.type.emoji)
                .font(.title3)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.white)

                )
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageMoodButton(
//            showMessageMoodChange: Binding.constant(false),
//        )
//    }
//}
