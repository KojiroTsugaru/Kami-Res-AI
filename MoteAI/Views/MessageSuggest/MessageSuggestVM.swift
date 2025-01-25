//
//  MessageSuggestVM.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

class MessageSuggestVM: ObservableObject{
    private let openAIService = OpenAIService()
    private let loadingMessage = Constants.loadingMessage
    
    @Published var chatItems: [ChatItem] = []
    @Published var addedPhotos: [UIImage?] = [] // added photos
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var errorMessage: String = ""
    
    func addMessage(text: String) {
        chatItems.append(.message(text))
    }
    
    func addImage(image: UIImage) {
        chatItems.append(.image(image))
    }
    
    @MainActor
    public func getSuggestedMessage(from base64Image: String) async {
        // Add a loading placeholder message
        self.addMessage(text: loadingMessage)
        
        do {
            let response = try await openAIService.getSuggestedMesssageFromImage(
                base64Image: base64Image
            )
            
            removeLoadingMessage()
            
            // Add the response to chat item
            self.addMessage(text: response)
            print("Response: \(response)")
        } catch {
            print("Error: \(error)")
            
            removeLoadingMessage()
            addMessage(text: "Failed to load suggestions. Please try again.")
        }
    }
    
    /// Loads the selected photo and encodes it to Base64
    @MainActor
    public func loadAndEncodePhoto(from item: PhotosPickerItem) async -> String? {
        do {
            // Load image data
            if let data = try await item.loadTransferable(type: Data.self) {
                // Create a UIImage
                if let uiImage = UIImage(data: data) {
                    
                    // add image to chatItem
                    self.addImage(image: uiImage)
                    
                    // Encode the image data to Base64
                    let base64Image = data.base64EncodedString()
                    return base64Image
                    
                } else {
                    self.errorMessage = "Failed to decode the selected photo."
                    return nil
                }
            } else {
                self.errorMessage = "Failed to load the selected photo."
                return nil
            }
        } catch {
            self.errorMessage = "An error occurred: \(error.localizedDescription)"
            return nil
        }
    }
    
    func getSuggestedMessageAfterPhotoAdded(from item: PhotosPickerItem) async {
        if let base64Image = await loadAndEncodePhoto(from: item) {
            await self.getSuggestedMessage(from: base64Image)
        } else {
            return
        }
    }
    
    // Remove the loading message and add an error message
    private func removeLoadingMessage() {
        if let loadingIndex = chatItems.firstIndex(where: {
            if case .message(let text) = $0, text == loadingMessage {
                return true
            }
            return false
        }) {
            chatItems.remove(at: loadingIndex)
        }
    }
    
    public func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}
