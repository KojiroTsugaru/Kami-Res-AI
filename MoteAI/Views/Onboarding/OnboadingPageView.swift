//
//  OnboadingPageView.swift
//  MoteAI
//
//  Created by KJ on 1/26/25.
//

import SwiftUI

struct OnboadingPageView: View {
    let page: OnboardingPage
    var body: some View {
        VStack {
            Text(page.label)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(page.text)
                .fontWeight(.medium)
                .padding()
            
            Image(page.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
    }
}

//#Preview {
//    OnboadingPageView()
//}
