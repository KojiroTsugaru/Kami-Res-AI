//
//  ManuallyEnterButtonLabel.swift
//  kami-res-ai
//
//  Created by KJ on 3/16/25.
//

import SwiftUI

struct ManuallyEnterButtonLabel: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "keyboard")
                .font(.headline)
            Text("自分でメッセージを入力する")
                .font(.caption)
                .bold()
                .frame(minHeight: 40) // Ensure text area does not shrink
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 3)
        .background(Color("gradientSecondary").opacity(0.8))
        .cornerRadius(24)
        .shadow(
            color: Color(.black)
                .opacity(0.25),
            radius: 8
        )
    }
}
