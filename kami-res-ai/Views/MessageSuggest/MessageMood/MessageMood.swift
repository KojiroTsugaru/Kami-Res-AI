//
//  MessageMood.swift
//  kami-res-ai
//
//  Created by KJ on 2/5/25.
//

import Foundation

enum MessageMood: CaseIterable {
    case casual
    case humorous
    case cool
    static let defaultMood: MessageMood = .cool

    var emoji: String {
        switch self {
        case .casual: return "😊"
        case .humorous: return "😂"
        case .cool: return "😎"
        }
    }

    var text: String {
        switch self {
        case .casual: return "Casual"
        case .humorous: return "Humorous"
        case .cool: return "Cool"
        }
    }
}
