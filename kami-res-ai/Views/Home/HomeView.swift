//
//  HomeView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import PhotosUI
import SuperwallKit

struct HomeView: View {
    
    @StateObject private var viewModel = HomeVM()
    @State private var navigateToSuggest = false
    @State private var showComingSoonAlert = false
    @State private var showPremiumAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.ColorAsset.primaryGradient.opacity(0.5)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        Spacer()
                            .frame(height: 136)

                        // タイトル
                        GradientText(
                            "神レスAI",
                            font: .custom("HannariMincho-Regular", size: 40).bold(),
                            gradient: Constants.ColorAsset.createGradient(
                                from: .topLeading,
                                to: .bottomTrailing
                            ))
                        .shadow(color: Color.white.opacity(0.75), radius: 12)
                        .padding(.bottom, 8)
                        
                        // 写真アップロードボタン
                        if DailyActionManager.shared.canPerformAction() {
                            PhotosPicker(
                                selection: $viewModel.selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                HomeTopButtonLabel()
                            }
                        } else {
                            Button {
                                viewModel.showPaywallIfNeeded()
                            } label: {
                                HomeTopButtonLabel()
                            }
                        }
                                    
                        // メッセージ入力ボタン
                        VStack(spacing: 12) {
                            Button(
                                action: {
                                    showComingSoonAlert = true
//                                    DailyActionManager.shared.resetActionLimit()
//                                    print(
//                                        DailyActionManager.shared
//                                            .getCurrentActionCount()
//                                    )
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "keyboard")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        VStack {
                                            Text("自分でメッセージを入力する")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text("過去のメッセージ内容を手動で登録")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("gradientSecondary"))
                                    .cornerRadius(20)
                                    .shadow(
                                        color: Color("gradientSecondary")
                                            .opacity(0.25),
                                        radius: 8
                                    )
                                }
                            
                            Text("*アップロードされた画像はサーバーに保存されません")
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                        }

                        Spacer()
                    }
                    .padding()
                }

                // NavigationLink (ナビゲーションを非表示にする)
                NavigationLink(
                    destination: MessageSuggestView(
                        base64Image: viewModel.base64String,
                        image: viewModel.image
                    ),
                    isActive: self.$navigateToSuggest
                ) {
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if Superwall.shared.subscriptionStatus == .active {
                            showPremiumAlert = true
                        } else {
                            Superwall.shared.register(event: "campaign_trigger")
                        }
                    } label: {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("premiumIcon"))
                            .padding(12)
                            .background(Circle().fill(Color.black))
                            .shadow(color: Color.black.opacity(0.2), radius: 8)
                    }
                }
            }
            .onChange(of: viewModel.selectedPhoto) { newItem in
                if let newItem = newItem {
                    Task {
                        await viewModel.loadAndEncodePhoto(from: newItem)
                        try? await Task
                            .sleep(for: .seconds(0.5)) // Wait for 0.5 seconds
                        self.navigateToSuggest = true
                    }
                }
            }
            .onAppear {
                viewModel.refreshViewModel()
            }
            .alert("Coming Soon!", isPresented: $showComingSoonAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("この機能は現在開発中で、まもなくリリース予定です。お楽しみに！")
            }
            .alert("神レスプレミアム会員", isPresented: $showPremiumAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("すでに神レスプレミアム会員です🙌\nいつもご利用いただきありがとうございます！")
            }
        }
    }
}


#Preview {
    HomeView()
}
