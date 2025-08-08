//
//  ChatHistorySender.swift
//  flair
//
//  Created by KJ on 2/17/25.
//

import Foundation

enum ChatHistorySender: Equatable {
    case user
    case recipient(String)
    case api
    
    var name: String {
        switch self {
        case .user: return "あなた"
        case .recipient(let name):
            return name.isEmpty ? "Unknown" : name
        case .api: return "神レスAI"
        }
    }
}
