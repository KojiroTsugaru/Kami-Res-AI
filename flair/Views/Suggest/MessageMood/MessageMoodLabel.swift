//
//  MessageMoodLabel.swift
//  flair
//
//  Created by KJ on 2/19/25.
//

import SwiftUI
import SuperwallKit

struct MessageMoodLabel: View {
    let mood: MessageMood
    let isSelected: Bool
    
    private var isUserSubscribed: Bool {
        Superwall.shared.subscriptionStatus == .active
    }

    var body: some View {
        Text(mood.emoji)
            .font(.title)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(.white)

            )
            .foregroundColor(.black)
            .overlay(
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .stroke(
                            isSelected
                            ? Constants.ColorAsset.createGradient(from: .topLeading, to: .bottomTrailing)
                            : LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: isSelected ? 3 : 0.2
                        )
                        .shadow(color: .gray, radius: isSelected ? 2 : 0.5)
                    if !isUserSubscribed && mood.isPremiumOnly {
                        premiumBadge
                    }
                }
            )
            .animation(.easeInOut, value: isSelected)
    }
    
    private var premiumBadge: some View {
        Image(systemName: "crown.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 12)
            .font(.caption)
            .foregroundColor(Color("premiumIcon"))
            .padding(4)
            .background(Color.black)
            .cornerRadius(4)
            .shadow(radius: 0.5)
    }
}

#Preview {
    MessageMoodLabel(mood: .cool, isSelected: false)
}
