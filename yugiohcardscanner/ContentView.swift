//
//  ContentView.swift
//  yugiohcardscanner
//
//  Created by Deyar Zakir on 18.09.25.
//

import SwiftUI
import AVFoundation
import SwiftData

struct ContentView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    @State private var showPaywall = false
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(red: 0.4, green: 0.4, blue: 0.4))
        
        // Fix navigation bar appearance
        let customFont = UIFont(name: "Arial Black", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: customFont,
            .kern: 3.0
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Arial Black", size: 20) ?? UIFont.boldSystemFont(ofSize: 20),
            .kern: 2.0
        ]
        UINavigationBar.appearance().barTintColor = UIColor(Color(red: 0.05, green: 0.05, blue: 0.05))
        UINavigationBar.appearance().backgroundColor = UIColor(Color(red: 0.05, green: 0.05, blue: 0.05))
    }
    
    var body: some View {
        ZStack {
            TabView {
                CollectionView()
                    .tabItem {
                        Label("Collection", systemImage: "rectangle.stack.fill")
                    }
                
                ScannerView()
                    .tabItem {
                        Label("Scanner", systemImage: "eye.fill")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "sparkle.magnifyingglass")
                    }
            }
            .accentColor(Color(red: 1.0, green: 0.8, blue: 0.2))
            
            if showOnboarding {
                OnboardingContainer(showOnboarding: $showOnboarding)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            if !hasCompletedOnboarding {
                showOnboarding = true
            } else if !premiumManager.isPremium {
                // Show paywall only for non-premium users
                showPaywall = true
            }
        }
        .onChange(of: showOnboarding) { oldValue, newValue in
            if !newValue && !hasCompletedOnboarding {
                hasCompletedOnboarding = true
                // Show paywall after onboarding completes
                showPaywall = true
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(showPaywall: $showPaywall)
                .environmentObject(premiumManager)
        }
    }
}

struct CollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedCard.dateScanned, order: .reverse) private var savedCards: [SavedCard]
    @State private var selectedCard: SavedCard?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var totalValue: Double {
        savedCards.compactMap { $0.tcgplayerPrice }.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.05)
                    .ignoresSafeArea()
                
                if savedCards.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "rectangle.stack.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        
                        Text("NO CARDS SCANNED YET")
                            .font(.custom("Arial Black", size: 18))
                            .kerning(1)
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        
                        Text("Use the scanner to add cards")
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total Cards")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                                    Text("\(savedCards.count)")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Total Value")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                                    Text(String(format: "$%.2f", totalValue))
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                                }
                            }
                            .padding()
                            .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(savedCards) { card in
                                    SavedCardView(card: card)
                                        .onTapGesture {
                                            selectedCard = card
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("COLLECTION")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedCard) { card in
                CardDetailView(card: card)
            }
        }
    }
}

struct SavedCardView: View {
    let card: SavedCard
    @State private var cardImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = cardImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 3)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1)
                    )
                    .frame(height: 250)
                    .overlay(
                        VStack {
                            Text(card.name.uppercased())
                                .font(.custom("Arial Black", size: 11))
                                .bold()
                                .kerning(0.5)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 4)
                            
                            Spacer()
                            
                            ProgressView()
                                .tint(Color(red: 1.0, green: 0.8, blue: 0.2))
                            
                            Spacer()
                            
                            if card.type.contains("Monster") {
                                HStack {
                                    Text("ATK/\(card.attack)")
                                        .font(.caption2)
                                        .bold()
                                    
                                    Text("DEF/\(card.defense)")
                                        .font(.caption2)
                                        .bold()
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(8)
                    )
            }
        }
        .onAppear {
            loadCardImage()
        }
    }
    
    func loadCardImage() {
        guard let url = URL(string: card.imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.cardImage = image
                }
            }
        }.resume()
    }
}

