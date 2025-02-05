//
//  GradientText.swift
//  MoteAI
//
//  Created by KJ on 1/28/25.
//

import SwiftUI

struct GradientText: View {
    let text: String
    let gradient: LinearGradient
    let font: Font
    
    init(
        _ text: String,
        font: Font,
        gradient: LinearGradient = Constants.ColorAsset
            .createGradient(from: .topLeading, to: .topTrailing)) {
                self.text = text
                self.font = font
                self.gradient = gradient
            }

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(.clear) // テキストを透明にする
            .overlay(
                gradient
                    .mask(    // グラデーションをテキストの形に切り抜く
                        Text(text)
                            .font(font)
                         )
            )
    }
}

