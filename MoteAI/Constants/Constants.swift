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

/// openAI
extension Constants {
    
    public struct AccessToken {
        /// OpenAI API Key
        public static let openAI = "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"
        
        public static let superWall = "pk_04123874dc7c2cbb917980ceca251d4a77368dc551838c88"
    }
    
    /// set prompt here
    public static let openAIPrompt =
    """
        #前提
        ・この画像はあなたが仲良くなりたい思っている相手とのチャットのスクリーンショットです。
    
        #あなたの役割
        ・次に送るべき、相手の気を引く返信を考えてください。
        ・日常生活で自然な会話をしてください。
    
        #守らなければいけない制約
        ・日本語で必ず回答すること。
        ・"「", "」"を使わないでください。
    """
}

extension Constants {
    public struct ColorAsset {
        public static let primaryGradient: LinearGradient = {
            // Define the gradient colors from the asset catalog
            let colors = [
                Color(
                    "gradientSecondary"
                ),// Replace with your actual color name
                Color(
                    "gradientPrimary"
                )   // Replace with your actual color name
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
