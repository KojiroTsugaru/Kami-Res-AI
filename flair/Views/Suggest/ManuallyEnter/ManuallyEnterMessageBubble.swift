//
//  ManuallyEnterMessageBubble.swift
//  flair
//
//  Created by KJ on 2/17/25.
//

import SwiftUI

struct ManuallyEnterMessageBubbleView: View {
    let chatItem: ChatHistoryItem
    
    var body: some View {
        HStack {
            if chatItem.sender == .user || chatItem.sender == .api {
                Spacer()
            }
            
            Text(chatItem.message)
                .foregroundColor(chatItem.sender == .api ? .white : .black)
                .padding()
                .background(chatItem.sender == .api ? .black : .white)
                .shadow(radius: 3)
                .cornerRadius(20)
            
            if chatItem.sender != .user && chatItem.sender != .api {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
