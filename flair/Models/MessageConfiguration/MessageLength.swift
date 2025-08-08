//
//  MessageLength.swift
//  flair
//
//  Created by KJ on 3/30/25.
//

enum MessageLength: Double, CaseIterable {
    case short = 1.0
    case medium = 2.0
    case long = 3.0
    
    var description: String {
        switch self {
        case .short:
            "短め"
        case .medium:
            "普通"
        case .long:
            "長め"
        }
    }
    
    var isPremiumOnly: Bool {
        switch self {
        case .medium:
            return false
        case .short, .long:
            return true
            
        }
    }
}
