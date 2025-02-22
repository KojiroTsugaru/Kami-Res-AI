//
//  GradientAnimatedBackground.swift
//  kami-res-ai
//
//  Created by KJ on 2/22/25.
//

import SwiftUI

struct GradientAnimatedBackground: View {
    @State private var appear = false
    private let primaryColor = Constants.ColorAsset.primaryColor
    private let secondaryColor = Constants.ColorAsset.secondaryColor
    
    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], appear ? [0.7, -0.3] : [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], appear ? [0.3, 0.7] : [0.7, 0.3], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    .black, .black, .black,
                    appear ? secondaryColor : secondaryColor
                        .opacity(0.3), secondaryColor, secondaryColor,
                    primaryColor, !appear ? primaryColor : .red
                        .opacity(0.7), primaryColor
                ]
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.smooth(duration: 5.0)
                    .repeatForever(autoreverses: true)) {
                        appear.toggle()
                    }
            }
        } else {
            // Fallback on earlier versions
            Constants.ColorAsset.primaryGradient.opacity(0.5)
                .ignoresSafeArea()
        }
    }
    
    private var topColor: Color {
        appear ? .black : .white
    }
}

#Preview {
    GradientAnimatedBackground()
}
