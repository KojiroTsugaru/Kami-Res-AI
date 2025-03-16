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
        GridItem(.adaptive(minimum: 100)) // Adjust cell size dynamically
    ]

    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 8)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(histories) { history in
                    NavigationLink(
                        destination: ScreenshotMessageSuggestView(history: history)
                    ) {
                        HomeViewHistoryGridCell(history: history)
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
