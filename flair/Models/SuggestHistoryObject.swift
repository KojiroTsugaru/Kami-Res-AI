//
//  AIResponseHistory.swift
//  flair
//
//  Created by KJ on 3/15/25.
//

import Foundation
import RealmSwift

class SuggestHistoryObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var chatItems = List<ChatItemObject>()
    @Persisted var createdAt: Date = Date()
}

