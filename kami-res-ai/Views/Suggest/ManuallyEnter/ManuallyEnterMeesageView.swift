//
//  Manually.swift
//  kami-res-ai
//
//  Created by KJ on 2/13/25.
//

import SwiftUI

struct ManuallyEnterMeesageView: View {
    @StateObject private var viewModel = ManuallyEnterMessageViewModel()
    @State private var theirName: String = ""
    @State private var theirMessage: String = ""
    @State private var myMessage: String = ""
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 24) {
                    TextField("相手の名前", text: $theirName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 3)
                        .frame(width: 160)
                        .padding(.horizontal)
                        .padding(.top, 80)
                        .onSubmit {
                            if !theirName.isEmpty {
                                viewModel.recipientName = theirName
                                viewModel.errorMessage = nil
                            }
                        }
                    
                    // エラーメッセージ表示
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .bold()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.chatHistory) { item in
                            ManuallyEnterMessageBubbleView(chatItem: item)
                        }
                    }
                    
                    /// for new input for their message
                    HStack {
                        TextField("相手のメッセージ", text: $theirMessage)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 3)
                            .frame(width: 240)
                            .onSubmit {
                                if !theirMessage.isEmpty {
                                    viewModel
                                        .addChatHistory(
                                            text: theirMessage,
                                            sender: .recipient(theirName)
                                        )
                                }
                                theirMessage = ""
                            }
                        Spacer()
                    }.padding(.horizontal)
                    
                    /// for new input for user's message
                    HStack {
                        Spacer()
                        TextField("自分のメッセージ", text: $myMessage)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 3)
                            .frame(width: 240)
                            .onSubmit {
                                if !myMessage.isEmpty {
                                    viewModel.chatHistory.append(
                                            ChatHistoryItem(
                                                message: myMessage,
                                                sender: .user
                                            )
                                        )
                                }
                                myMessage = ""
                            }
                    }.padding(.horizontal)
                    Spacer()
                }
            }
            VStack {
                GenerateMoreButton
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                GradientBackButton()
            }
        }
        .background(BackgroundGradient)
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
    }
    
    
    // 背景
    private var BackgroundGradient: some View {
        Constants.ColorAsset
            .createGradient(from: .bottom, to: .top)
            .opacity(0.3)
    }
    
    private var GenerateMoreButton: some View {
        Button {
            Task {
                try await viewModel.generateReplySuggestion()
            }
        } label: {
            GradientText("返信を生成",
                         font: .subheadline,
                         gradient: Constants.ColorAsset
                .createGradient(from: .topLeading, to: .bottomTrailing))
            .bold()
            .padding()
            .frame(maxWidth: 240)
            .background(Color(.black))
            .cornerRadius(24)
        }
    }
    
}

#Preview {
    ManuallyEnterMeesageView()
}
