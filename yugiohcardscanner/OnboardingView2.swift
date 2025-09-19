//
//  OnboardingView2.swift
//  yugiohcardscanner
//

import SwiftUI

struct OnboardingView2: View {
    @Binding var currentPage: Int
    @State private var scanAnimation = false
    @State private var cardAppear = false
    @State private var phoneScale = 0.8
    @State private var scanLineOpacity = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Same gradient background as first page
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
                    // App in action animation
                    ZStack {
                        // Glow behind phone
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.2),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 150
                                )
                            )
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.4)
                            .blur(radius: 20)
                        
                        // Phone mockup with gradient border
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.038)
                            .fill(
                                LinearGradient(
                                    colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.35)
                            .overlay(
                                RoundedRectangle(cornerRadius: geometry.size.height * 0.038)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color(red: 0.5, green: 0.5, blue: 0.5), Color(red: 0.2, green: 0.2, blue: 0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .scaleEffect(phoneScale)
                            .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                        
                        // Screen content
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.032)
                            .fill(Color(red: 0.05, green: 0.05, blue: 0.05))
                            .frame(width: geometry.size.width * 0.31, height: geometry.size.height * 0.325)
                            .overlay(
                                VStack {
                                    // Scanning animation
                                    ZStack {
                                        // Card being scanned with more detail
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(red: 0.8, green: 0.6, blue: 0.2), Color(red: 1.0, green: 0.8, blue: 0.2)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * 0.18, height: geometry.size.height * 0.175)
                                            .overlay(
                                                VStack {
                                                    Text("BLUE-EYES")
                                                        .font(.system(size: geometry.size.height * 0.008, weight: .bold))
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                    Image(systemName: "sparkles")
                                                        .font(.system(size: geometry.size.height * 0.03))
                                                        .foregroundColor(.black.opacity(0.3))
                                                    Spacer()
                                                }
                                                .padding(4)
                                            )
                                            .rotation3DEffect(
                                                .degrees(scanAnimation ? 10 : -10),
                                                axis: (x: 0, y: 1, z: 0),
                                                perspective: 0.8
                                            )
                                            .scaleEffect(cardAppear ? 1 : 0.5)
                                            .opacity(cardAppear ? 1 : 0)
                                            .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5), radius: 10)
                                        
                                        // Scan line with glow
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5),
                                                        Color(red: 1.0, green: 0.8, blue: 0.2),
                                                        Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * 0.22, height: 3)
                                            .blur(radius: 1)
                                            .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.2), radius: 15)
                                            .opacity(scanLineOpacity)
                                            .offset(y: scanAnimation ? geometry.size.height * 0.088 : -geometry.size.height * 0.088)
                                    }
                                    
                                    Text("SCANNING...")
                                        .font(.system(size: min(geometry.size.height * 0.015, 12), weight: .bold))
                                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                                        .padding(.top, geometry.size.height * 0.025)
                                }
                            )
                    }
                    .padding(.top, geometry.safeAreaInsets.top + geometry.size.height * 0.08)
                    .onAppear {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                            phoneScale = 1.0
                        }
                        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                            cardAppear = true
                        }
                        withAnimation(.easeInOut(duration: 0.3).delay(0.8)) {
                            scanLineOpacity = 1.0
                        }
                        withAnimation(.easeInOut(duration: 2).repeatForever().delay(1.0)) {
                            scanAnimation = true
                        }
                    }
                    
                    Spacer(minLength: geometry.size.height * 0.05)
                    
                    VStack(spacing: geometry.size.height * 0.025) {
                        // Headline
                        Text("SCAN CARDS IN\nSECONDS")
                            .font(.system(size: min(geometry.size.height * 0.035, 28), weight: .black))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: geometry.size.width * 0.9)
                        
                        // Body text
                        Text("Simply point your camera at any Yu-Gi-Oh card. Our AI instantly recognizes the card, provides market prices, and grades its condition.")
                            .font(.system(size: min(geometry.size.height * 0.02, 16), weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: geometry.size.width * 0.8)
                    }
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Capsule()
                            .fill(.white)
                            .frame(width: geometry.size.width * 0.9, height: 56)
                            .overlay(
                                Text("Continue")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.19))
                            )
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 30))
                }
            }
        }
    }
}