//
//  HistoryGridEmptyStateView.swift
//  kami-res-ai
//
//  Created by KJ on 3/19/25.
//

import SwiftUI

struct HistoryGridEmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 144)
    
            Image("historyPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .rotationEffect(.degrees(15))

            VStack(spacing: 12) {
                Text("スクショを選択して神レスを体験しよう")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("スクリーンショットをアップロードすると\nAIが最適な返信を生成します...！")
                    .font(.subheadline)
                    .foregroundColor(Color(.black).opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HistoryGridEmptyStateView()
}
