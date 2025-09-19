//
//  PaywallView.swift
//  yugiohcardscanner
//

import SwiftUI

struct PaywallView: View {
    @Binding var showPaywall: Bool
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var scanAnimation = false
    @State private var showFreeTrial = true
    @State private var isProcessingPurchase = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Video background with fallback
                ZStack {
                    // Fallback gradient background
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.11, green: 0.11, blue: 0.19),
                            Color(red: 0.18, green: 0.14, blue: 0.26)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Video player
                    FinalVideoPlayer()
                        .ignoresSafeArea()
                    
                    // Semi-transparent overlay
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    // Bottom gradient overlay
                    VStack {
                        Spacer()
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.8),
                                Color.black
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: geometry.size.height * 0.3)
                    }
                    .ignoresSafeArea()
                }
                
                // Dismiss button in top corner
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showPaywall = false
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.6))
                            }
                        }
                        .padding(.top, geometry.safeAreaInsets.top + 10)
                        .padding(.trailing, 20)
                    }
                    
                    Spacer()
                }
                
                // Paywall content
                VStack(spacing: 0) {
                    // Top animation (25% of screen)
                    ZStack {
                        // Phone mockup
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.025)
                            .fill(Color.black.opacity(0.3))
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                            .overlay(
                                RoundedRectangle(cornerRadius: geometry.size.height * 0.025)
                                    .stroke(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.5), lineWidth: 2)
                            )
                        
                        // Screen content
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.02)
                            .fill(Color(red: 0.05, green: 0.05, blue: 0.05).opacity(0.5))
                            .frame(width: geometry.size.width * 0.27, height: geometry.size.height * 0.185)
                            .overlay(
                                VStack {
                                    // Scanning animation
                                    ZStack {
                                        // Card being scanned
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(red: 0.8, green: 0.6, blue: 0.2).opacity(0.5), Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.11)
                                            .rotation3DEffect(
                                                .degrees(scanAnimation ? 5 : -5),
                                                axis: (x: 0, y: 1, z: 0)
                                            )
                                        
                                        // Scan line
                                        Rectangle()
                                            .fill(Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.6))
                                            .frame(width: geometry.size.width * 0.18, height: 2)
                                            .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5), radius: 10)
                                            .offset(y: scanAnimation ? geometry.size.height * 0.055 : -geometry.size.height * 0.055)
                                    }
                                    
                                    Text("SCANNING...")
                                        .font(.system(size: min(geometry.size.height * 0.01, 8), weight: .bold))
                                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.7))
                                        .padding(.top, geometry.size.height * 0.015)
                                }
                            )
                    }
                    .frame(height: geometry.size.height * 0.25)
                    .padding(.top, geometry.safeAreaInsets.top + geometry.size.height * 0.05)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            scanAnimation = true
                        }
                    }
                    
                    // Headlines
                    VStack(spacing: geometry.size.height * 0.015) {
                        Text(showFreeTrial ? "Test it 3 days for free" : "Enjoy the premium experience")
                            .font(.system(size: min(geometry.size.height * 0.035, 28), weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Scan unlimited, get insights and more")
                            .font(.system(size: min(geometry.size.height * 0.018, 16)))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                        
                        Text("Cancel anytime")
                            .font(.system(size: min(geometry.size.height * 0.016, 14)))
                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer()
                    
                    // Pricing
                    VStack(spacing: geometry.size.height * 0.01) {
                        if showFreeTrial {
                            Text("3 days free then")
                                .font(.system(size: min(geometry.size.height * 0.022, 18), weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("$6.99 per week")
                                .font(.system(size: min(geometry.size.height * 0.035, 28), weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Auto renewable. Cancel anytime")
                                .font(.system(size: min(geometry.size.height * 0.014, 12)))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        } else {
                            Text("$99.99 per year")
                                .font(.system(size: min(geometry.size.height * 0.035, 28), weight: .bold))
                                .foregroundColor(.white)
                            
                            // Spacer to maintain layout
                            Text(" ")
                                .font(.system(size: min(geometry.size.height * 0.022, 18)))
                            Text(" ")
                                .font(.system(size: min(geometry.size.height * 0.014, 12)))
                        }
                    }
                    
                    Spacer()
                    
                    // Toggle container
                    ZStack {
                        Capsule()
                            .fill(Color(red: 0.08, green: 0.08, blue: 0.08))
                            .frame(width: geometry.size.width * 0.9, height: 56)
                        
                        HStack {
                            Text("3 days free")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Toggle("", isOn: $showFreeTrial)
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 1.0, green: 0.8, blue: 0.2)))
                                .labelsHidden()
                        }
                        .padding(.horizontal, geometry.size.width * 0.05)
                        .frame(width: geometry.size.width * 0.9)
                    }
                    .padding(.bottom, geometry.size.height * 0.02)
                    
                    // Purchase button
                    Button(action: {
                        Task {
                            await purchaseProduct()
                        }
                    }) {
                        Capsule()
                            .fill(.white)
                            .frame(width: geometry.size.width * 0.9, height: 56)
                            .overlay(
                                Text("Test for free")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.19))
                            )
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 30))
                }
            }
        }
        .alert("Purchase Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .overlay {
            if isProcessingPurchase {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        
                        Text("Processing...")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                    .padding(30)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.25))
                    .cornerRadius(15)
                }
            }
        }
    }
    
    func purchaseProduct() async {
        isProcessingPurchase = true
        
        let productId = showFreeTrial ? 
            "com.manuelworlitzer.yugiohcardscanner.premium.weekly" :
            "com.manuelworlitzer.yugiohcardscanner.premium.yearly"
        
        guard let product = premiumManager.products.first(where: { $0.id == productId }) else {
            errorMessage = "Product not found. Please try again later."
            showError = true
            isProcessingPurchase = false
            return
        }
        
        do {
            if try await premiumManager.purchase(product) != nil {
                // Purchase successful
                isProcessingPurchase = false
                showPaywall = false
            } else {
                // User cancelled
                isProcessingPurchase = false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            showError = true
            isProcessingPurchase = false
        }
    }
}