//
//  MessageMood.swift
//  kami-res-ai
//
//  Created by KJ on 2/5/25.
//

import Foundation

enum MessageMood: String, CaseIterable {
    // 無料版: .casual, .formal
    case casual = "casual"
    case formal = "formal"
    
    // 有料版: .humorous, .cool, .romantic, .empathetic
    case humorous = "humorous"
    case cool = "cool"
    case romantic = "romantic"
    case empathetic = "empathetic"
    
    var emoji: String {
        switch self {
        case .casual:
            return "✨"
        case .formal:
            return "👔"
        case .humorous:
            return "🐵"
        case .cool:
            return "🕶️"
        case .romantic:
            return "❤️‍🔥"
        case .empathetic:
            return "🌷"
        }
    }

    var title: String {
        switch self {
        case .casual:
            return "カジュアルで自然に"
        case .formal:
            return "礼儀正しく丁寧に"
        case .humorous:
            return "おふざけモード"
        case .cool:
            return "クールに大人っぽく"
        case .romantic:
            return "ロマンティックに"
        case .empathetic:
            return "全力で共感"
        }
    }
    
    var isPremiumOnly: Bool {
        switch self {
        case .casual, .formal:
            return false
        case .humorous, .cool, .romantic, .empathetic:
            return true
            
        }
    }
}
