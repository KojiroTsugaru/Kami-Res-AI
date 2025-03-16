//
//  ChatItemObject.swift
//  kami-res-ai
//
//  Created by KJ on 3/15/25.
//

import SwiftUI
import RealmSwift

class ChatItemObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var textContent: String? // For text messages
    @Persisted var imagePath: String? // For image messages
}
