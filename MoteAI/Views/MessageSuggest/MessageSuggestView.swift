//
//  MessageSuggestView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import PhotosUI

struct MessageSuggestView: View {
    let base64Image: String?
    let image: UIImage?
    
    @ObservedObject private var viewModel = MessageSuggestVM()
    
    @State private var showCopyConfirmation: Bool = false
        
    var body: some View {
        ZStack {
            VStack {
                ScrollViewReader { proxy in
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
                                Spacer()
                                    .frame(height: 100)
                                ProgressView("画像をロード中...")
                                .padding()                }
                            
                            Text("-- メッセージをタップしてコピー --")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .trailing) {
                                ForEach(
                                    viewModel.suggestedMessages,
                                    id: \.self
                                ) { message in
                                    HStack {
                                        Spacer() // Push the content to the trailing edge
                                        MessageBubbleView(message: message)
                                            .onTapGesture {
                                                viewModel.copyToClipboard(text: message)
                                                showCopyConfirmation = true
                                                
                                                // Hide confirmation after 2 seconds
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    showCopyConfirmation = false
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        // スクロールが表示されたときに、一番下にスクロール
                        if let lastItem = viewModel.suggestedMessages.last {
                            proxy.scrollTo(lastItem, anchor: .bottom)
                        }
                    }
                }
                
                VStack {
                    Button {
                        Task {
                            await viewModel.getSuggestedMessage(base64Image: base64Image ?? "")
                        }
                    } label: {
                        Text("もっと返信を生成")
                            .foregroundColor(.black)
                            .bold()
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(24)
                    }
                    
                    Text("あと3回返信を生成できます")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.bottom, 16)
                }
            }
            
            if showCopyConfirmation {
                Text("メッセージをコピーしました！")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .background(.white)
                    .cornerRadius(24)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Leading button tapped")
                }) {
                    Image(systemName: "plus")
                        .bold()
                }
            }
        }
        .task {
            await viewModel.getSuggestedMessage(base64Image: base64Image ?? "")
        }
        .ignoresSafeArea(.all)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [.cyan.opacity(0.5), .accentColor.opacity(0.5)]
                ),
                startPoint: .top,
                // Starting point of the gradient
                endPoint: .bottom // Ending point of the gradient
            )
        )
        .onAppear {
            // Make navigation bar transparent when the view appears
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear // Make it clear
            appearance.shadowColor = .clear // Remove the shadow line
                    
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .onDisappear {
            // Reset navigation bar appearance when the view disappears
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
