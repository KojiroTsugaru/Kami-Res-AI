//
//  HomeViewHistoryGridCell.swift
//  kami-res-ai
//
//  Created by KJ on 3/16/25.
//

import SwiftUI

struct HomeViewHistoryGridCell: View {
    let history: SuggestHistoryObject
    
    var thumbnailImage: UIImage? {
        history.chatItems
            .reversed() // Start from latest
            .compactMap { $0.imagePath } // Extract valid image paths
            .compactMap { loadImage(from: $0) } // Convert to UIImage
            .first // Get the first valid image
    }
    
    var body: some View {
        
        VStack {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                
                Text(history.createdAt, style: .date)
                    .font(.caption)
            }
        }
        .frame(width: 100, height: 150)
        .background(Color(.white))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func loadImage(from path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        return UIImage(contentsOfFile: url.path)
    }
}
