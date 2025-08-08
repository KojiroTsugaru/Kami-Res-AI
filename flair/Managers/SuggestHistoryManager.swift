import SwiftUI
import RealmSwift

class SuggestHistoryManager {
    static let shared = SuggestHistoryManager()
    
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
            
            let realm = try! Realm()
            
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
        
        if let history = realm.object(
            ofType: SuggestHistoryObject.self,
            forPrimaryKey: history.id) {
            try! realm.write {
                let chatItem = ChatItemObject()
                chatItem.textContent = text
                history.chatItems.append(chatItem)
                realm.add(history, update: .modified)
            }
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
            
            if let history = realm.object(
                ofType: SuggestHistoryObject.self,
                forPrimaryKey: history.id) {
                try realm.write {
                    let chatItem = ChatItemObject()
                    chatItem.imagePath = fileURL.path
                    history.chatItems.append(chatItem)
                    realm.add(history, update: .modified)
                }
            }
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
        }
    }
    
    func deleteChatItem(chatItem: ChatItemObject) {
        let realm = try! Realm()
        
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
    
    func deleteHistory(_ history: SuggestHistoryObject) {
        do {
            let realm = try Realm() // Get a new live Realm instance
            
            guard let existingHistory = realm.object(ofType: SuggestHistoryObject.self, forPrimaryKey: history.id) else {
                print("Error: The history object does not exist in this Realm.")
                return
            }

            try realm.write {
                // Delete all images associated with the history
                for chatItem in existingHistory.chatItems {
                    if let imagePath = chatItem.imagePath {
                        deleteImage(at: imagePath)
                    }
                }

                // Delete the history object from Realm
                realm.delete(existingHistory)
                print("History and associated images deleted from Realm")
            }
        } catch {
            print("Failed to delete history: \(error.localizedDescription)")
        }
    }

    func deleteAllSuggestHistoryObjects() {
        do {
            let realm = try Realm()
            try realm.write {
                let allHistoryObjects = realm.objects(SuggestHistoryObject.self)
                realm.delete(allHistoryObjects) // Delete all `SuggestHistoryObject`
            }
            print("All SuggestHistoryObjects deleted.")
        } catch {
            print("Error deleting SuggestHistoryObjects:", error.localizedDescription)
        }
    }
    
    private func deleteImage(at path: String) {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)

        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
                print("Deleted image at: \(url.path)")
            } catch {
                print("Failed to delete image: \(error.localizedDescription)")
            }
        } else {
            print("Image not found at path: \(url.path), skipping deletion")
        }
    }

}