struct ScannerView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var isShowingScanner = false
    @State private var scannedCard: SavedCard?
    @State private var showingAlert = false
    @State private var showingLimitAlert = false
    @State private var showPaywall = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.05)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "eye.trianglebadge.exclamationmark")
                            .font(.system(size: 80))
                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                    }
                    
                    Text("SCAN CARDS")
                        .font(.custom("Arial Black", size: 28))
                        .bold()
                        .kerning(3)
                        .foregroundColor(.white)
                    
                    Text("Position your card within the frame")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    
                    Button(action: {
                        if premiumManager.canScanToday() {
                            checkCameraPermission()
                        } else {
                            showingLimitAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("ACTIVATE")
                                .font(.custom("Arial Black", size: 16))
                                .bold()
                                .kerning(1)
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(red: 1.0, green: 0.8, blue: 0.2))
                        .cornerRadius(25)
                    }
                    
                    if let card = scannedCard {
                        VStack {
                            Text("Last Scanned:")
                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                            Text(card.name.uppercased())
                                .font(.custom("Arial Black", size: 16))
                                .bold()
                                .kerning(0.5)
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                            
                            if let price = card.tcgplayerPrice {
                                Text(String(format: "$%.2f", price))
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                            }
                        }
                        .padding()
                        .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("SCANNER")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingScanner) {
                CameraScannerView(scannedCard: $scannedCard)
            }
            .alert("Camera Permission", isPresented: $showingAlert) {
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable camera access in Settings to scan cards.")
            }
            .alert("Daily Limit Reached", isPresented: $showingLimitAlert) {
                Button("Upgrade to Premium") {
                    showPaywall = true
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text("Free users get 1 scan per day. Upgrade to Premium for unlimited scans!")
            }
            .fullScreenCover(isPresented: $showPaywall) {
                PaywallView(showPaywall: $showPaywall)
                    .environmentObject(premiumManager)
            }
        }
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isShowingScanner = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    isShowingScanner = true
                }
            }
        case .denied, .restricted:
            showingAlert = true
        @unknown default:
            break
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [YGOCardData] = []
    @State private var isSearching = false
    @State private var selectedCard: YGOCardData?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.05)
                    .ignoresSafeArea()
                
                VStack {
                    SearchBar(text: $searchText, onSubmit: performSearch)
                    
                    if isSearching {
                        ProgressView("Searching...")
                            .foregroundColor(.white)
                            .frame(maxHeight: .infinity)
                    } else if searchResults.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            
                            Text("No cards found")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .frame(maxHeight: .infinity)
                    } else if searchResults.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                            
                            Text("SEARCH DATABASE")
                                .font(.custom("Arial Black", size: 24))
                                .bold()
                                .kerning(2)
                                .foregroundColor(.white)
                            
                            Text("Find cards by name, type, or attribute")
                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(searchResults, id: \.id) { card in
                                    OnlineSearchResultView(cardData: card)
                                        .onTapGesture {
                                            selectedCard = card
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("CARD SEARCH")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedCard) { card in
                OnlineCardDetailView(cardData: card)
            }
        }
    }
    
    func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        searchResults = []
        
        let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=\(encodedSearch)") else {
            isSearching = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(YGOCardResponse.self, from: data)
                        searchResults = response.data
                    } catch {
                        searchResults = []
                    }
                }
            }
        }.resume()
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onSubmit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
            
            TextField("Search cards...", text: $text)
                .foregroundColor(.white)
                .accentColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                .onSubmit {
                    onSubmit()
                }
        }
        .padding()
        .background(Color(red: 0.08, green: 0.08, blue: 0.08))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct OnlineSearchResultView: View {
    let cardData: YGOCardData
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1)
                )
                .frame(width: 60, height: 80)
                .overlay(
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(cardData.name.uppercased())
                    .font(.custom("Arial Black", size: 14))
                    .bold()
                    .kerning(0.5)
                    .foregroundColor(.white)
                
                Text(cardData.type)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                
                if let atk = cardData.atk, let def = cardData.def {
                    HStack {
                        Label("\(atk)", systemImage: "flame.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                        
                        Label("\(def)", systemImage: "shield.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                if let rarity = cardData.card_sets?.first?.set_rarity {
                    Text(rarity.uppercased())
                        .font(.custom("Arial Black", size: 10))
                        .bold()
                        .kerning(0.5)
                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                }
                
                if let level = cardData.level {
                    HStack {
                        ForEach(0..<level, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 0.08, green: 0.08, blue: 0.08))
        .cornerRadius(10)
    }
}

struct OnlineCardDetailView: View {
    let cardData: YGOCardData
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let card = CardScannerService.shared.convertToSavedCard(from: cardData, psaRating: 0)
        CardDetailView(card: card)
    }
}

extension YGOCardData: Identifiable {}

#Preview {
    ContentView()
        .modelContainer(for: SavedCard.self, inMemory: true)
}