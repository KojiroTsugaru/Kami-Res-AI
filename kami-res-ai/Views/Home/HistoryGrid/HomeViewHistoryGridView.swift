//
//  SwiftUIView.swift
//  kami-res-ai
//
//  Created by KJ on 3/16/25.
//

import SwiftUI
import RealmSwift

struct HomeViewHistoryGridView: View {
    
    @ObservedResults(SuggestHistoryObject.self) var histories
    
    let columns = [
        GridItem(.adaptive(minimum: 112)) // Adjust cell size dynamically
    ]

    var body: some View {
        ScrollView {
            if histories.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 168)
            
                    Image(systemName: "photo.badge.plus.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 124)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)

                    Text("メッセージのスクショを選択して\nはじめての神レスを生成してみよう")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity) // Makes sure it expands properly

            } else {
                Spacer()
                    .frame(height: 8)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(
                        histories.sorted(by: { $0.createdAt > $1.createdAt })
                    ) { history in
                        NavigationLink(
                            destination: ScreenshotMessageSuggestView(history: history)
                        ) {
                            HomeViewHistoryGridCell(history: history)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    HomeViewHistoryGridView()
}
