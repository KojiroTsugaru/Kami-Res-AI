import SwiftUI
import RealmSwift

class SuggestHistoryManager {
    static let shared = SuggestHistoryManager()
    private let realm = try! Realm()
    
    func createChatHistoryWithImage(imageData: Data?) -> SuggestHistoryObject? {
        guard let imageData = imageData else { return nil }
        
        let fileManager = FileManager.default
        let fileName = UUID().uuidString + ".jpg"
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            let chatHistory = SuggestHistoryObject()
            let chatItem = ChatItemObject()
            chatItem.imagePath = fileURL.path
            chatHistory.chatItems.append(chatItem)
            
            try realm.write {
                realm.add(chatHistory)
            }
            return chatHistory
        } catch {
            fatalError("Failed to save image: \(error.localizedDescription)")
        }
    }
    
    func addTextMessage(to history: SuggestHistoryObject, text: String) {
        guard !text.isEmpty else { return }
        let realm = try! Realm()
        try! realm.write {
            let chatItem = ChatItemObject()
            chatItem.textContent = text
            history.chatItems.append(chatItem)
            realm.add(history, update: .modified)
        }
    }
    
    func addImageMessage(to history: SuggestHistoryObject, image: UIImage) {
        let fileManager = FileManager.default
        let fileName = UUID().uuidString + ".jpg"
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try imageData.write(to: fileURL)
            let realm = try! Realm()
            try realm.write {
                let chatItem = ChatItemObject()
                chatItem.imagePath = fileURL.path
                history.chatItems.append(chatItem)
                realm.add(history, update: .modified)
            }
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
        }
    }
    
    func deleteChatItem(chatItem: ChatItemObject) {
        try! realm.write {
            if let imagePath = chatItem.imagePath {
                let fileURL = URL(fileURLWithPath: imagePath)
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: fileURL.path) {
                    try? fileManager.removeItem(at: fileURL)
                }
            }
            realm.delete(chatItem)
        }
    }
}
