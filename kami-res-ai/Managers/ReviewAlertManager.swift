//
//  ReviewAlertManager.swift
//  kami-res-ai
//
//  Created by KJ on 3/22/25.
//

import Foundation
import UIKit

class ReviewAlertManager {
    static let shared = ReviewAlertManager()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let lastReviewPromptDateKey = "lastReviewPromptDate"
    private let hasWrittenReviewKey = "hasWrittenReview"
    private let generateActionCountKey = "generateActionCount"
    
    private let oneMonthInSeconds: Double = 60 * 60 * 24 * 30
    private let generateCountToShowAlert = 4

    /// Call this from your view to determine whether to show the alert
    func shouldShowAlert() -> Bool {
        guard !userDefaults.bool(forKey: hasWrittenReviewKey) else { return false }
        guard userDefaults.integer(forKey: generateActionCountKey) > generateCountToShowAlert else { return false }
        
        let now = Date().timeIntervalSince1970
        let lastPrompt = userDefaults.double(forKey: lastReviewPromptDateKey)
        
        return (now - lastPrompt) > oneMonthInSeconds
    }
    
    /// Call this when the user taps the "Review" button
    func goToReviewPage() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6741389098?action=write-review") else { return }
        if UIApplication.shared.canOpenURL(writeReviewURL) {
            UIApplication.shared.open(writeReviewURL)
        }
        markReviewShown()
    }
    
    /// Call this when the alert is shown or dismissed (optional)
    func markReviewShown() {
        let now = Date().timeIntervalSince1970
        userDefaults.set(now, forKey: lastReviewPromptDateKey)
    }
    
    /// Call this if you want to permanently suppress future alerts
    func markReviewCompleted() {
        userDefaults.set(true, forKey: hasWrittenReviewKey)
    }
    
    /// When user wants to send feecback
    func openMailApp(to recipient: String = "ktsugaru.dev@gmail.com", subject: String = "神レスAIへのご意見") {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(recipient)?subject=\(subjectEncoded)"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func incrementGenerateActionCount() {
        let newVal = userDefaults.integer(forKey: generateActionCountKey) + 1
        userDefaults.set(newVal, forKey: hasWrittenReviewKey)
    }
}
