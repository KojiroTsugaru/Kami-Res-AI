//
//  GradientOutlinedIcon.swift
//  MoteAI
//
//  Created by KJ on 1/28/25.
//

import SwiftUI

struct GradientOutlinedIcon: View {
    let systemName: String
    let gradient: LinearGradient
    let size: CGFloat
        
    /// アウトライン（枠線）の色
    let outlineColor: Color
    
    /// アウトラインの大きさ（通常は 1.0 より大きめに）
    let outlineScale: CGFloat

    init(
        systemName: String,
        gradient: LinearGradient,
        size: CGFloat,
        outlineColor: Color = .white,
        outlineScale: CGFloat = 1.1
    ) {
        self.systemName = systemName
        self.gradient = gradient
        self.size = size
        self.outlineColor = outlineColor
        self.outlineScale = outlineScale
    }

    var body: some View {
        ZStack {
            // ──────────────
            // 背面: アウトライン
            // ──────────────
            Image(systemName: systemName)
                .font(.system(size: size))
                .foregroundColor(outlineColor)
                // 少し拡大して、フロント側が重なることで枠線のように見える
                .scaleEffect(outlineScale)

            // ──────────────
            // 前面: グラデーションアイコン
            // ──────────────
            Image(systemName: systemName)
                .font(.system(size: size))
                .foregroundColor(.clear)  // まずは透明
                .overlay(
                    // グラデーションを重ねる
                    gradient
                        .mask(
                            // シンボルの形で切り抜く
                            Image(systemName: systemName)
                                .font(.system(size: size))
                        )
                )
        }
    }
}

