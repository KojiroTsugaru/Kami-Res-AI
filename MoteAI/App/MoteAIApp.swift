//
//  MoteAIApp.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import SuperwallKit

@main
struct MoteAIApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        Superwall.configure(apiKey: Constants.AccessToken.superWall)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
