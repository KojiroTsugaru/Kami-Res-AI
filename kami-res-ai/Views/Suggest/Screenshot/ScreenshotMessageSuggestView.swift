//
//  MessageSuggestView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import PhotosUI
import SuperwallKit
import SwiftUI

struct ScreenshotMessageSuggestView: View {
    let base64Image: String?
    let image: UIImage?

    @Environment(\.dismiss) private var dismiss

    @StateObject private var actionManager = DailyActionManager.shared
    @ObservedObject private var viewModel = ScreenshotMessageSuggestVM()
    @State private var showCopyConfirmation: Bool = false
    @State private var showMessageMoodChange: Bool = false
    @State private var showMoodModal: Bool = false
    

    var body: some View {
        ZStack {
            VStack {
                ScrollableContent(image: image)
                actionButtonsBottom
            }
            if showCopyConfirmation {
                CopyConfirmationView
            }
            if showMessageMoodChange {
                MessageMoodChangeView
            }
            if showMoodModal {
                MessageMoodModal(
                    showMoodModal: $showMoodModal,
                    selectedMood: $viewModel.messageMood
                )
            }
        }
        .toolbar {
            BackButtonToolbar
            PhotosPickerToolbar
        }
        .background(BackgroundGradient)
        .ignoresSafeArea(.all)
        .task {
            viewModel.base64Image = base64Image
            await viewModel.generateResponseIfNeeded()
        }
        .onChange(of: viewModel.selectedPhoto) { newItem in
            handlePhotoSelection(newItem)
        }
        .navigationBarBackButtonHidden()
    }

    // MARK: - Subviews
    private func ScrollableContent(image: UIImage?) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack {
                    DisplayImage(image: image)
                    InstructionText
                    ChatItemsList()

                    // Dummy hidden view for scrolling
                    Color.clear
                        .frame(height: 40)
                        .id("BottomAnchor")
                }
            }
            .onChange(of: viewModel.chatItems.count) { _ in
                DispatchQueue.main.async {
                    proxy.scrollTo("BottomAnchor", anchor: .bottom)
                }
            }
        }
    }

    private func DisplayImage(image: UIImage?) -> some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding()
            } else {
                Spacer().frame(height: 100)
                ProgressView("画像をロード中...")
                    .padding()
            }
        }
    }

    private var InstructionText: some View {
        Text("-- 📎メッセージをタップしてコピー --")
            .font(.caption)
            .foregroundColor(.gray)
    }

    private func ChatItemsList() -> some View {
        VStack(alignment: .trailing) {
            ForEach(viewModel.chatItems) { item in
                if case .message(let text) = item {
                    HStack {
                        Spacer()
                        ScreenshotMessageBubbleView(message: text)
                            .onTapGesture {
                                handleTextCopy(text)
                            }
                    }
                } else if case .image(let image) = item {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .padding()
                        .id(item.id)
                }
            }
        }
    }

    private var actionButtonsBottom: some View {
        VStack {
            HStack {
                MessageMoodButton(
                    mood: $viewModel.messageMood, showMoodModal: $showMoodModal
                )
                GenerateMoreButton
            }
            Text(viewModel.actionRemainedForTodayString())
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.bottom, 16)
        }
    }

    private var GenerateMoreButton: some View {
        Button {
            Task {
                await viewModel.generateResponseIfNeeded()
            }
        } label: {
            GradientText(
                "もっと返信を生成",
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
    }

    private var CopyConfirmationView: some View {
        Text("📎メッセージをコピーしました！")
            .font(.subheadline)
            .foregroundColor(.black)
            .padding(16)
            .background(.white)
            .cornerRadius(20)
    }

    private var MessageMoodChangeView: some View {
        VStack(spacing: 12) {
            GradientText("メッセージの雰囲気を変更しました", font: .headline)
            Text("\(viewModel.messageMood.emoji) \(viewModel.messageMood.text)")
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .background(.black)
        .cornerRadius(20)
        .shadow(color: Color.white.opacity(0.75), radius: 12)
    }

    private var BackButtonToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            GradientBackButton()
        }
    }

    private var PhotosPickerToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            PhotosPicker(
                selection: $viewModel.selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                GradientPlusIcon(
                    size: CGSize(width: 24, height: 24),
                    lineThickness: 5,
                    cornerRadius: 8,
                    outlineColor: .black,
                    outlineWidth: 5,
                    gradient: Constants.ColorAsset
                        .createGradient(from: .topLeading, to: .bottomTrailing)
                )
            }
        }
    }

    private var BackgroundGradient: some View {
        Constants.ColorAsset
            .createGradient(from: .bottom, to: .top)
            .opacity(0.5)
    }

    private func handleTextCopy(_ text: String) {
        viewModel.copyToClipboard(text: text)

        withAnimation(.easeInOut(duration: 0.2)) {  // Fade in animation
            showCopyConfirmation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.1)) {  // Fade out animation
                showCopyConfirmation = false
            }
        }
    }

    private func handlePhotoSelection(_ newItem: PhotosPickerItem?) {
        guard newItem != nil else { return }
        Task {
            await viewModel.loadAndEncodePhoto(from: newItem!)
            try? await Task.sleep(for: .seconds(1.0))  // Wait for 0.5 seconds
        }
    }
}
