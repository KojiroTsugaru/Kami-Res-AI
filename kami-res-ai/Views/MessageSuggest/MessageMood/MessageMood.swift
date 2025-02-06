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
    static let defaultMood: MessageMood = .casual

    var emoji: String {
        switch self {
        case .casual: return "✨"
        case .humorous: return "👀"
        case .cool: return "👔"
        }
    }

    var text: String {
        switch self {
        case .casual: return "カジュアルで話しやすい"
        case .humorous: return "ユーモア溢れる"
        case .cool: return "クールに大人っぽく"
        }
    }
}
