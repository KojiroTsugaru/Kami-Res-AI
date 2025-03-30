//
//  MessageConfiguration.swift
//  kami-res-ai
//
//  Created by KJ on 3/30/25.
//

import Foundation

struct MessageConfiguration: Equatable {
    var type: MessageMood
    var messageLength: MessageLength

    static let defaultMood = MessageConfiguration(type: .casual, messageLength: .medium)
    
    init(type: MessageMood, messageLength: MessageLength) {
        self.type = type
        self.messageLength = messageLength
    }
}
