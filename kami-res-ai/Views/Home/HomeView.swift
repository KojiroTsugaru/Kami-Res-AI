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
    private var canOpenPhotoPicker: Bool {
        Superwall.shared.subscriptionStatus == .active || DailyActionManager.shared.canPerformAction()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()
                
                GradientText(
                    "神レスAI",
                    font: .largeTitle.bold(),
                    gradient: Constants.ColorAsset.createGradient(
                        from: .topLeading,
                        to: .bottomTrailing
                    ))
                .shadow(color: Color.white.opacity(0.75), radius: 12)
                
                PhotosPicker(
                    selection: $viewModel.selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack(spacing: 12) {
                        GradientIcon(
                            systemName: "square.dashed",
                            gradient: Constants.ColorAsset.createGradient(
                                from: .topLeading,
                                to: .bottomTrailing
                            ),
                            size: 60
                        )
                        .padding()
                        VStack(spacing: 8) {
                            GradientText(
                                "写真をアップロード",
                                font: .largeTitle,
                                gradient: Constants.ColorAsset.createGradient(
                                    from: .topLeading,
                                    to: .bottomTrailing
                                ))
                            .bold()
                            .lineLimit(1) // Ensure only one line
                            .minimumScaleFactor(
                                0.5
                            ) // Shrink text to fit within the space
                            
                            GradientText(
                                "メッセージのスクショを選択してください*",
                                font: .caption,
                                gradient: Constants.ColorAsset.createGradient(
                                    from: .topLeading,
                                    to: .bottomTrailing
                                ))
                            .lineLimit(1) // Ensure only one line
                            .minimumScaleFactor(
                                0.5
                            ) // Shrink text to fit within the space
                        }
                        Spacer()
                    }
                    .padding() // Add padding inside the button
                    .frame(
                        maxWidth: .infinity
                    ) // Make the button expand horizontally
                    .background(Color("SecondaryColor"))
                    .cornerRadius(24) // Rounded corners
                    .shadow(color: Color.black.opacity(0.25), radius: 8)
                }
                .disabled(!canOpenPhotoPicker)
                .onTapGesture {
                    if Superwall.shared.subscriptionStatus != .active && !canOpenPhotoPicker {
                        Superwall.shared.register(event: "campaign_trigger") // Superwall で課金ページを表示
                    }
                }
                            
                VStack(spacing: 12) {
                    Button(action: {
                        Superwall.shared.register(event: "campaign_trigger")
                    }) {
                        HStack(spacing: 12) {
                            Image(
                                systemName: "keyboard"
                            ) // Replace with your desired icon
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
                        .padding() // Add padding inside the button
                        .frame(
                            maxWidth: .infinity
                        ) // Make the button expand horizontally
                        .background(Color("gradientSecondary")) // Background color
                        .cornerRadius(20) // Rounded corners
                        .shadow(color: Color("gradientSecondary").opacity(0.25), radius: 8)
                    }
                    
                    Text("*アップロードされた画像はサーバーに保存されません")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                    
                }
                Spacer()
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
            .padding()
            .ignoresSafeArea(.all)
            .background(Constants.ColorAsset.primaryGradient.opacity(0.5))
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Superwall.shared.register(event: "campaign_trigger")
                    } label: {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(.systemYellow))
                            .padding(12)
                            .background(Circle().fill(Color.black))
                            .shadow(color: Color.black.opacity(0.2), radius: 8)
                    }
                }
            }
        }
    }

}

#Preview {
    HomeView()
}
