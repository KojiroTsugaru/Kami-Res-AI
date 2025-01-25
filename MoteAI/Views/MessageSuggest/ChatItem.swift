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
        case .message(_):
            return UUID() // Or hash the text if uniqueness is guaranteed
        case .image:
            return UUID()
        }
    }
}
