//
//  MessageSuggestVM.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation
import UIKit

class MessageSuggestVM: ObservableObject{
    @Published var suggestedMessages: [String] = []
    private let openAIService = OpenAIService()
    
    @MainActor
    public func getSuggestedMessage(base64Image: String) async {
        // Add a loading placeholder message
        suggestedMessages.append("Loading")
        
        do {
            let response = try await openAIService.getSuggestedMesssageFromImage(base64Image: base64Image)
            
            // Remove the loading message
            if let loadingIndex = suggestedMessages.firstIndex(of: "Loading") {
                suggestedMessages.remove(at: loadingIndex)
            }
            
            // Add the actual response
            suggestedMessages.append(response)
            print("Response: \(response)")
        } catch {
            print("Error: \(error)")
            
            // Remove the loading message and add an error message
            if let loadingIndex = suggestedMessages.firstIndex(of: "Loading") {
                suggestedMessages.remove(at: loadingIndex)
            }
            suggestedMessages.append("Failed to load suggestions. Please try again.")
        }
    }
    
    public func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}
