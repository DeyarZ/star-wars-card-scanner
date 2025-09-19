//
//  OnboardingView3.swift
//  yugiohcardscanner
//

import SwiftUI

struct OnboardingView3: View {
    @Binding var currentPage: Int
    @State private var priceScale = 0.0
    @State private var checkScale = 0.0
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Same gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.11, green: 0.11, blue: 0.19),
                        Color(red: 0.18, green: 0.14, blue: 0.26)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Headline at top
                    Text("We want you to try CardMaster AI for free.")
                        .font(.system(size: min(geometry.size.height * 0.035, 28), weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.8)
                        .padding(.top, geometry.safeAreaInsets.top + geometry.size.height * 0.08)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 20)
                    
                    // Phone mockup with app UI - proper phone aspect ratio
                    ZStack {
                        // Phone frame
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.05)
                            .fill(Color.black)
                            .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.45)
                            .overlay(
                                RoundedRectangle(cornerRadius: geometry.size.height * 0.05)
                                    .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 2)
                            )
                    
                        // Screen content showing card details
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.045)
                            .fill(Color(red: 0.05, green: 0.05, blue: 0.05))
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.41)
                            .overlay(
                                VStack(spacing: geometry.size.height * 0.015) {
                                    // Card image
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 0.8, green: 0.6, blue: 0.2), Color(red: 1.0, green: 0.8, blue: 0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.2)
                                        .overlay(
                                            VStack {
                                                Text("BLUE-EYES")
                                                    .font(.system(size: geometry.size.height * 0.015, weight: .bold))
                                                    .padding(.top, 5)
                                                Spacer()
                                                Image(systemName: "dragon")
                                                    .font(.system(size: geometry.size.height * 0.05))
                                                Spacer()
                                                Text("ATK/3000")
                                                    .font(.system(size: geometry.size.height * 0.012, weight: .bold))
                                                    .padding(.bottom, 5)
                                            }
                                            .foregroundColor(.black)
                                        )
                                    
                                    // PSA Rating
                                    HStack {
                                        Text("PSA")
                                            .font(.system(size: geometry.size.height * 0.014, weight: .bold))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Circle()
                                            .fill(Color.green.opacity(0.2))
                                            .frame(width: geometry.size.height * 0.035, height: geometry.size.height * 0.035)
                                            .overlay(
                                                Text("10")
                                                    .font(.system(size: geometry.size.height * 0.018, weight: .bold))
                                                    .foregroundColor(.green)
                                            )
                                    }
                                    .padding(.horizontal, geometry.size.width * 0.05)
                                    
                                    // Prices
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("TCGPlayer")
                                                .font(.system(size: geometry.size.height * 0.013))
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("$89.99")
                                                .font(.system(size: geometry.size.height * 0.015, weight: .bold))
                                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                                        }
                                    }
                                    .padding(.horizontal, geometry.size.width * 0.05)
                                    
                                    Spacer()
                                }
                                .padding(.top, geometry.size.height * 0.025)
                            )
                    }
                    
                    Spacer(minLength: 20)
                    
                    VStack(spacing: 10) {
                        // Check mark text
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.green)
                                .scaleEffect(checkScale)
                                .onAppear {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.8)) {
                                        checkScale = 1.0
                                    }
                                }
                            Text("No payment due now")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                        }
                        
                        // Try it for $0.00 button
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Capsule()
                                .fill(.white)
                                .frame(width: geometry.size.width * 0.9, height: 56)
                                .overlay(
                                    Text("Try it for $0.00")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.19))
                                )
                        }
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 30))
                }
            }
        }
    }
}