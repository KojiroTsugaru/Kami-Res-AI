//
//  SwiftUIView.swift
//  flair
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
                HistoryGridEmptyStateView()
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
