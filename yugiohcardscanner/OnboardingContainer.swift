//
//  OnboardingContainer.swift
//  yugiohcardscanner
//

import SwiftUI

struct OnboardingContainer: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingView1(currentPage: $currentPage)
                .tag(0)
            OnboardingView2(currentPage: $currentPage)
                .tag(1)
            OnboardingView3(currentPage: $currentPage)
                .tag(2)
            OnboardingView4(currentPage: $currentPage)
                .tag(3)
            OnboardingView5(showOnboarding: $showOnboarding)
                .tag(4)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}