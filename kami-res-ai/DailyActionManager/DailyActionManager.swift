//
//  DailyActionManager.swift
//  MoteAI
//
//  Created by KJ on 2/1/25.
//

import Foundation

class DailyActionManager: NSObject, ObservableObject {
    
    static let shared = DailyActionManager()
    
    private override init() {
        super.init()
    }
    
    private let userDefaults = UserDefaults.standard
    private let lastActionKey = "lastActionDate"

    /// アクションを実行できるかチェック
    func canPerformAction() -> Bool {
        guard let lastActionDate = userDefaults.object(forKey: lastActionKey) as? Date else {
            return true // 記録がなければ実行可能
        }
        
        return !Calendar.current.isDateInToday(lastActionDate) // 今日と同じ日なら実行不可
    }

    /// アクションを実行し、日付を保存
    func performActionIfNeeded() -> Bool {
        if canPerformAction() {
            saveCurrentDate()
            return true // アクション実行成功
        } else {
            return false // すでに今日実行済み
        }
    }

    /// 現在の日付を保存
    private func saveCurrentDate() {
        userDefaults.set(Date(), forKey: lastActionKey)
    }

    /// デバッグ用：記録をリセット（テスト用）
    func resetActionLimit() {
        userDefaults.removeObject(forKey: lastActionKey)
    }
}

