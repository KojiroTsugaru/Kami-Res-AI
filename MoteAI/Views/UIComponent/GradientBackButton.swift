//
//  GradientBackIcon.swift
//  MoteAI
//
//  Created by KJ on 1/29/25.
//
import SwiftUI

struct GradientBackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            ZStack {
                // アウトライン (黒)
                BackArrowChevronShape()
                    .stroke(
                        .black,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 28, height: 28)

                // グラデーション塗りのメインの矢印
                BackArrowChevronShape()
                    .stroke(
                        Constants.ColorAsset.createGradient(from: .topLeading, to: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 28, height: 28)
            }
        }
    }
}

struct BackArrowChevronShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let thickness: CGFloat = rect.width * 0.15 // 太さ
        let leftX = rect.minX + rect.width * 0.5
        let rightX = rect.maxX * 0.9

        // 上の線
        path.move(to: CGPoint(x: rightX, y: rect.minY + thickness))
        path.addLine(to: CGPoint(x: leftX, y: rect.midY))
        path.addLine(to: CGPoint(x: rightX, y: rect.maxY - thickness))

        return path
    }
}

#Preview {
    GradientBackButton()
}
