//
//  ContentView.swift
//  tcgscanner
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
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.imperialGray)
        
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
        UINavigationBar.appearance().barTintColor = UIColor(Color.spaceBlack)
        UINavigationBar.appearance().backgroundColor = UIColor(Color.spaceBlack)
    }
    
    var body: some View {
        ZStack {
            TabView {
                CollectionView()
                    .tabItem {
                        VStack {
                            Image(systemName: "rectangle.stack.fill")
                                .environment(\.symbolVariants, .none)
                            Text("COLLECTION")
                                .font(.caption2)
                        }
                    }
                
                ScannerView()
                    .tabItem {
                        VStack {
                            Image(systemName: "viewfinder.circle.fill")
                                .environment(\.symbolVariants, .none)
                            Text("SCANNER")
                                .font(.caption2)
                        }
                    }
                
                SearchView()
                    .tabItem {
                        VStack {
                            Image(systemName: "sparkle.magnifyingglass")
                                .environment(\.symbolVariants, .none)
                            Text("SEARCH")
                                .font(.caption2)
                        }
                    }
            }
            .accentColor(Color.starWarsYellow)
            
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
    @State private var showingStats = false
    @State private var showingExportOptions = false
    @State private var showingFilters = false
    @State private var sortOption: SortOption = .dateNewest
    @State private var filterFaction: String? = nil
    @State private var filterRarity: String? = nil
    @State private var filterGameType: String? = nil
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    enum SortOption: String, CaseIterable {
        case dateNewest = "Date (Newest)"
        case dateOldest = "Date (Oldest)"
        case nameAsc = "Name (A-Z)"
        case nameDesc = "Name (Z-A)"
        case valueHigh = "Value (High)"
        case valueLow = "Value (Low)"
        
        var icon: String {
            switch self {
            case .dateNewest, .dateOldest: return "calendar"
            case .nameAsc, .nameDesc: return "textformat.abc"
            case .valueHigh, .valueLow: return "dollarsign.circle"
            }
        }
    }
    
    var totalValue: Double {
        filteredAndSortedCards.compactMap { $0.tcgplayerPrice }.reduce(0, +)
    }
    
    var filteredAndSortedCards: [SavedCard] {
        var cards = savedCards
        
        // Apply filters
        if let faction = filterFaction {
            cards = cards.filter { $0.faction == faction }
        }
        
        if let rarity = filterRarity {
            cards = cards.filter { $0.rarity == rarity }
        }
        
        if let gameType = filterGameType {
            cards = cards.filter { $0.gameType == gameType }
        }
        
        // Apply sorting
        switch sortOption {
        case .dateNewest:
            cards.sort { $0.dateScanned > $1.dateScanned }
        case .dateOldest:
            cards.sort { $0.dateScanned < $1.dateScanned }
        case .nameAsc:
            cards.sort { $0.name < $1.name }
        case .nameDesc:
            cards.sort { $0.name > $1.name }
        case .valueHigh:
            cards.sort { ($0.tcgplayerPrice ?? 0) > ($1.tcgplayerPrice ?? 0) }
        case .valueLow:
            cards.sort { ($0.tcgplayerPrice ?? 0) < ($1.tcgplayerPrice ?? 0) }
        }
        
        return cards
    }
    
    var availableFactions: [String] {
        Array(Set(savedCards.compactMap { $0.faction })).sorted()
    }
    
    var availableRarities: [String] {
        Array(Set(savedCards.map { $0.rarity })).sorted()
    }
    
    var availableGameTypes: [String] {
        Array(Set(savedCards.map { $0.gameType })).sorted()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                if savedCards.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "rectangle.stack.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(Color.imperialGray)
                        
                        Text("NO CARDS SCANNED YET")
                            .font(.starWarsTitle(18))
                            .kerning(1)
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            .starWarsGlow()
                        
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
                                    Text("\(filteredAndSortedCards.count)")
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
                                        .foregroundColor(Color.starWarsYellow)
                                        .starWarsGlow(color: .starWarsYellow)
                                }
                            }
                            .padding()
                            .background(Color.imperialGray)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .hologramEffect()
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(filteredAndSortedCards) { card in
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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        HStack(spacing: 2) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            if filterFaction != nil || filterRarity != nil || filterGameType != nil {
                                Circle()
                                    .fill(Color.lightsaberRed)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .foregroundColor(.starWarsYellow)
                    }
                    
                    Button(action: { showingExportOptions = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.starWarsYellow)
                    }
                    .disabled(savedCards.isEmpty)
                    
                    Button(action: { showingStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.starWarsYellow)
                    }
                }
            }
            .sheet(item: $selectedCard) { card in
                CardDetailView(card: card)
            }
            .sheet(isPresented: $showingStats) {
                CollectionStatsView()
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsSheet(cards: filteredAndSortedCards)
            }
            .sheet(isPresented: $showingFilters) {
                FilterSortSheet(
                    sortOption: $sortOption,
                    filterFaction: $filterFaction,
                    filterRarity: $filterRarity,
                    filterGameType: $filterGameType,
                    availableFactions: availableFactions,
                    availableRarities: availableRarities,
                    availableGameTypes: availableGameTypes
                )
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
                    .fill(Color.imperialGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.hologramBlue.opacity(0.3), lineWidth: 1)
                    )
                    .frame(height: 250)
                    .overlay(
                        VStack {
                            Text(card.name.uppercased())
                                .font(.starWarsBody(11))
                                .bold()
                                .kerning(0.5)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 4)
                            
                            Spacer()
                            
                            ProgressView()
                                .tint(Color.starWarsYellow)
                            
                            Spacer()
                            
                            if card.cardType.contains("Unit") || card.cardType.contains("Monster") { // Star Wars Units or legacy Monsters
                                HStack {
                                    Text("POWER/\(card.attack)")
                                        .font(.caption2)
                                        .bold()
                                    
                                    Text("HEALTH/\(card.defense)")
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
        // First try to use stored photo data
        if let imageData = card.imageData, let image = UIImage(data: imageData) {
            self.cardImage = image
            return
        }
        
        // Fallback to URL if no stored image
        guard let url = URL(string: card.imageUrl), !card.imageUrl.isEmpty else { return }
        
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
                StarsBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    ZStack {
                        Circle()
                            .fill(Color.starWarsYellow.opacity(0.1))
                            .frame(width: 120, height: 120)
                            .starWarsGlow(color: .starWarsYellow)
                        
                        Image(systemName: "viewfinder.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color.starWarsYellow)
                    }
                    
                    Text("SCAN CARDS")
                        .font(.starWarsTitle(28))
                        .bold()
                        .kerning(3)
                        .foregroundColor(.white)
                        .starWarsGlow()
                    
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
                            Image(systemName: "viewfinder")
                            Text("ACTIVATE")
                                .font(.starWarsTitle(16))
                                .bold()
                                .kerning(1)
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.starWarsYellow)
                        .cornerRadius(25)
                        .starWarsGlow()
                    }
                    
                    if let card = scannedCard {
                        VStack {
                            Text("Last Scanned:")
                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                            Text(card.name.uppercased())
                                .font(.starWarsTitle(16))
                                .bold()
                                .kerning(0.5)
                                .foregroundColor(Color.starWarsYellow)
                                .starWarsGlow(color: .starWarsYellow)
                            
                            if let price = card.tcgplayerPrice {
                                Text(String(format: "$%.2f", price))
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                            }
                        }
                        .padding()
                        .starWarsCard()
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
    @State private var searchResults: [StarWarsUnlimitedCard] = []
    @State private var isSearching = false
    @State private var selectedCard: StarWarsUnlimitedCard?
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                VStack {
                    SearchBar(text: $searchText, onSubmit: performSearch)
                    
                    if isSearching {
                        ProgressView("Searching...")
                            .foregroundColor(.white)
                            .frame(maxHeight: .infinity)
                    } else if searchResults.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "xmark.circle.fill")
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
                                .foregroundColor(Color.starWarsYellow)
                            
                            Text("SEARCH DATABASE")
                                .font(.starWarsTitle(24))
                                .bold()
                                .kerning(2)
                                .foregroundColor(.white)
                                .starWarsGlow()
                            
                            Text("Find cards by name, type, or attribute")
                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(searchResults) { card in
                                    StarWarsSearchResultView(card: card)
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
                StarWarsSearchDetailView(card: card)
            }
        }
    }
    
    func performSearch() {
        isSearching = true
        searchResults = []
        
        // Simulate network delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchResults = StarWarsCardDatabase.search(query: self.searchText)
            self.isSearching = false
        }
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
                .accentColor(Color.starWarsYellow)
                .onSubmit {
                    onSubmit()
                }
        }
        .padding()
        .starWarsCard()
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct OnlineSearchResultView: View {
    let cardData: YGOCardData
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.imperialGray)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.hologramBlue.opacity(0.3), lineWidth: 1)
                )
                .frame(width: 60, height: 80)
                .overlay(
                    Image(systemName: "sparkles")
                        .foregroundColor(Color.starWarsYellow.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(cardData.name.uppercased())
                    .font(.starWarsTitle(14))
                    .bold()
                    .kerning(0.5)
                    .foregroundColor(.white)
                
                Text(cardData.type)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                
                if let atk = cardData.atk, let def = cardData.def { // Legacy ATK/DEF -> Power/Health
                    HStack {
                        Label("\(atk)", systemImage: "flame.fill") // Power
                            .font(.caption)
                            .foregroundColor(.red)
                        
                        Label("\(def)", systemImage: "shield.fill") // Health
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                if let rarity = cardData.card_sets?.first?.set_rarity {
                    Text(rarity.uppercased())
                        .font(.starWarsBody(10))
                        .bold()
                        .kerning(0.5)
                        .foregroundColor(Color.starWarsYellow)
                }
                
                if let level = cardData.level {
                    HStack {
                        ForEach(0..<level, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(Color.starWarsYellow)
                        }
                    }
                }
            }
        }
        .padding()
        .starWarsCard()
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