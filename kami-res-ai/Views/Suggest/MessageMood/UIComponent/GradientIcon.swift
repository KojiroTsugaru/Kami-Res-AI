//
//  GradientIcon.swift
//  MoteAI
//
//  Created by KJ on 1/28/25.
//

import SwiftUI

struct GradientIcon: View {
    let systemName: String      // 例: "square.dashed"
    let gradient: LinearGradient
    let size: CGFloat           // アイコンサイズ
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size))
            .foregroundColor(.clear) // 透明にする
            .overlay(
                gradient
                    .mask(
                        Image(systemName: systemName)
                            .font(.system(size: size))
                    )
            )
    }
}
