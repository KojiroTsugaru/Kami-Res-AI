//
//  MoteAIApp.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import SuperwallKit

@main
struct KamiResAIApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        Superwall.configure(apiKey: Constants.AccessToken.superWall)
        setGlobalNavigationBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func setGlobalNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear] // タイトルの色（変更可能）

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
    }
}
