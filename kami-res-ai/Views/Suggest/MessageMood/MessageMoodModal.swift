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
    @State private var messageLength: Double
    
    init(showMoodModal: Binding<Bool>, selectedMood: Binding<MessageMood>) {
        self._showMoodModal = showMoodModal
        self._selectedMood = selectedMood
        self._messageLength = State(initialValue: selectedMood.wrappedValue.messageLength.rawValue)
    }

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
                    ForEach(
                        MessageMood.MoodType.allCases,
                        id: \.self
                    ) { moodType in
                        MessageMoodLabel(moodType: .constant(moodType), isSelected: selectedMood.type == moodType)
                            .onTapGesture {
                                withAnimation {
                                    selectedMood.type = moodType
                                }
                            }
                    }
                }
                .padding()
                
                // 選択中のムード説明
                HStack(spacing: 12) {
                    Text(selectedMood.type.emoji)
                        .font(.title2)
                    Text(selectedMood.type.title)
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
                        Text("メッセージの長さ: \(messageLengthText)")
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
                    .onChange(of: messageLength, perform: { newValue in
                        if let newLength = MessageLength(rawValue: newValue) {
                            selectedMood.messageLength = newLength
                        }
                        print("new mood:", selectedMood)
                    })
                }
                .padding()
                .padding(.top, 8)
            
                Button {
                    showMoodModal = false
                } label: {
                    Text("保存する")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(20)
                }.padding(.vertical)
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
    
    private var messageLengthText: String {
        switch selectedMood.messageLength {
        case .short:
            return "短め"
        case .medium:
            return "少し長め"
        case .long:
            return "長め"
        }
    }
}

#Preview {
    MessageMoodModal(
        showMoodModal: Binding.constant(true),
        selectedMood: Binding.constant(MessageMood.defaultMood)
    )
}
