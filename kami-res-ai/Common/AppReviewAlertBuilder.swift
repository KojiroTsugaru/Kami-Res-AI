//
//  AppAlertBuilder.swift
//  kami-res-ai
//
//  Created by KJ on 3/22/25.
//

import SwiftUI

struct AppReviewAlertBuilder {
    static func firstAlert(
        showSecondReviewAlertYes: Binding<Bool>,
        showSecondReviewAlertNo: Binding<Bool>
    ) -> Alert {
        Alert(
            title: Text("神レスAIを楽しんでいますか？"),
            primaryButton: .default(Text("はい！"), action: {
                showSecondReviewAlertYes.wrappedValue = true
            }),
            secondaryButton: .default(Text("あんまり..."), action: {
                showSecondReviewAlertNo.wrappedValue = true
            })
        )
    }
    
    static func secondAlertYes() -> Alert {
        Alert(
            title: Text("ありがとうございます！"),
            message: Text("レビューしていただけるととても励みになります"),
            primaryButton: .default(Text("レビューを書く"), action: {
                ReviewAlertManager.shared.goToReviewPage()
                ReviewAlertManager.shared.markReviewCompleted()
            }),
            secondaryButton: .cancel(Text("あとで"), action: {
                ReviewAlertManager.shared.markReviewShown()
            })
        )
    }

    static func secondAlertNo() -> Alert {
        Alert(
            title: Text("ぜひご意見をお聞かせ下さい"),
            message: Text("アプリ改善のための参考にさせていただきます"),
            primaryButton: .default(Text("意見を送る"), action: {
                ReviewAlertManager.shared.openMailApp()
            }),
            secondaryButton: .cancel(Text("閉じる"), action: {
                ReviewAlertManager.shared.markReviewShown()
            })
        )
    }
}


