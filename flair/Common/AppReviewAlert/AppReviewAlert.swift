//
//  AppReviewAlert.swift
//  flair
//
//  Created by KJ on 3/30/25.
//

import Foundation

enum AppReviewAlert: Identifiable {
    case initial, review, feedback
    var id: Self { self }
    
    // MARK: - Alert Content
    var title: String {
        switch self {
        case .initial:
            return "神レスAIを楽しんでいますか？"
        case .review:
            return "ありがとうございます！"
        case .feedback:
            return "ぜひご意見をお聞かせ下さい"
        }
    }
    
    var message: String? {
        switch self {
        case .initial:
            return nil
        case .review:
            return "レビューしていただけると\nとても励みになります"
        case .feedback:
            return "アプリ改善のための参考にさせていただきます"
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .initial:
            return "あんまり..."
        case .review:
            return "あとで"
        case .feedback:
            return "閉じる"
        }
    }
    
    var secondaryButtonTitle: String {
        switch self {
        case .initial:
            return "はい！"
        case .review:
            return "星をつける"
        case .feedback:
            return "意見を送る"
        }
    }
    
    // MARK: - Button Actions
    func primaryAction(completion: @escaping (AppReviewAlert?) -> Void) -> () -> Void {
        switch self {
        case .initial:
            // Choose "あんまり..." → show feedback alert
            return { completion(.feedback) }
        case .review:
            // "あとで": mark as shown and finish
            return {
                ReviewAlertManager.shared.markReviewShown()
                completion(nil)
            }
        case .feedback:
            // "閉じる": mark as shown and finish
            return {
                ReviewAlertManager.shared.markReviewShown()
                completion(nil)
            }
        }
    }
    
    func secondaryAction(completion: @escaping (AppReviewAlert?) -> Void) -> () -> Void {
        switch self {
        case .initial:
            // Choose "はい！" → show star rating alert
            return { completion(.review) }
        case .review:
            // "星をつける": go to review page and finish
            return {
                ReviewAlertManager.shared.goToReviewPage()
                completion(nil)
            }
        case .feedback:
            // "意見を送る": open mail app and finish
            return {
                ReviewAlertManager.shared.openMailApp()
                completion(nil)
            }
        }
    }
}
