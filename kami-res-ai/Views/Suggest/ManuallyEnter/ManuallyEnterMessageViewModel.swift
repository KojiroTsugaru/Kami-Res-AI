//
//  ManuallyEnterMessageViewModel.swift
//  kami-res-ai
//
//  Created by KJ on 2/13/25.
//

import Foundation

class ManuallyEnterMessageViewModel: ObservableObject {
    
    private let openAIService = OpenAIService()
    private let loadingMessage = Constants.loadingMessage
    
    @Published var recipientName: String?
    @Published var chatHistory: [ChatHistoryItem] = []
    @Published var messageMood: MessageMood = MessageMood.defaultMood
    @Published var errorMessage: String?
    
    /// func to get reply suggestion from manually entered texts.
    @MainActor
    public func generateReplySuggestion() async throws {
        
        if !isValidInput() {
            return
        }
        
        async let reply = try await openAIService
            .getSuggestedReply(
                recipientName: recipientName!, // validated in validate method
                chatHistory: chatHistory
            )
        try await chatHistory
            .append(ChatHistoryItem(message: reply, sender: .api))
    }
    
    @MainActor
    public func addChatHistory(text: String, sender: ChatHistorySender) {
        if errorMessage == "相手の名前を入力してください。" {
            return
        } else if errorMessage == "会話履歴がありません。メッセージを入力してください。" {
            errorMessage = nil
        }
        
        let item = ChatHistoryItem(
            message: text,
            sender: sender
        )
        chatHistory.append(item)
    }
    
    private func isValidInput() -> Bool {
        guard let recipientName, !recipientName.isEmpty else {
            self.errorMessage = "相手の名前を入力してください。"
            return false
        }
        
        guard !chatHistory.isEmpty else {
            self.errorMessage = "会話履歴がありません。メッセージを入力してください。"
            return false
        }
        
        self.errorMessage = nil
        
        return true
    }
}
