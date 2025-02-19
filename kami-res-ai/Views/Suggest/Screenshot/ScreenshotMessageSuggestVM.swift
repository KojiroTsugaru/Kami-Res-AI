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
    private let openAIService = OpenAIService()
    private let loadingMessage = Constants.loadingMessage

    @Published var chatItems: [ChatItem] = []
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var errorMessage: String = ""
    @Published var base64Image: String?
    @Published var messageMood: MessageMood = MessageMood.defaultMood

    func addMessage(text: String) {
        self.chatItems.append(.message(text))
    }

    func addImage(image: UIImage) {
        self.chatItems.append(.image(image))
    }

    @MainActor
    public func getSuggestedMessage() async {
        // Add a loading placeholder message
        self.addMessage(text: loadingMessage)

        do {
            let response = try await openAIService.getSuggestedReplyFromImage(
                base64Image: base64Image ?? "",
                prompt: messageMood.prompt
            )

            self.removeLoadingMessage()

            // Add the response to chat item
            self.addMessage(text: response)
            print("Response: \(response)")
        } catch {
            print("Error: \(error)")

            self.removeLoadingMessage()
            self.addMessage(text: "レスポンスの取得に失敗しました。通信環境を確認し、再試行してください。")
        }
    }

    /// Loads the selected photo and encodes it to Base64
    @MainActor
    public func loadAndEncodePhoto(from item: PhotosPickerItem) async {
        do {
            // Load image data
            if let data = try await item.loadTransferable(type: Data.self) {
                // Create a UIImage
                if let uiImage = UIImage(data: data) {

                    // add image to chatItem
                    self.addImage(image: uiImage)

                    // Encode the image data to Base64
                    self.base64Image = data.base64EncodedString()

                    try? await Task
                        .sleep(for: .seconds(0.5))  // Wait for 0.5 seconds
                    await self.generateResponseIfNeeded()

                } else {
                    self.errorMessage = "画像のアップロードに失敗しました"
                }
            } else {
                self.errorMessage = "写真のロードに失敗しました"
            }
        } catch {
            self.errorMessage = "An error occurred: \(error.localizedDescription)"
        }
    }

    private func removeLoadingMessage() {
        // Remove the loading message
        guard isLoadingMessage() else {
            return
        }

        if let loadingIndex = chatItems.firstIndex(where: {
            if case .message(let text) = $0, text == loadingMessage {
                return true
            }
            return false
        }) {
            self.chatItems.remove(at: loadingIndex)
        }
    }

    private func isLoadingMessage() -> Bool {
        if let lastItem = chatItems.last, case .message("Loading") = lastItem {
            return true
        }
        return false
    }

    public func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }

    public func generateResponseIfNeeded() async {
        guard !isLoadingMessage() else {
            return
        }

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
