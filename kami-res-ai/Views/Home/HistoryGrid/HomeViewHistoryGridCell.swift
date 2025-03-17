//
//  HomeViewHistoryGridCell.swift
//  kami-res-ai
//
//  Created by KJ on 3/16/25.
//

import SwiftUI
import RealmSwift

struct HomeViewHistoryGridCell: View {
    let history: SuggestHistoryObject
    @State private var showDeleteConfirmation = false
    
    var thumbnailImage: UIImage? {
        history.chatItems
            .reversed() // Start from latest
            .compactMap { $0.imagePath } // Extract valid image paths
            .compactMap { loadImage(from: $0) } // Convert to UIImage
            .first // Get the first valid image
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                if let image = thumbnailImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image("historyPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-15))
                        .padding(.bottom, 4)
                        .padding(.top, 8)
                    
                    Group {
                        Text(history.createdAt, style: .date)
                            .font(.caption2)
                        Text(history.createdAt, style: .time)
                            .font(.caption2)
                    }.foregroundColor(.gray)
                }
            }
            .frame(width: 100, height: 150)
            .background(Color(.white))
            .cornerRadius(16)
            .shadow(radius: 2)
            
            Button(action: {
                showDeleteConfirmation.toggle()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.black)
                    .background(Circle().fill(Color.white))
                    .clipShape(Circle())
                    .padding(6)
            }
        }
        .alert("履歴を削除しますか？", isPresented: $showDeleteConfirmation) {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                SuggestHistoryManager.shared.deleteHistory(history)
            }
        } message: {
            Text("元に戻すことはできません。\n本当に削除してもよろしいですか？")
        }
    }
    
    private func loadImage(from path: String) -> UIImage? {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)
        
        if fileManager.fileExists(atPath: url.path) {
            print("✅ Image found at path: \(url.path)")
            return UIImage(contentsOfFile: url.path)
        } else {
            print("❌ Image not found at path: \(url.path)")
            return nil
        }
    }
}
