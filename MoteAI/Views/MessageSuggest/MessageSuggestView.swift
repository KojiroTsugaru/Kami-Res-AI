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
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .padding()
                } else {
                    ProgressView("Loading Image...")
                        .padding()
                }

                Text("-- メッセージをタップしてコピー --")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                VStack(alignment: .trailing) {
                    ForEach(viewModel.suggestedMessages, id: \.self) { message in
                        HStack {
                            Spacer() // Push the content to the trailing edge
                            MessageBubbleView(message: message)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.getSuggestedMessage(base64Image: base64Image ?? "")
        }
    }
}
