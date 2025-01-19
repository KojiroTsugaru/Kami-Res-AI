//
//  MessageSuggestView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import Kingfisher

struct MessageSuggestView: View {
    let base64Image: String?
    let image: UIImage?
    
    @ObservedObject private var viewModel = MessageSuggestVM()
        
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                // Display the UIImage if available
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200) // Adjust the height as needed
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }

                Text("タップしてコピー")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if let suggestedMessages = viewModel.suggestedMessages {
                    ForEach(suggestedMessages, id: \.self) { message in
                        MessageBubbleView(message: message)
                    }
                }
            }
        }
        .task {
            await viewModel.getSuggestedMessage(base64Image: base64Image ?? "")
        }
    }
}
