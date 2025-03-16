//
//  HomeTopButton.swift
//  kami-res-ai
//
//  Created by KJ on 2/4/25.
//

import SwiftUI

struct HomeUploadScreenshotButtonLabel: View {
    var body: some View {
        VStack {
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
    }
}
