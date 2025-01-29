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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 36) {
                Spacer()
                
                GradientText(
                    "MoteAI",
                    font: .largeTitle.bold(),
                    gradient: Constants.ColorAsset.createGradient(
                        from: .topLeading,
                        to: .bottomTrailing
                    ))
                
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
                                "メッセージのスクショを選択してください",
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
                }
                            
                Button(action: {
                    Superwall.shared.register(event: "campaign_trigger")
                }) {
                    HStack {
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
                    .background(Color.cyan) // Background color
                    .cornerRadius(20) // Rounded corners
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
        }
    }

}

#Preview {
    HomeView()
}
