//
//  MessageSuggestView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import PhotosUI
import SuperwallKit
import SwiftUI
import SwiftfulLoadingIndicators

struct ScreenshotMessageSuggestView: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var actionManager = DailyActionManager.shared
    @ObservedObject private var viewModel: ScreenshotMessageSuggestVM
    @State private var showCopyConfirmation: Bool = false
    @State private var showMessageMoodChange: Bool = false
    @State private var showMoodModal: Bool = false
    
    // for app review alert
    @State private var appReviewAlertType: AppReviewAlert?
    
    let history: SuggestHistoryObject
    
    init(history: SuggestHistoryObject) {
        self.history = history
        self.viewModel = ScreenshotMessageSuggestVM(with: history)
    }
    var body: some View {
        ZStack {
            VStack {
                ScrollableContent()
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
                    currentConfig: $viewModel.messageConfig
                )
            }
            if viewModel.isLoading {
                SuggestLoadigView()
            }
        }
        .toolbar {
            BackButtonToolbar
            PhotosPickerToolbar
        }
        .background(BackgroundGradient)
        .ignoresSafeArea(.all)
        .task {
            await viewModel.handleViewAppear()
        }
        .onChange(of: viewModel.selectedPhoto) { newItem in
            Task {
                await viewModel.handleNewPhotoSelection(newItem)
            }
        }
        .alert(item: $appReviewAlertType) { alertType in
            AppReviewAlertBuilder.build(for: alertType, completion: { nextAlert in
                appReviewAlertType = nextAlert
            })
        }
        .navigationBarBackButtonHidden()
    }

    // MARK: - Subviews
    private func ScrollableContent() -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .trailing) {
                    ForEach(history.chatItems, id: \.id) { chatItem in
                        if let text = chatItem.textContent {
                            HStack {
                                Spacer()
                                ScreenshotMessageBubbleView(message: text)
                                    .onTapGesture {
                                        handleTextCopy(text)
                                    }
                            }
                        } else if let imagePath = chatItem.imagePath, let uiImage = UIImage(contentsOfFile: imagePath) {
                            VStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(8)
                                    .shadow(radius: 4)
                                    .padding()
                                MessageCopyInstructionText
                            }
                        }
                    }
                    
                    if viewModel.isLoading {
                        LoadingIndicator(
                            animation: .threeBalls,
                            color: Color.black,
                            size: .small
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color("AntiFlashWhite"))
                        .cornerRadius(20)
                        .padding()
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        HStack {
                            Spacer()
                            ScreenshotMessageBubbleView(message: viewModel.errorMessage)
                        }
                        .onAppear {
                            chatItemListScrollToBottom(proxy: proxy)
                        }
                    }

                    // Dummy hidden view for scrolling
                    Color.clear
                        .frame(height: 40)
                        .id("BottomAnchor")
                }
                .onAppear {
                    chatItemListScrollToBottom(proxy: proxy)
                }
            }
            .onChange(of: viewModel.history.chatItems.count) { _ in
                chatItemListScrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func chatItemListScrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            proxy.scrollTo("BottomAnchor", anchor: .bottom)
        }
    }

    private var MessageCopyInstructionText: some View {
        Text("-- 📎メッセージをタップしてコピー --")
            .font(.caption)
            .foregroundColor(.gray)
    }

    private var actionButtonsBottom: some View {
        VStack {
            HStack {
                MessageMoodButton
                GenerateMoreButton
            }
            Text(viewModel.actionRemainedForTodayString())
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.bottom, 16)
        }
    }
    
    private var MessageMoodButton: some View {
        Button {
            showMoodModal = true
        } label: {
            Text(viewModel.messageConfig.mood.emoji)
                .font(.title3)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.white)

                )
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2)
        }.disabled(viewModel.isLoading)
    }

    private var GenerateMoreButton: some View {
        Button {
            Task {
                await viewModel.generateResponseIfNeeded()
                
                ReviewAlertManager.shared.incrementGenerateActionCount()
                
                if ReviewAlertManager.shared.shouldShowAlert() {
                    appReviewAlertType = .initial
                }
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
        .disabled(viewModel.isLoading)
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
            Text(
                "\(viewModel.messageConfig.mood.emoji) \(viewModel.messageConfig.mood.title)"
            )
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
            .disabled(viewModel.isLoading)
        }
    }

    private var BackgroundGradient: some View {
        Constants.ColorAsset
            .createGradient(from: .bottom, to: .top)
            .opacity(0.3)
    }

    private func handleTextCopy(_ text: String) {
        viewModel.copyToClipboard(text: text)

        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.2)) {  // Fade in animation
                showCopyConfirmation = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.1)) {  // Fade out animation
                showCopyConfirmation = false
            }
        }
    }
}
