//
//  HomeTopButton.swift
//  kami-res-ai
//
//  Created by KJ on 2/4/25.
//

import SwiftUI

struct HomeUploadScreenshotButtonLabel: View {
    var body: some View {
        HStack(spacing: 8) { // Slightly increased spacing for better visual balance
            GradientIcon(
                systemName: "square.dashed",
                gradient: Constants.ColorAsset.createGradient(
                    from: .topLeading,
                    to: .bottomTrailing
                ),
                size: 24
            ).bold()

            GradientText(
                "スクリーンショットを選択する",
                font: .headline,
                gradient: Constants.ColorAsset.createGradient(
                    from: .topLeading,
                    to: .bottomTrailing
                )
            )
            .bold()
            .lineLimit(1) // Ensure only one line
            .minimumScaleFactor(0.7) // Slightly increase scaling factor for better readability
        }
        .padding(.vertical)
        .padding(.horizontal, 12) // Maintain balance without affecting height
        .frame(maxWidth: .infinity)
        .background(Color("SecondaryColor"))
        .cornerRadius(24) // Rounded corners
        .shadow(color: Color.black.opacity(0.25), radius: 8)
    }
}
