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
                ScrollableContent(image: image)
                GenerateMoreButton
            }
            if showCopyConfirmation {
                CopyConfirmationView
            }
        }
        .toolbar {
            PhotosPickerToolbar
        }
        .background(BackgroundGradient)
        .ignoresSafeArea(.all)
        .task {
            await viewModel.getSuggestedMessage(base64Image: base64Image ?? "")
        }
        .onChange(of: viewModel.selectedPhoto) { newItem in
            handlePhotoSelection(newItem)
        }
        .onAppear {
            setTransparentNavigationBar()
        }
        .onDisappear {
            resetNavigationBarAppearance()
        }
    }

    // MARK: - Subviews
    private func ScrollableContent(image: UIImage?) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack {
                    DisplayImage(image: image)
                    InstructionText
                    ChatItemsList(proxy: proxy)
                }
            }
            .onChange(of: $viewModel.chatItems.count) { _ in
                if let lastItem = viewModel.chatItems.last {
                    print(lastItem.self)
                    proxy.scrollTo(lastItem.id)
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
        Text("-- メッセージをタップしてコピー --")
            .font(.caption)
            .foregroundColor(.gray)
    }

    private func ChatItemsList(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .trailing) {
            ForEach(viewModel.chatItems) { item in
                if case .message(let text) = item {
                    HStack {
                        Spacer()
                        MessageBubbleView(message: text)
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

    private var GenerateMoreButton: some View {
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

    private var CopyConfirmationView: some View {
        Text("メッセージをコピーしました！")
            .font(.subheadline)
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(24)
    }

    private var PhotosPickerToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            PhotosPicker(
                selection: $viewModel.selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "plus").bold()
            }
        }
    }

    private var BackgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.cyan.opacity(0.5), .accentColor.opacity(0.5)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func handleTextCopy(_ text: String) {
        viewModel.copyToClipboard(text: text)
        showCopyConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showCopyConfirmation = false
        }
    }

    private func handlePhotoSelection(_ newItem: PhotosPickerItem?) {
        guard newItem != nil else { return }
        Task {
            await viewModel.loadAndEncodePhoto(from: newItem!)
            try? await Task.sleep(for: .seconds(0.5)) // Wait for 0.5 seconds
        }
    }

    private func setTransparentNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    private func resetNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

