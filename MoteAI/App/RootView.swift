//
//  ContentView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import CoreData

struct RootView: View {
    @AppStorage("isOnboardingSheetShowing") var isOnboardingSheetShowing = true
    
    var body: some View {
        HomeView()
            .sheet(isPresented: $isOnboardingSheetShowing) {
                OnboardingSheetView(isOnboardingSheetShowing: $isOnboardingSheetShowing)
            }
    }
}
