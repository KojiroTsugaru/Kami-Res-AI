//
//  ManuallyEnterMessageViewModel.swift
//  kami-res-ai
//
//  Created by KJ on 2/13/25.
//

import Foundation

class ManuallyEnterMessageViewModel: ObservableObject {
    @Published var recipientName: String?
    @Published var chatHistory: [ChatHistoryItem] = []
    
    private let openAIService = OpenAIService()
    

    /// func to get reply suggestion from manually entered texts.
    func getReplySuggestion() {
        
    }
    
}
