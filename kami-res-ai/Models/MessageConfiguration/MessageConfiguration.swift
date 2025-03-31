//
//  MessageConfiguration.swift
//  kami-res-ai
//
//  Created by KJ on 3/30/25.
//

import Foundation

class MessageConfiguration: Equatable, ObservableObject {
    static func == (lhs: MessageConfiguration, rhs: MessageConfiguration) -> Bool {
        return lhs.mood == rhs.mood && lhs.length == rhs.length
    }

    var mood: MessageMood
    var length: MessageLength

    static let defaultConfig = MessageConfiguration(
        mood: .casual,
        length: .medium
    )
    
    init(mood: MessageMood, length: MessageLength) {
        self.mood = mood
        self.length = length
    }
}
