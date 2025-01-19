//
//  MessageSuggestVM.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation

class MessageSuggestVM: ObservableObject{
    @Published var suggestedMessages: [String]?
    private let openAIService = OpenAIService()
    
    public func getSuggestedMessage(base64Image: String) async {
        do {
            let response = try await openAIService.getSuggestedMesssageFromImage(base64Image: base64Image)
            suggestedMessages?.append(response)
            print("Response: \(response)")
        } catch {
            print("Error: \(error)")
        }
    }
}
