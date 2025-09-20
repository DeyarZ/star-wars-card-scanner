//
//  StarWarsSearchViews.swift
//  starwarscardscanner
//
//  Search result views for Star Wars cards
//

import SwiftUI

struct StarWarsSearchResultView: View {
    let card: StarWarsUnlimitedCard
    
    var body: some View {
        HStack(spacing: 15) {
            // Card image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.imperialGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(factionBorderColor, lineWidth: 2)
                    )
                    .frame(width: 60, height: 80)
                
                // Icon based on card type
                cardIcon
                    .font(.system(size: 30))
                    .foregroundColor(factionBorderColor.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(card.name.uppercased())
                    .font(.starWarsTitle(14))
                    .bold()
                    .kerning(0.5)
                    .foregroundColor(.white)
                
                if let subtitle = card.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                HStack {
                    Text(card.cardType)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    
                    if let aspect = card.aspect {
                        Text("• \(aspect)")
                            .font(.caption)
                            .foregroundColor(aspectColor(for: aspect))
                    }
                }
                
                if card.cardType == "Unit" {
                    HStack {
                        if let cost = card.cost {
                            HStack(spacing: 2) {
                                Image(systemName: "circlebadge.fill")
                                    .font(.caption2)
                                Text(String(cost))
                            }
                            .font(.caption)
                            .foregroundColor(.white)
                        }
                        
                        if let power = card.power {
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.caption2)
                                Text(String(power))
                            }
                            .font(.caption)
                            .foregroundColor(.lightsaberRed)
                        }
                        
                        if let health = card.health {
                            HStack(spacing: 2) {
                                Image(systemName: "shield.fill")
                                    .font(.caption2)
                                Text(String(health))
                            }
                            .font(.caption)
                            .foregroundColor(.lightsaberBlue)
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(card.rarity.uppercased())
                    .font(.starWarsBody(10))
                    .bold()
                    .kerning(0.5)
                    .foregroundColor(rarityColor)
                
                Text((card.setCode ?? "") + " " + (card.setNumber ?? ""))
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                
                // Estimated price
                Text(String(format: "$%.2f", StarWarsCardDatabase.getEstimatedPrice(for: card)))
                    .font(.starWarsDisplay(14))
                    .foregroundColor(.displayGreen)
            }
        }
        .padding()
        .starWarsCard()
    }
    
    var cardIcon: Image {
        switch card.cardType {
        case "Leader":
            return Image(systemName: "crown.fill")
        case "Unit":
            return Image(systemName: "person.fill")
        case "Event":
            return Image(systemName: "wand.and.stars")
        case "Upgrade":
            return Image(systemName: "arrow.up.square.fill")
        case "Base":
            return Image(systemName: "building.2.fill")
        default:
            return Image(systemName: "sparkles")
        }
    }
    
    var factionBorderColor: Color {
        if let traits = card.traits {
            if traits.contains("Rebel") || card.aspect == "Heroism" {
                return .lightsaberBlue
            } else if traits.contains("Imperial") || traits.contains("Sith") || card.aspect == "Villainy" {
                return .lightsaberRed
            }
        }
        return .starWarsYellow
    }
    
    var rarityColor: Color {
        switch card.rarity.lowercased() {
        case "special rare":
            return .starWarsYellow
        case "legendary":
            return .orange
        case "rare":
            return .purple
        case "uncommon":
            return .blue
        default:
            return .gray
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
}

struct StarWarsSearchDetailView: View {
    let card: StarWarsUnlimitedCard
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showingSaved = false
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Card Image Placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.imperialGray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(factionBorderColor, lineWidth: 3)
                                )
                                .frame(height: 400)
                            
                            VStack {
                                cardIcon
                                    .font(.system(size: 80))
                                    .foregroundColor(factionBorderColor.opacity(0.3))
                                
                                Text("Card Image")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Card Info
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(card.name.uppercased())
                                    .font(.starWarsTitle(24))
                                    .foregroundColor(.white)
                                    .starWarsGlow()
                                
                                Spacer()
                                
                                if card.uniqueness == true {
                                    Image(systemName: "diamond.fill")
                                        .foregroundColor(.starWarsYellow)
                                }
                            }
                            
                            if let subtitle = card.subtitle {
                                Text(subtitle)
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Label(card.cardType, systemImage: "square.stack.3d.up")
                                    .foregroundColor(.white)
                                
                                if let aspect = card.aspect {
                                    Spacer()
                                    Text(aspect)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(aspectColor(for: aspect).opacity(0.3))
                                        .cornerRadius(15)
                                        .foregroundColor(aspectColor(for: aspect))
                                }
                            }
                            
                            if !card.description.isEmpty {
                                Text(card.description)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding()
                                    .starWarsCard()
                            }
                        }
                        .padding(.horizontal)
                        
