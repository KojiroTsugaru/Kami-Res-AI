//
//  MessageMoodMo.swift
//  flair
//
//  Created by KJ on 2/19/25.
//

import SwiftUI
import SuperwallKit

struct MessageMoodModal: View {
    @Binding var showMoodModal: Bool
    @Binding var currentConfig: MessageConfiguration
    @State private var selectedMood: MessageMood
    @State private var selectedLength: MessageLength
    
    init(showMoodModal: Binding<Bool>, currentConfig: Binding<MessageConfiguration>) {
        self._showMoodModal = showMoodModal
        self._currentConfig = currentConfig
        _selectedMood = State(initialValue: currentConfig.mood.wrappedValue)
        _selectedLength = State(initialValue: currentConfig.length.wrappedValue)
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
                HStack {
                    Button {
                        showMoodModal = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.black)
                    }.padding(6)
                    Spacer()
                }
                Text("メッセージの雰囲気を選択")
                    .font(.headline)
                    .padding()
                
                // Moodの選択部分を複数行に対応
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 70, maximum: 80), spacing: 20)
                    ],
                    spacing: 20
                ) {
                    ForEach(
                        MessageMood.allCases,
                        id: \.self
                    ) { mood in
                        MessageMoodLabel(
                            mood: mood,
                            isSelected: selectedMood == mood
                        ).onTapGesture {
                            selectedMood = mood
                        }
                    }
                }
                .padding()
                
                // 選択中のムード説明
                HStack(spacing: 12) {
                    Text(selectedMood.emoji)
                        .font(.title2)
                    Text(selectedMood.title)
                        .foregroundColor(.black)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // メッセージの長さ
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(.gray)
                        Text("メッセージの長さ")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 20) {
                        ForEach(MessageLength.allCases, id: \.self) { length in
                            let isSelected = length == selectedLength
                            let label = MessageLengthLabel(length: length, isSelected: isSelected)
                            label.onTapGesture {
                                selectedLength = length
                            }
                        }

                    }
                }
                .padding()
            
                Button {
                    didTapSaveButton()
                } label: {
                    GradientText(
                        "保存する",
                        font: .subheadline,
                        gradient: Constants.ColorAsset
                            .createGradient(from: .topLeading, to: .bottomTrailing)
                    )
                    .bold()
                    .padding()
                    .frame(maxWidth: 240)
                    .background(Color(.black))
                    .cornerRadius(24)
                }
                .padding()
                .padding(.top, 8)
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

// MARK: Helper functions
extension MessageMoodModal {
    private func didTapSaveButton() {
        guard !selectedMood.isPremiumOnly || !selectedLength.isPremiumOnly || Superwall.shared.subscriptionStatus == .active else {
            Superwall.shared.register(event: "campaign_trigger")
            return
        }
        
        let newConfig = MessageConfiguration(
            mood: selectedMood,
            length: selectedLength
        )
        currentConfig = newConfig
        showMoodModal = false
    }
}

#Preview {
    MessageMoodModal(
        showMoodModal: Binding.constant(true), 
        currentConfig: Binding.constant(.defaultConfig)
    )
}
