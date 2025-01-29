//
//  PlusShape.swift
//  MoteAI
//
//  Created by KJ on 1/28/25.
//

import SwiftUI

struct GradientPlusIcon: View {
    let size: CGSize
    let lineThickness: CGFloat
    let cornerRadius: CGFloat
    let outlineColor: Color
    let outlineWidth: CGFloat
    let gradient: LinearGradient

    var body: some View {
        ZStack {
            // アウトライン用（stroke）
            PlusShape(lineThickness: lineThickness, cornerRadius: cornerRadius)
                .stroke(outlineColor, lineWidth: outlineWidth)
                .frame(width: size.width, height: size.height)
            
            // 中身（fill）はグラデーション
            PlusShape(lineThickness: lineThickness, cornerRadius: cornerRadius)
                .fill(gradient)
                .frame(width: size.width, height: size.height)
        }
    }
}

struct PlusShape: Shape {
    /// “＋” の線の太さ
    var lineThickness: CGFloat = 10

    /// コーナーの丸み
    var cornerRadius: CGFloat = 4

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        let centerX = width / 2
        let centerY = height / 2
        
        let halfThickness = lineThickness / 2
        
        // 横棒
        path.addRoundedRect(
            in: CGRect(
                x: 0,
                y: centerY - halfThickness,
                width: width,
                height: lineThickness
            ),
            cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        // 縦棒
        path.addRoundedRect(
            in: CGRect(
                x: centerX - halfThickness,
                y: 0,
                width: lineThickness,
                height: height
            ),
            cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        return path
    }
}
