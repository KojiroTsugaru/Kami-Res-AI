//
//  Constants.swift
//  MoteAI
//
//  Created by KJ on 1/25/25.
//

import Foundation

struct Constants {
    /// Looding message for chatItem
    public static let loadingMessage = "Loading"
}


/// openAI
extension Constants {
    
    public struct AccessToken {
        /// OpenAI API Key
        public static let openAI = "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"
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
