//
//  MessageSuggestVM.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation
import PhotosUI
import SuperwallKit
import SwiftUI
import UIKit

class ScreenshotMessageSuggestVM: ObservableObject {
    static let networkErrorMessage = "返信を取得できませんでした。接続を確認し、やりなおしてください。"
    
    private let openAIService = OpenAIService()
    private let loadingMessage = Constants.loadingMessage
    private let historyManager =  SuggestHistoryManager.shared
    
    @Published var history: SuggestHistoryObject
    
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var errorMessage: String = ""
    @Published var latestImageData: Data? = nil
    @Published var messageMood: MessageMood = MessageMood.defaultMood
    @Published var isLoading: Bool = false
    
    @MainActor
    init(with suggestHistory: SuggestHistoryObject) {
        self.history = suggestHistory
        setLatestImageQuery(with: suggestHistory)
    }

    func addMessage(text: String) {
        historyManager.addTextMessage(to: history, text: text)
    }

    func addImage(image: UIImage) {
        historyManager.addImageMessage(to: history, image: image)
    }
    
    @MainActor
    func setLatestImageQuery(with history: SuggestHistoryObject) {
        if let latestImageItem = history.chatItems.filter({ $0.imagePath != nil }).last,
           let imagePath = latestImageItem.imagePath,
           let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) {
            latestImageData = imageData
        }
    }

    @MainActor
    public func getSuggestedMessage() async {
        errorMessage = ""
        isLoading = true
        do {
            guard let latestImageData = latestImageData else { return }
            
            let response = try await openAIService.getSuggestedReplyFromImage(
                imageData: latestImageData,
                messageMood: messageMood
            )

            // Add the response to chat item
            self.addMessage(text: response)
            isLoading = false
            print("Response: \(response)")
        } catch {
            isLoading = false
            errorMessage = Self.networkErrorMessage
            print("Error: \(error)")
        }
    }
    
    @MainActor
    func handleNewPhotoSelection(_ newItem: PhotosPickerItem?) async {
        guard let newItem = newItem else { return }
        
        do {
            // 画像データを取得
            if let data = try await newItem.loadTransferable(type: Data.self) {
                // Data を UIImage に変換
                if let image = UIImage(data: data) {
                    addImage(image: image)
                    setLatestImageQuery(with: history)
                    await generateResponseIfNeeded()
                }
            }
        } catch {
            self.errorMessage = "An error occurred: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func handleViewAppear() async {
        if history.chatItems.count == 1 && history.chatItems.first?.imagePath != nil {
            await generateResponseIfNeeded()
        }
    }

    public func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }

    public func generateResponseIfNeeded() async {
        if DailyActionManager.shared.performActionIfNeeded() {
            await self.getSuggestedMessage()
            print("Action remained today: \(DailyActionManager.shared.getCurrentActionCount())")
        } else {
            Superwall.shared.register(event: "campaign_trigger")
        }
    }
    
    public func actionRemainedForTodayString() -> String {
        let actionManager = DailyActionManager.shared
        if actionManager.isUserSubscribed() {
            return "返信を無制限に生成できます🙌"
        } else {
            return
                "今日はあと\(String(describing: actionManager.getCurrentRemainedActionCount()))回返信を生成できます"
        }
    }
}
