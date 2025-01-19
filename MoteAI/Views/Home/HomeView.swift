//
//  HomeView.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeVM()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                Text("Logo")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
                
                PhotosPicker(
                    selection: $viewModel.selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack(spacing: 12) {
                        Image(
                            systemName: "square.dashed"
                        ) // Replace with your desired icon
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding()
                        VStack(spacing: 8) {
                            Text("写真をアップロード")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .bold()
                            Text("メッセージのスクリーンショットを選択")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding() // Add padding inside the button
                    .frame(
                        maxWidth: .infinity
                    ) // Make the button expand horizontally
                    .background(Color.accentColor) // Background color
                    .cornerRadius(24) // Rounded corners
                }
                
                Button(action: {
                    print("Button 2 tapped")
                }) {
                    HStack(spacing: 12) {
                        Image(
                            systemName: "square.dashed"
                        ) // Replace with your desired icon
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding()
                        VStack(spacing: 8) {
                            Text("写真をアップロード")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .bold()
                            Text("メッセージのスクリーンショットを選択")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding() // Add padding inside the button
                    .frame(
                        maxWidth: .infinity
                    ) // Make the button expand horizontally
                    .background(Color.accentColor) // Background color
                    .cornerRadius(24) // Rounded corners
                }
                            
                Button(action: {
                    print("Button 2 tapped")
                }) {
                    HStack {
                        Image(
                            systemName: "heart.fill"
                        ) // Replace with your desired icon
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        VStack {
                            Text("Favorite")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Favorite")
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
                    isActive: $viewModel.navigateToSuggest
                ) {
                    EmptyView()
                }

            }.padding()
                .ignoresSafeArea(.all)
                .background(LinearGradient(
                    gradient: Gradient(colors: [.cyan.opacity(0.5), .accentColor.opacity(0.5)]),
                    startPoint: .top, // Starting point of the gradient
                    endPoint: .bottom // Ending point of the gradient
                ))
                .onChange(of: viewModel.selectedPhoto) { newItem in
                    if let newItem = newItem {
                        Task {
                            await viewModel.loadAndEncodePhoto(from: newItem)
                        }
                    }
                }
        }
    }

}

#Preview {
    HomeView()
}
