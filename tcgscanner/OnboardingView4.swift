//
//  OnboardingView4.swift
//  tcgscanner
//

import SwiftUI

struct OnboardingView4: View {
    @Binding var currentPage: Int
    @State private var bellAnimation = false
    @State private var ringScale: CGFloat = 1.0
    @State private var particleAnimation = false
    @State private var textSlide = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Star Wars space background
                StarsBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Headline in upper third
                    Text("STAY ON TARGET WITH\nNOTIFICATIONS")
                        .font(.system(size: min(geometry.size.height * 0.045, 36), weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.8)
                        .padding(.top, geometry.safeAreaInsets.top + geometry.size.height * 0.15)
                        .opacity(textSlide ? 1 : 0)
                        .offset(y: textSlide ? 0 : -20)
                    
                    Spacer()
                    
                    // Central notification bell animation
                    ZStack {
                        // Multiple animated rings
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.4),
                                            Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.1)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: geometry.size.height * 0.2, height: geometry.size.height * 0.2)
                                .scaleEffect(bellAnimation ? 1.0 + CGFloat(index) * 0.3 : 1.0)
                                .opacity(bellAnimation ? 0 : 0.6 - Double(index) * 0.2)
                                .animation(
                                    .easeOut(duration: 2)
                                    .repeatForever()
                                    .delay(Double(index) * 0.4),
                                    value: bellAnimation
                                )
                        }
                        
                        // Floating particles
                        ForEach(0..<6) { index in
                            Circle()
                                .fill(Color(red: 1.0, green: 0.8, blue: 0.2))
                                .frame(width: 4, height: 4)
                                .offset(
                                    x: particleAnimation ? CGFloat.random(in: -50...50) : 0,
                                    y: particleAnimation ? -50 : 20
                                )
                                .opacity(particleAnimation ? 0 : 1)
                                .animation(
                                    .easeOut(duration: 2)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: particleAnimation
                                )
                        }
                        
                        // Bell icon with shadow and glow
                        ZStack {
                            Image(systemName: "bell.fill")
                                .font(.system(size: geometry.size.height * 0.1))
                                .foregroundColor(.black.opacity(0.2))
                                .offset(x: 2, y: 2)
                                .blur(radius: 3)
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: geometry.size.height * 0.1))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 1.0, green: 0.8, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .rotationEffect(.degrees(bellAnimation ? -20 : 20))
                                .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.6), radius: 25)
                        }
                        .scaleEffect(ringScale)
                    }
                    .frame(height: geometry.size.height * 0.25)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                            bellAnimation = true
                        }
                        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            ringScale = 1.1
                        }
                        withAnimation {
                            particleAnimation = true
                        }
                        withAnimation(.easeOut(duration: 0.6)) {
                            textSlide = true
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        // Check mark text
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.green)
                            Text("No payment due now")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                        }
                        
                        // Proceed for free button
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Capsule()
                                .fill(.white)
                                .frame(width: geometry.size.width * 0.9, height: 56)
                                .overlay(
                                    Text("Proceed for free")
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

