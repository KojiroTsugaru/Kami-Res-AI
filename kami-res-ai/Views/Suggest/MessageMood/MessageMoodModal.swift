//
//  MessageMoodMo.swift
//  kami-res-ai
//
//  Created by KJ on 2/19/25.
//

import SwiftUI

struct MessageMoodModal: View {
    @Binding var showMoodModal: Bool
    @Binding var selectedMood: MessageMood
    @State private var messageLength: Double = 2.0

    var body: some View {
        ZStack {
            // Dark background
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showMoodModal = false  // Dismiss when tapping outside
                }

            // Modal
            VStack(spacing: 12) {
                Text("メッセージの雰囲気を選択")
                    .font(.headline)
                    .padding()
                    .padding(.bottom, 8)
                
                // Moodの選択部分を複数行に対応
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 70, maximum: 80), spacing: 20)
                    ],
                    spacing: 20
                ) {
                    ForEach(MessageMood.allCases, id: \.self) { mood in
                        MessageMoodLabel(mood: .constant(mood), isSelected: selectedMood == mood)
                            .onTapGesture {
                                withAnimation {
                                    selectedMood = mood
                                }
                            }
                    }
                }
                .padding()
                
                // 選択中のムード説明
                HStack(spacing: 12) {
                    Text(selectedMood.emoji)
                        .font(.title2)
                    Text(selectedMood.text)
                        .foregroundColor(.black)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // メッセージの長さ
                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(.gray)
                        Text("メッセージの長さ")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Slider(
                        value: $messageLength,
                        in: 1.0...3.0,
                        step: 1.0
                    )
                    .tint(Color(.black))
                    .frame(width: 280)
                    .shadow(color: Color.gray.opacity(0.2), radius: 4)
                }
                .padding()
                .padding(.top, 8)
            
                Button {
                    showMoodModal = false
                } label: {
                    Text("保存する")
                        .foregroundColor(.black)
                }.padding()
            }
            .frame(maxWidth: 320)  // 最大幅を設定
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
        }
        .transition(.opacity)  // Smooth fade-in transition
        .animation(.easeInOut, value: showMoodModal)
    }
}

#Preview {
    MessageMoodModal(
        showMoodModal: Binding.constant(true),
        selectedMood: Binding.constant(MessageMood.defaultMood)
    )
}
