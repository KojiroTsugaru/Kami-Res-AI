//
//  Message.swift
//  flair
//
//  Created by KJ on 2/14/25.
//

import Foundation

struct ChatHistoryItem: Identifiable {
    let id: String
    let message: String
    let sender: ChatHistorySender
    
    init(message: String, sender: ChatHistorySender) {
        self.id = UUID().uuidString
        self.message = message
        self.sender = sender
    }
}
