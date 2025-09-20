//
//  OnboardingView1.swift
//  tcgscanner
//

import SwiftUI

struct OnboardingView1: View {
    @Binding var currentPage: Int
    @State private var iconScale = 0.5
    @State private var iconRotation = -180.0
    @State private var glowOpacity = 0.0
    @State private var textOpacity = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Star Wars space background
                StarsBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Central Visual Animation - at the top
                    ZStack {
                        // Outer pulsing ring
                        Circle()
                            .stroke(Color.starWarsYellow.opacity(0.3), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                            .scaleEffect(glowOpacity)
                            .opacity(1 - glowOpacity)
                        
                        // Animated glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.starWarsYellow.opacity(0.4),
                                        Color.starWarsYellow.opacity(0.2),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: geometry.size.height * 0.04,
                                    endRadius: geometry.size.height * 0.12
                                )
                            )
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .blur(radius: 15)
                            .opacity(glowOpacity)
                        
                        // Star Wars themed icon - Rebel Alliance symbol
                        StarWarsIcon(name: .rebel, size: min(geometry.size.width * 0.25, 100))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.starWarsYellow, Color.starWarsYellow.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: Color.starWarsYellow.opacity(0.6), radius: 25)
                            .scaleEffect(iconScale)
                            .rotation3DEffect(
                                .degrees(iconRotation),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: 0.5
                            )
                    }
                    .padding(.top, geometry.safeAreaInsets.top + geometry.size.height * 0.1)
                    .onAppear {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                            iconScale = 1.0
                            iconRotation = 0
                        }
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            glowOpacity = 1.0
                        }
                        withAnimation(.easeIn(duration: 0.8).delay(0.5)) {
                            textOpacity = 1.0
                        }
                    }
                    
                    Spacer(minLength: geometry.size.height * 0.05)
                    
                    VStack(spacing: geometry.size.height * 0.025) {
                        // Headline - Bold, Uppercase
                        Text("THE FORCE AWAKENS IN\nYOUR CARD COLLECTION")
                            .font(.system(size: min(geometry.size.height * 0.035, 28), weight: .black))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: geometry.size.width * 0.9)
                            .opacity(textOpacity)
                            .offset(y: textOpacity == 1 ? 0 : 20)
                        
                        // Body text
                        Text("Instantly identify, grade, and value your Star Wars collection with cutting-edge AI technology trusted by serious collectors worldwide.")
                            .font(.system(size: min(geometry.size.height * 0.02, 16), weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: geometry.size.width * 0.8)
                            .opacity(textOpacity)
                            .offset(y: textOpacity == 1 ? 0 : 20)
                    }
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("BEGIN YOUR JOURNEY")
                                .font(.starWarsTitle(16))
                                .foregroundColor(.black)
                        }
                        .frame(width: geometry.size.width * 0.9, height: 56)
                        .background(Color.starWarsYellow)
                        .cornerRadius(28)
                        .starWarsGlow(color: .starWarsYellow)
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 30))
                }
            }
        }
    }
}