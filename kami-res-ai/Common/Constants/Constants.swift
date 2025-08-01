//
//  Constants.swift
//  MoteAI
//
//  Created by KJ on 1/25/25.
//

import Foundation
import SwiftUICore

struct Constants {
    /// Looding message for chatItem
    public static let loadingMessage = "Loading"
    
    public static let onboardingPages: [OnboardingPage] = [
        OnboardingPage(
            label: "ようこそ",
            text: "旅先に合わせた地元の料理やレストランを簡単に見つけましょう。",
            image: "welcome_image"
        ),
        OnboardingPage(
            label: "検索",
            text: "都市名を入力するだけで、おすすめの地元料理をすぐに見つけられます。",
            image: "search_image"
        ),
        OnboardingPage(
            label: "お気に入り",
            text: "お気に入りの料理やレストランを保存して、いつでもアクセス可能。",
            image: "favorites_image"
        )
    ]
}

extension Constants {
    public struct ColorAsset {
        static let primaryColor = Color("gradientPrimary")
        static let secondaryColor = Color("gradientSecondary")
        
        
        public static let primaryGradient: LinearGradient = {
            // Define the gradient colors from the asset catalog
            let colors = [
                secondaryColor,
                primaryColor
            ]
            return LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .top,    // Starting point of the gradient
                endPoint: .bottom    // Ending point of the gradient
            )
        }()
        
        public static func createGradient(from startPoint: UnitPoint, to endPoint: UnitPoint) -> LinearGradient {
            let colors = [
                Color("gradientSecondary"),// Replace with your actual color name
                Color("gradientPrimary")   // Replace with your actual color name
            ]
            return LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,    // Starting point of the gradient
                endPoint: endPoint    // Ending point of the gradient
            )
        }
    }
}
