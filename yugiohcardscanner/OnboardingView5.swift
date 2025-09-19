//
//  OnboardingView5.swift
//  yugiohcardscanner
//

import SwiftUI

struct OnboardingView5: View {
    @Binding var showOnboarding: Bool
    @State private var animationStep = 0
    @State private var iconRotation = 0.0
    @State private var glowAmount = 0.5
    @State private var buttonPulse = 1.0
    
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
                    // Hero animation at top
                    ZStack {
                        // Outer rotating ring
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5),
                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: geometry.size.height * 0.28, height: geometry.size.height * 0.28)
                            .rotationEffect(.degrees(iconRotation))
                        
                        // Pulsing glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.4),
                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.1),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: geometry.size.height * 0.05,
                                    endRadius: geometry.size.height * 0.15
                                )
                            )
                            .frame(width: geometry.size.height * 0.3, height: geometry.size.height * 0.3)
                            .blur(radius: 15)
                            .scaleEffect(glowAmount)
                        
                        // Question mark with 3D effect
                        ZStack {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: geometry.size.height * 0.08))
                                .foregroundColor(.black.opacity(0.2))
                                .offset(x: 3, y: 3)
                                .blur(radius: 5)
                            
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: geometry.size.height * 0.08))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 1.0, green: 0.8, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.6), radius: 25)
                        }
                        .rotation3DEffect(
                            .degrees(10),
                            axis: (x: 0, y: 1, z: 0),
                            perspective: 0.5
                        )
                    }
                    .padding(.top, geometry.safeAreaInsets.top + geometry.size.height * 0.02)
                    .onAppear {
                        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                            iconRotation = 360
                        }
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            glowAmount = 1.2
                        }
                    }
                    
                    // Headline
                    Text("How does your free trial work?")
                        .font(.system(size: min(geometry.size.height * 0.032, 26), weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer(minLength: geometry.size.height * 0.03)
                    
                    // Timeline
                    VStack(alignment: .leading, spacing: geometry.size.height * 0.04) {
                        // Today
                        TimelineRow(
                            icon: "lock.open.fill",
                            title: "Today",
                            text: "Unlimited scans, AI grading & more.",
                            isActive: animationStep >= 0,
                            geometry: geometry
                        )
                        
                        // In 2 Days
                        TimelineRow(
                            icon: "bell.fill",
                            title: "In 2 Days",
                            text: "It's still free! Enjoy.",
                            isActive: animationStep >= 1,
                            geometry: geometry
                        )
                        
                        // In 3 Days
                        TimelineRow(
                            icon: "checkmark.circle.fill",
                            title: "In 3 Days",
                            text: "You won't be charged beforehand.\nYou can cancel earlier.",
                            isActive: animationStep >= 2,
                            geometry: geometry,
                            isLast: true
                        )
                    }
                    .padding(.horizontal, geometry.size.width * 0.1)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            animationStep = 0
                        }
                        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                            animationStep = 1
                        }
                        withAnimation(.easeIn(duration: 0.5).delay(1.0)) {
                            animationStep = 2
                        }
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(2)) {
                            buttonPulse = 1.05
                        }
                    }
                    
                    Spacer()
                    
                    // Continue button with glow effect
                    Button(action: {
                        withAnimation {
                            showOnboarding = false
                        }
                    }) {
                        ZStack {
                            // Glow behind button
                            Capsule()
                                .fill(Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.3))
                                .frame(width: geometry.size.width * 0.9, height: 56)
                                .blur(radius: 10)
                                .scaleEffect(buttonPulse)
                            
                            Capsule()
                                .fill(.white)
                                .frame(width: geometry.size.width * 0.9, height: 56)
                                .overlay(
                                    Text("Continue")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.19))
                                )
                        }
                    }
                    .scaleEffect(buttonPulse)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 30))
                }
            }
        }
    }
}

struct TimelineRow: View {
    let icon: String
    let title: String
    let text: String
    let isActive: Bool
    let geometry: GeometryProxy
    var isLast: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: geometry.size.width * 0.04) {
            // Timeline line and icon
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isActive ? Color(red: 1.0, green: 0.8, blue: 0.2) : Color(red: 0.3, green: 0.3, blue: 0.3))
                        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                    
                    Image(systemName: icon)
                        .font(.system(size: geometry.size.width * 0.05))
                        .foregroundColor(isActive ? .black : Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                if !isLast {
                    Rectangle()
                        .fill(isActive ? Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5) : Color(red: 0.3, green: 0.3, blue: 0.3))
                        .frame(width: 2, height: geometry.size.height * 0.06)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                Text(title)
                    .font(.system(size: min(geometry.size.height * 0.02, 16), weight: .bold))
                    .foregroundColor(isActive ? .white : Color(red: 0.6, green: 0.6, blue: 0.6))
                
                Text(text)
                    .font(.system(size: min(geometry.size.height * 0.016, 14)))
                    .foregroundColor(isActive ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.5, green: 0.5, blue: 0.5))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .opacity(isActive ? 1.0 : 0.3)
    }
}