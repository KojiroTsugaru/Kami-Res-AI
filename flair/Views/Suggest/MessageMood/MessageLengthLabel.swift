//
//  MessageLengthLabel.swift
//  flair
//
//  Created by KJ on 3/31/25.
//

import SwiftUI
import SuperwallKit

struct MessageLengthLabel: View {
    let length: MessageLength
    let isSelected: Bool
    
    init(length: MessageLength, isSelected: Bool) {
        self.length = length
        self.isSelected = isSelected
    }

    private var isUserSubscribed: Bool {
        Superwall.shared.subscriptionStatus == .active
    }
    
    var body: some View {
        Text(length.description)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke(
                        isSelected ? Color.black :Color.gray,
                        lineWidth: isSelected ? 1 : 0.5
                    )
                    .shadow(radius: 1)
            }
            .padding(4)
            .overlay(alignment: .topTrailing) {
                if !isUserSubscribed && length.isPremiumOnly {
                    premiumBadge
                }
            }
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
    HStack(spacing: 20) {
        MessageLengthLabel(length: MessageLength.short, isSelected: false)
        MessageLengthLabel(length: MessageLength.medium, isSelected: true)
        MessageLengthLabel(length: MessageLength.long, isSelected: false)
    }
}
