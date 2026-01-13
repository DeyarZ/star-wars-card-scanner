//
//  PaywallView.swift
//  tcgscanner
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
                // Star Wars themed background
                ZStack {
                    // Starfield background
                    StarsBackground()
                        .ignoresSafeArea()
                    
                    // Gradient overlay for readability
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.spaceBlack.opacity(0.3),
                            Color.spaceBlack.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
                
                // Dismiss button in top left
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showPaywall = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.starWarsYellow)
                        }
                        .padding(.top, geometry.safeAreaInsets.top + 10)
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                // Paywall content
                VStack(spacing: 0) {
                    // Top Hero Section with Empire/Rebel symbols
                    ZStack {
                        // Animated glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.starWarsYellow.opacity(0.3),
                                        Color.starWarsYellow.opacity(0.1),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 45,
                                    endRadius: 135
                                )
                            )
                            .frame(width: 180, height: 180)
                            .scaleEffect(scanAnimation ? 1.08 : 0.72)
                            .opacity(scanAnimation ? 0.6 : 0.3)
                        
                        // Central Logo Animation
                        VStack(spacing: 15) {
                            // Death Star or Rebel symbol
                            ZStack {
                                StarWarsIcon(name: .empire, size: 72)
                                    .foregroundColor(.lightsaberRed)
                                    .opacity(scanAnimation ? 0.2 : 0.8)
                                    .scaleEffect(scanAnimation ? 1.08 : 0.9)
                                    .rotation3DEffect(
                                        .degrees(scanAnimation ? 180 : 0),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                
                                StarWarsIcon(name: .rebel, size: 72)
                                    .foregroundColor(.lightsaberBlue)
                                    .opacity(scanAnimation ? 0.8 : 0.2)
                                    .scaleEffect(scanAnimation ? 0.9 : 1.08)
                                    .rotation3DEffect(
                                        .degrees(scanAnimation ? 0 : 180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                            }
                            
                            Text("UNLIMITED POWER")
                                .font(.starWarsTitle(14))
                                .foregroundColor(.starWarsYellow)
                                .starWarsGlow(color: .starWarsYellow)
                                .opacity(scanAnimation ? 1.0 : 0.7)
                        }
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
                        Text(showFreeTrial ? "JOIN THE REBELLION" : "EMBRACE THE DARK SIDE")
                            .font(.starWarsTitle(min(geometry.size.height * 0.035, 28)))
                            .foregroundColor(.white)
                            .starWarsGlow()
                        
                        Text(showFreeTrial ? "3 Days Free Trial" : "Premium Experience")
                            .font(.starWarsDisplay(min(geometry.size.height * 0.024, 20)))
                            .foregroundColor(.starWarsYellow)
                            .starWarsGlow(color: .starWarsYellow)
                        
                        Text("Unlimited scans • Advanced insights • Premium features")
                            .font(.system(size: min(geometry.size.height * 0.016, 14)))
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                            .multilineTextAlignment(.center)
                        
                        Text("Cancel anytime from Settings")
                            .font(.system(size: min(geometry.size.height * 0.014, 12)))
                            .foregroundColor(.displayGreen)
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer()
                    
                    // Pricing in Star Wars style
                    VStack(spacing: 15) {
                        if showFreeTrial {
                            VStack(spacing: 8) {
                                Text("FREE TRIAL PERIOD")
                                    .font(.starWarsBody(14))
                                    .foregroundColor(.displayGreen)
                                    .starWarsGlow(color: .displayGreen)
                                
                                Text("3 DAYS")
                                    .font(.starWarsTitle(36))
                                    .foregroundColor(.white)
                                    .starWarsGlow()
                                
                                if let weeklyProduct = premiumManager.products.first(where: { $0.id == "com.manuelworlitzer.starwarscardscanner.premium.weekly" }) {
                                    Text("Then \(weeklyProduct.displayPrice)/week")
                                        .font(.starWarsDisplay(18))
                                        .foregroundColor(.starWarsYellow)
                                } else {
                                    Text("Loading price...")
                                        .font(.starWarsDisplay(18))
                                        .foregroundColor(.starWarsYellow)
                                }
                            }
                        } else {
                            VStack(spacing: 8) {
                                Text("ANNUAL MEMBERSHIP")
                                    .font(.starWarsBody(14))
                                    .foregroundColor(.lightsaberRed)
                                    .starWarsGlow(color: .lightsaberRed)
                                
                                if let yearlyProduct = premiumManager.products.first(where: { $0.id == "com.manuelworlitzer.starwarscardscanner.premium.yearly" }) {
                                    Text(yearlyProduct.displayPrice)
                                        .font(.starWarsTitle(36))
                                        .foregroundColor(.white)
                                        .starWarsGlow()

                                    Text("Per Year")
                                        .font(.starWarsDisplay(18))
                                        .foregroundColor(.starWarsYellow)
                                } else {
                                    Text("Loading price...")
                                        .font(.starWarsTitle(36))
                                        .foregroundColor(.white)
                                        .starWarsGlow()

                                    Text("")
                                        .font(.starWarsDisplay(18))
                                        .foregroundColor(.starWarsYellow)
                                }
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                    // Toggle container with Star Wars styling
                    HStack {
                        VStack(alignment: .leading) {
                            Text("CHOOSE YOUR PATH")
                                .font(.starWarsBody(12))
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text(showFreeTrial ? "FREE TRIAL" : "FULL POWER")
                                    .font(.starWarsTitle(16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $showFreeTrial)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.starWarsYellow))
                                    .labelsHidden()
                            }
                        }
                    }
                    .padding()
                    .starWarsCard()
                    .padding(.bottom, geometry.size.height * 0.02)
                    
                    // Purchase button with Star Wars styling
                    Button(action: {
                        Task {
                            await purchaseProduct()
                        }
                    }) {
                        HStack {
                            StarWarsIcon(name: showFreeTrial ? .rebel : .empire, size: 24)
                                .foregroundColor(.black)
                            
                            Text(showFreeTrial ? "BEGIN FREE TRIAL" : "JOIN THE EMPIRE")
                                .font(.starWarsTitle(18))
                                .foregroundColor(.black)
                        }
                        .frame(width: geometry.size.width * 0.9, height: 60)
                        .background(Color.starWarsYellow)
                        .cornerRadius(30)
                        .starWarsGlow(color: .starWarsYellow)
                    }
                    .padding(.bottom, 15)
                    
                    // Restore Purchase Link
                    Button(action: {
                        Task {
                            await restorePurchases()
                        }
                    }) {
                        Text("Restore Purchases")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 30))
                    
                    // Footer text
                    Text("This is the way.")
                        .font(.starWarsDisplay(14))
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
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
            "com.manuelworlitzer.starwarscardscanner.premium.weekly" :
            "com.manuelworlitzer.starwarscardscanner.premium.yearly"
        
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
    
    func restorePurchases() async {
        isProcessingPurchase = true
        
        do {
            await premiumManager.restorePurchases()
            if premiumManager.isPremium {
                // Restore successful
                isProcessingPurchase = false
                showPaywall = false
            } else {
                // No purchases found
                errorMessage = "No purchases found. Make sure you're signed in with the same Apple ID."
                showError = true
                isProcessingPurchase = false
            }
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
            showError = true
            isProcessingPurchase = false
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.starWarsYellow)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}