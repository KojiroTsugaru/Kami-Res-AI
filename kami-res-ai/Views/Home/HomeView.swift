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
    @State private var showComingSoonAlert = false
    @State private var showPremiumAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.ColorAsset.primaryGradient.opacity(0.5)
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    HomeViewHistoryGridView()

                    VStack(spacing: 8) {
                        // 写真アップロードボタン
                        if DailyActionManager.shared.canPerformAction() {
                            PhotosPicker(
                                selection: $viewModel.selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                HomeUploadScreenshotButtonLabel()
                            }
                        } else {
                            Button {
                                viewModel.showPaywallIfNeeded()
                            } label: {
                                HomeUploadScreenshotButtonLabel()
                            }
                        }
                        
                        // メッセージ入力ボタン
                        Button {
                            showComingSoonAlert = true
                            SuggestHistoryManager.shared
                                .deleteAllSuggestHistoryObjects()
                        } label: {
                            ManuallyEnterButtonLabel()
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $viewModel.navigateToSuggestView) {
                ScreenshotMessageSuggestView(
                    history: viewModel.newHistory ?? SuggestHistoryObject()
                )
            }
            .navigationDestination(isPresented: $viewModel.navigateToManuallyType) {
                ManuallyEnterMeesageView()
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
                            .shadow(color: Color.white.opacity(0.2), radius: 8)
                    }
                }
            }
            .onChange(of: viewModel.selectedPhoto) { newItem in
                if let newItem = newItem {
                    Task {
                        await viewModel.didPhotoPicked(newItem)
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
