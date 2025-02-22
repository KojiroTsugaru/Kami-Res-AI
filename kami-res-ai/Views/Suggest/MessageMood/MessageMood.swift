//
//  MessageMood.swift
//  kami-res-ai
//
//  Created by KJ on 2/5/25.
//

import Foundation

struct MessageMood: Equatable {
    var type: MoodType
    var messageLength: MessageLength

    static let defaultMood = MessageMood(type: .casual, messageLength: .medium)

    enum MoodType: CaseIterable {
        case casual
        case humorous
        case cool
        
        var emoji: String {
            switch self {
            case .casual: return "✨"
            case .humorous: return "👀"
            case .cool: return "👔"
            }
        }

        var title: String {
            switch self {
            case .casual: return "カジュアルで話しやすい"
            case .humorous: return "ユーモア溢れる"
            case .cool: return "クールに大人っぽく"
            }
        }

        var prompt: String {
            switch self {
            case .casual: return Constants.Prompts.casual
            case .humorous: return Constants.Prompts.humorous
            case .cool: return Constants.Prompts.cool
            }
        }
    }
}


enum MessageLength: Double, CaseIterable {
    case short = 1.0
    case medium = 2.0
    case long = 3.0
}