                        // Stats for Units
                        if card.cardType == "Unit" {
                            HStack(spacing: 30) {
                                if let cost = card.cost {
                                    VStack {
                                        Text("COST")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(String(cost))
                                            .font(.starWarsTitle(28))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                if let power = card.power {
                                    VStack {
                                        Text("POWER")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(String(power))
                                            .font(.starWarsTitle(28))
                                            .foregroundColor(.lightsaberRed)
                                            .starWarsGlow(color: .lightsaberRed)
                                    }
                                }
                                
                                if let health = card.health {
                                    VStack {
                                        Text("HEALTH")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(String(health))
                                            .font(.starWarsTitle(28))
                                            .foregroundColor(.lightsaberBlue)
                                            .starWarsGlow(color: .lightsaberBlue)
                                    }
                                }
                            }
                            .padding()
                            .starWarsCard()
                            .padding(.horizontal)
                        }
                        
                        // Traits
                        if let traits = card.traits, !traits.isEmpty {
                            VStack(alignment: .leading) {
                                Text("TRAITS")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    ForEach(traits, id: \.self) { trait in
                                        Text(trait.uppercased())
                                            .font(.starWarsBody(12))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.imperialGray)
                                            .cornerRadius(15)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Price
                        HStack {
                            Text("ESTIMATED VALUE")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(format: "$%.2f", StarWarsCardDatabase.getEstimatedPrice(for: card)))
                                .font(.starWarsDisplay(20))
                                .foregroundColor(.displayGreen)
                                .starWarsGlow(color: .displayGreen)
                        }
                        .padding()
                        .starWarsCard()
                        .padding(.horizontal)
                        
                        // Action Buttons
                        VStack(spacing: 15) {
                            Button(action: addToCollection) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("ADD TO COLLECTION")
                                        .font(.starWarsTitle(14))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.starWarsYellow)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .starWarsGlow(color: .starWarsYellow)
                            }
                            
                            Link(destination: URL(string: "https://www.ebay.com/sch/i.html?_nkw=\(card.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")+star+wars+unlimited+card")!) {
                                HStack {
                                    Image(systemName: "cart.circle.fill")
                                    Text("SEARCH ON EBAY")
                                        .font(.starWarsTitle(14))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.lightsaberRed)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
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
        .alert("Card Added", isPresented: $showingSaved) {
            Button("OK") { }
        } message: {
            Text("\(card.name) has been added to your collection!")
        }
    }
    
    func addToCollection() {
        let savedCard = SavedCard(
            name: card.name,
            cardType: card.cardType,
            gameType: card.gameType.rawValue,
            cardDescription: card.description,
            rarity: card.rarity,
            imageUrl: card.imageUrl,
            thumbnailUrl: card.thumbnailUrl,
            tcgplayerPrice: StarWarsCardDatabase.getEstimatedPrice(for: card),
            cardmarketPrice: nil,
            ebayPrice: nil,
            psaRating: nil,
            condition: "Near Mint",
            attributes: [
                "cost": card.cost as Any,
                "power": card.power as Any,
                "health": card.health as Any,
                "traits": card.traits as Any,
                "aspect": card.aspect as Any,
                "arena": card.arena as Any,
                "subtitle": card.subtitle as Any,
                "setCode": card.setCode ?? "" as Any,
                "setNumber": card.setNumber ?? "" as Any
            ]
        )
        
        modelContext.insert(savedCard)
        try? modelContext.save()
        
        showingSaved = true
    }
    
    var cardIcon: Image {
        switch card.cardType {
        case "Leader":
            return Image(systemName: "crown.fill")
        case "Unit":
            return Image(systemName: "person.fill")
        case "Event":
            return Image(systemName: "wand.and.stars")
        case "Upgrade":
            return Image(systemName: "arrow.up.square.fill")
        case "Base":
            return Image(systemName: "building.2.fill")
        default:
            return Image(systemName: "sparkles")
        }
    }
    
    var factionBorderColor: Color {
        if let traits = card.traits {
            if traits.contains("Rebel") || card.aspect == "Heroism" {
                return .lightsaberBlue
            } else if traits.contains("Imperial") || traits.contains("Sith") || card.aspect == "Villainy" {
                return .lightsaberRed
            }
        }
        return .starWarsYellow
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
}

// Extension to make StarWarsUnlimitedCard identifiable
extension StarWarsUnlimitedCard: Identifiable {}