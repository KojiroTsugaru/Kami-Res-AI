//
//  HomeViewModel.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation
import PhotosUI
import SwiftUI
import SuperwallKit

@MainActor
final class HomeVM: ObservableObject {
    
    let historyManager = SuggestHistoryManager.shared
    
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var image: UIImage? = nil
    @Published var errorMessage: String = ""
    @Published var newHistory: SuggestHistoryObject?
    @Published var navigateToSuggestView: Bool = false
    @Published var navigateToManuallyType: Bool = false
    
    func convertPhotoPickerItemToJpegData(_ item: PhotosPickerItem) async -> Data? {
        do {
            // 画像データを取得
            if let data = try await item.loadTransferable(type: Data.self) {
                // Data を UIImage に変換
                if let image = UIImage(data: data) {
                    // UIImage を PNG に変換
                    return image.jpegData(compressionQuality: 0.5)
                }
            }
        } catch {
            self.errorMessage = "An error occurred: \(error.localizedDescription)"
        }
        return nil
    }
    
    func didPhotoPicked(_ item: PhotosPickerItem) async {
        guard let jpegData = await convertPhotoPickerItemToJpegData(item) else { return }
        
        // Ensure the UI update happens on the main thread
        await MainActor.run {
            if let newHistory = historyManager.createChatHistoryWithImage(imageData: jpegData) {
                self.newHistory = newHistory
                self.navigateToSuggestView.toggle()
            }
        }
    }

    public func showPaywallIfNeeded() {
        if !DailyActionManager.shared.canPerformAction() {
            Superwall.shared.register(event: "campaign_trigger") // Superwall で課金ページを表示
        }
    }
    
    public func refreshViewModel() {
        self.image = nil
        self.errorMessage = ""
    }
}
