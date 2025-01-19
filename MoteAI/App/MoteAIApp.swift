//
//  MoteAIApp.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI

@main
struct MoteAIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
