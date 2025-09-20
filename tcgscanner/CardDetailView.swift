//
//  CardDetailView.swift
//  tcgscanner
//
//  Created by Assistant on 18.09.25.
//

import SwiftUI

struct CardDetailView: View {
    let card: SavedCard
    @Environment(\.dismiss) private var dismiss
    @State private var loadedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Card Image
                        if let image = loadedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 400)
                                .shadow(color: Color.starWarsYellow.opacity(0.5), radius: 10)
                                .starWarsGlow(color: .starWarsYellow)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.imperialGray)
                                .frame(height: 400)
                                .overlay(
                                    LightsaberLoadingView()
                                )
                        }
                        
                        // Card Info
                        VStack(alignment: .leading, spacing: 15) {
                            Text(card.name.uppercased())
                                .font(.starWarsTitle(24))
                                .kerning(1)
                                .foregroundColor(.white)
                                .starWarsGlow()
                            
                            HStack {
                                Label("LV.\(card.level)", systemImage: "star.fill")
                                    .foregroundColor(Color.starWarsYellow)
                                
                                Spacer()
                                
                                if let faction = card.faction {
                                    HStack(spacing: 5) {
                                        Image(systemName: factionIcon(for: faction))
                                            .foregroundColor(factionColor(for: faction))
                                        Text(faction.uppercased())
                                            .font(.starWarsBody(10))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(factionColor(for: faction).opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(factionColor(for: faction), lineWidth: 1)
                                    )
                                    .cornerRadius(8)
                                    .foregroundColor(factionColor(for: faction))
                                }
                                
                                Text(card.attribute)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.imperialGray)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .hologramEffect()
                            }
                            .font(.starWarsBody(14))
                            
                            // Rarity Badge
                            if !card.rarity.isEmpty && card.rarity != "Unknown" {
                                RarityBadge(rarity: card.rarity)
                            }
                            
                            // PSA Rating
                            if let psaRating = card.psaRating {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("PSA RATING")
                                            .font(.starWarsDisplay(16))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Text("\(psaRating)")
                                            .font(.starWarsTitle(24))
                                            .foregroundColor(psaColor(for: psaRating))
                                            .starWarsGlow(color: psaColor(for: psaRating))
                                    }
                                    
                                    // Condition details from GPT analysis
                                    if let analysis = CardScannerService.shared.lastCardAnalysis {
                                        VStack(alignment: .leading, spacing: 5) {
                                            if let edition = analysis["edition"] as? String {
                                                HStack {
                                                    Text("EDITION")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                    Text(edition.uppercased())
                                                        .font(.starWarsDisplay(12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            
                                            if let set = analysis["set"] as? String {
                                                HStack {
                                                    Text("SET CODE")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                    Text(set)
                                                        .font(.starWarsDisplay(12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            
                                            if let condition = analysis["condition"] as? String {
                                                HStack {
                                                    Text("CONDITION")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                    Text(condition.uppercased())
                                                        .font(.starWarsDisplay(12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        .padding(.top, 5)
                                        
                                        Divider()
                                            .background(Color.imperialGray)
                                        
                                        // Grading breakdown
                                        VStack(alignment: .leading, spacing: 3) {
                                            if let centering = analysis["centering_notes"] as? String {
                                                Text("• Centering: \(centering)")
                                                    .font(.caption)
                                                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                                            }
                                            if let surface = analysis["surface_notes"] as? String {
                                                Text("• Surface: \(surface)")
                                                    .font(.caption)
                                                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                                            }
                                            if let corners = analysis["corner_notes"] as? String {
                                                Text("• Corners: \(corners)")
                                                    .font(.caption)
                                                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                                            }
                                            if let edges = analysis["edge_notes"] as? String {
                                                Text("• Edges: \(edges)")
                                                    .font(.caption)
                                                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .starWarsCard()
                            }
                            
                            // Card Stats for Star Wars cards
                            if card.cardType.contains("Unit") || card.cardType.contains("Monster") { // Star Wars Units or legacy Monsters
                                VStack(spacing: 15) {
                                    // Cost at the top
                                    if let cost = card.cost, cost > 0 {
                                        HStack {
                                            Text("COST")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Color.spaceBlack)
                                                    .frame(width: 40, height: 40)
                                                Text(String(cost))
                                                    .font(.starWarsTitle(20))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                        .background(Color.imperialGray.opacity(0.5))
                                    
                                    // Power and Health
                                    HStack(spacing: 30) {
                                        VStack {
                                            HStack {
                                                Image(systemName: "flame.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.lightsaberRed)
                                                Text("POWER")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Text(card.attack)
                                                .font(.starWarsTitle(24))
                                                .foregroundColor(.lightsaberRed)
                                                .starWarsGlow(color: .lightsaberRed)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            HStack {
                                                Image(systemName: "shield.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.lightsaberBlue)
                                                Text("HEALTH")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Text(card.defense)
                                                .font(.starWarsTitle(24))
                                                .foregroundColor(.lightsaberBlue)
                                                .starWarsGlow(color: .lightsaberBlue)
                                        }
                                    }
                                    
                                    // Arena and Traits
                                    if let arena = card.arena {
                                        HStack {
                                            Text("ARENA")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Spacer()
                                            HStack {
                                                Image(systemName: arena == "Space" ? "airplane" : "figure.walk")
                                                    .font(.caption)
                                                Text(arena.uppercased())
                                                    .font(.starWarsBody(12))
                                            }
                                            .foregroundColor(.starWarsYellow)
                                        }
                                    }
                                    
                                    if let traits = card.traits, !traits.isEmpty {
                                        VStack(alignment: .leading) {
                                            Text("TRAITS")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            
                                            HStack {
                                                ForEach(traits, id: \.self) { trait in
                                                    Text(trait.uppercased())
                                                        .font(.starWarsBody(10))
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(Color.imperialGray.opacity(0.5))
                                                        .cornerRadius(5)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if let aspect = card.aspect {
                                        HStack {
                                            Text("ASPECT")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text(aspect.uppercased())
                                                .font(.starWarsBody(12))
                                                .foregroundColor(aspectColor(for: aspect))
                                        }
                                    }
                                }
                                .padding()
                                .starWarsCard()
                            }
                            
                            // Description
                            Text(card.cardDescription)
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .padding()
                                .starWarsCard()
                            
                            // Prices
                            VStack(alignment: .leading, spacing: 10) {
                                Text("MARKET PRICES")
                                    .font(.starWarsTitle(18))
                                    .foregroundColor(.white)
                                    .starWarsGlow()
                                
                                if let tcgPrice = card.tcgplayerPrice {
                                    HStack {
                                        Text("TCGPlayer")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "$%.2f", tcgPrice))
                                            .font(.starWarsDisplay(16))
                                            .foregroundColor(.starWarsYellow)
                                            .starWarsGlow(color: .starWarsYellow)
                                    }
                                }
                                
                                if let marketPrice = card.cardmarketPrice {
                                    HStack {
                                        Text("Cardmarket")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "€%.2f", marketPrice))
                                            .font(.starWarsDisplay(16))
                                            .foregroundColor(.starWarsYellow)
                                            .starWarsGlow(color: .starWarsYellow)
                                    }
                                }
                                
                                if let ebayPrice = card.ebayPrice {
                                    HStack {
                                        Text("eBay Average")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "$%.2f", ebayPrice))
                                            .font(.starWarsDisplay(16))
                                            .foregroundColor(.starWarsYellow)
                                            .starWarsGlow(color: .starWarsYellow)
                                    }
                                }
                                
                                if let analysis = CardScannerService.shared.lastCardAnalysis,
                                   let estimatedValue = analysis["estimated_raw_value"] as? Double {
                                    Divider()
                                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    
                                    HStack {
                                        Text("AI Estimated Value")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "$%.2f", estimatedValue))
                                            .font(.starWarsDisplay(16))
                                            .foregroundColor(.displayGreen)
                                            .starWarsGlow(color: .displayGreen)
                                    }
                                }
                            }
                            .padding()
                            .starWarsCard()
                            
                            // TCGPlayer Button
                            if let gameType = card.starWarsGameType {
                                Link(destination: URL(string: PriceLookupService.shared.generateTCGPlayerLink(for: card.name, gameType: gameType))!) {
                                    HStack {
                                        Image(systemName: "creditcard.circle.fill")
                                        Text("CHECK TCGPLAYER")
                                            .font(.custom("Arial Black", size: 16))
                                            .kerning(1)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.2, green: 0.6, blue: 0.9))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            }
                            
                            // eBay Button
                            Link(destination: URL(string: CardScannerService.shared.generateEbayLink(for: card.name))!) {
                                HStack {
                                    Image(systemName: "cart.circle.fill")
                                    Text("SEARCH ON EBAY")
                                        .font(.starWarsTitle(16))
                                        .kerning(1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.starWarsYellow)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .starWarsGlow()
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.starWarsYellow)
                }
            }
        }
        .onAppear {
            loadCardImage()
        }
    }
    
    func loadCardImage() {
        // First try to use stored photo data
        if let imageData = card.imageData, let image = UIImage(data: imageData) {
            self.loadedImage = image
            return
        }
        
        // Fallback to URL if no stored image
        guard let url = URL(string: card.imageUrl), !card.imageUrl.isEmpty else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }.resume()
    }
    
    func psaColor(for rating: Int) -> Color {
        switch rating {
        case 10: return .lightsaberGreen
        case 9: return .displayGreen
        case 8: return .starWarsYellow
        case 7: return .rebelOrange
        default: return .lightsaberRed
        }
    }
    
    func factionIcon(for faction: String) -> String {
        switch faction.lowercased() {
        case "light side", "hero":
            return "sun.max.fill"
        case "dark side", "villain":
            return "moon.fill"
        case "neutral":
            return "circle.hexagongrid.fill"
        default:
            return "sparkles"
        }
    }
    
    func aspectColor(for aspect: String) -> Color {
        switch aspect.lowercased() {
        case "vigilance": return .purple
        case "command": return .green
        case "aggression": return .red
        case "cunning": return .yellow
        case "villainy": return .lightsaberRed
        case "heroism": return .lightsaberBlue
        default: return .gray
        }
    }
    
    func factionColor(for faction: String) -> Color {
        switch faction.lowercased() {
        case "light side", "hero":
            return .lightsaberBlue
        case "dark side", "villain":
            return .lightsaberRed
        case "neutral":
            return .commonGray
        default:
            return .starWarsYellow
        }
    }
}