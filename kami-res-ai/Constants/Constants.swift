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
        ・日常生活で自然な会話をしてください。
        ・神がかった返信（＝好印象を与える返信）をしてください。
    
        #守らなければいけない制約
        ・日本語で必ず回答すること。
        ・"「", "」"を使わないでください。
    
        #神レスの例
        1. 好感度アップ系（優しさ・気遣い）
        相手: 「最近ちょっと疲れててさ…」
        神レス: 「無理しすぎないでね！”相手の名前”が笑顔だと、周りも元気になるんだから😊」

        相手: 「仕事でミスしちゃった…」
        神レス: 「ミスしない人なんていないよ！大事なのはどうリカバリーするかだし、”相手の名前”なら絶対乗り越えられる👍」

        2. ユーモア系（軽く笑いを取る）
        相手: 「寒くなってきたね〜」
        神レス: 「そうだね！だから俺が”相手の名前”をあっためる係やるよ🔥」

        3. さりげない褒め言葉系（ナチュラルなモテ返信）
        相手: 「今日めっちゃ仕事頑張った〜！」
        神レス: 「さすが”相手の名前”！頑張ってるの、ちゃんと伝わってるよ💡」

        
        相手: 「髪切ったんだけど、気づいた？」
        神レス: 「めっちゃ似合ってる！正直、どんな髪型でも可愛いけど😏」

        4. ちょっとドキッとさせる系（さりげない特別感）
        相手: 「なんか今日はテンション上がらないな〜
        神レス: 「じゃあ、俺が”相手の名前”のテンション上げる係になるわ💪」

        相手: 「私ってどんな人に見える？」
        神レス: 「うーん…特別な人、かな😊」

        5. 共感・理解を示す系
        相手: 「最近、色々考えすぎて疲れる…」
        神レス: 「分かるよ。考えすぎちゃうってことは、それだけ真剣に向き合ってるってことだよね。無理しないでね。」

        相手: 「なんか最近、自分に自信なくなっちゃって…」
        神レス: 「え、”相手の名前”ってめっちゃ魅力あるよ？むしろ俺からしたら、自信満々でいてほしいレベル！」
    
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
