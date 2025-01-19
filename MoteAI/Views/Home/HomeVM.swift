//
//  HomeViewModel.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation
import PhotosUI
import SwiftUI

final class HomeVM: ObservableObject {
    
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var image: UIImage? = nil
    @Published var base64String: String = ""
    @Published var errorMessage: String = ""
    
    /// Loads the selected photo and encodes it to Base64
    @MainActor
    public func loadAndEncodePhoto(from item: PhotosPickerItem) async {
        do {
            // Load image data
            if let data = try await item.loadTransferable(type: Data.self) {
                // Create a UIImage
                if let uiImage = UIImage(data: data) {
                    self.image = uiImage
                        
                    // Encode the image data to Base64
                    self.base64String = data.base64EncodedString()
                    
                } else {
                    self.errorMessage = "Failed to decode the selected photo."
                }
            } else {
                self.errorMessage = "Failed to load the selected photo."
            }
        } catch {
            self.errorMessage = "An error occurred: \(error.localizedDescription)"
        }
    }
}
