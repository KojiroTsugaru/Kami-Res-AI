//
//  ChatItem.swift
//  MoteAI
//
//  Created by KJ on 1/22/25.
//

import SwiftUI

enum ChatItem: Identifiable {
    case message(String)
    case image(UIImage)
    
    var id: UUID {
        switch self {
        case .message(let text):
            return UUID(uuidString: text.hash.description) ?? UUID()
        case .image:
            return UUID()
        }
    }
}
