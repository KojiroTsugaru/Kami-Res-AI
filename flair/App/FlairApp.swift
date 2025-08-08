//
//  MoteAIApp.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import SuperwallKit

@main
struct FlairApp: App {
    
    init() {
        Superwall.configure(apiKey: Env.superwallAccessToken)
        setGlobalNavigationBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
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
