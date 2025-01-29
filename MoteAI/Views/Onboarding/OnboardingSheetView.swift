//
//  OnboardingSheetView.swift
//  MoteAI
//
//  Created by KJ on 1/26/25.
//

import SwiftUI
import SuperwallKit

struct OnboardingSheetView: View {
    @Binding var isOnboardingSheetShowing: Bool
    private let onboardingPages = Constants.onboardingPages
    
    var body: some View {
        VStack {
            TabView {
                ForEach(onboardingPages) { page in
                    OnboadingPageView(page: page)
                }
            }
            .tabViewStyle(.page)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.label
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray
            }
            
            Button {
                isOnboardingSheetShowing.toggle()
            } label: {
                Text("OK")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .interactiveDismissDisabled()
        .onDisappear  {
            Superwall.shared.register(event: "campaign_trigger")
        }
    }
}

#Preview {
    OnboardingSheetView(isOnboardingSheetShowing: Binding<Bool>.constant(true))
}
