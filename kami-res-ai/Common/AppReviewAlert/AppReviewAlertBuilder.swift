//
//  AppAlertBuilder.swift
//  kami-res-ai
//
//  Created by KJ on 3/22/25.
//

import SwiftUI

struct AppReviewAlertBuilder {
    static func build(
        for alert: AppReviewAlert,
        completion: @escaping (AppReviewAlert?) -> Void) -> Alert {
        Alert(
            title: Text(alert.title),
            message: alert.message.map(Text.init),
            primaryButton: .default(Text(alert.primaryButtonTitle),
                                    action: alert.primaryAction(completion: completion)),
            secondaryButton: .default(Text(alert.secondaryButtonTitle),
                                      action: alert.secondaryAction(completion: completion))
        )
    }
}

struct PreviewAlertView: View {
    @State private var currentAlert: AppReviewAlert?
    
    var body: some View {
        VStack(spacing: 20) {
            Button("アラートを表示") {
                currentAlert = .initial
            }
        }
        .alert(item: $currentAlert) { alert in
            AppReviewAlertBuilder.build(for: alert) { nextAlert in
                currentAlert = nextAlert
            }
        }
    }
}


#Preview {
    PreviewAlertView()
}
