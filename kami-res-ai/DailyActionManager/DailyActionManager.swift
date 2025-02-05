//
//  DailyActionManager.swift
//  MoteAI
//
//  Created by KJ on 2/1/25.
//

import Foundation
import SuperwallKit

class DailyActionManager: NSObject, ObservableObject {
    
    static let shared = DailyActionManager()
    
    private override init() {
        super.init()
    }
    
    private let userDefaults = UserDefaults.standard
    private let lastActionKey = "lastActionDate"
    private let currentActionCountKey = "currentActionCount"
    
    private let maxActionsPerDay = 2 // 1日に実行できる最大回数
    private let isUserSubscribed = Superwall.shared.subscriptionStatus == .active

    /// アクションを実行できるかチェック
    func canPerformAction() -> Bool {
        
        /// プレミアムプランに入っていたら回数を無制限に許可
        if isUserSubscribed {
            return true
        }
        
        // 最後のアクション日を取得
        let lastActionDate = userDefaults.object(forKey: lastActionKey) as? Date
        
        // 昨日以前ならカウントをリセット
        if let lastActionDate = lastActionDate, !Calendar.current.isDateInToday(lastActionDate) {
            resetActionCount()
        }
        
        // 現在のカウントを取得
        let currentActionCount = getCurrentActionCount()
        
        // 上限に達していなければ実行可能
        return currentActionCount < maxActionsPerDay
    }

    /// アクションを実行し、日付と回数を保存
    func performActionIfNeeded() -> Bool {
        if isUserSubscribed {
            return true
        } else if canPerformAction() {
            increaseActionCount()
            return true // アクション実行成功
        } else {
            return false // 上限に達している
        }
    }

    /// アクション回数を減らす
    /// エラーが起こった時に呼び出す
    func decreaseActionCount() {
        if getCurrentActionCount() > 0 {
            let newCount = userDefaults.integer(forKey: currentActionCountKey) - 1
            userDefaults.set(newCount, forKey: currentActionCountKey)
            userDefaults.set(Date(), forKey: lastActionKey) // 日付も更新
        }
    }
    
    /// アクション回数を増加
    private func increaseActionCount() {
        let newCount = userDefaults.integer(forKey: currentActionCountKey) + 1
        userDefaults.set(newCount, forKey: currentActionCountKey)
        userDefaults.set(Date(), forKey: lastActionKey) // 日付も更新
    }

    /// アクション回数をリセット（翌日用）
    private func resetActionCount() {
        userDefaults.set(0, forKey: currentActionCountKey)
    }

    /// デバッグ用：記録をリセット（テスト用）
    public func resetActionLimit() {
        userDefaults.removeObject(forKey: lastActionKey)
        userDefaults.removeObject(forKey: currentActionCountKey)
    }
    
    public func getCurrentActionCount() -> Int {
        return userDefaults.integer(forKey: currentActionCountKey)
    }
    
    public func getCurrentRemainedActionCount() -> Int {
        return maxActionsPerDay - getCurrentActionCount()
    }
}

