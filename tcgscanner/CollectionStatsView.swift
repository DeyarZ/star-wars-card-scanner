//
//  CollectionStatsView.swift
//  starwarscardscanner
//
//  Collection statistics and analytics
//

import SwiftUI
import SwiftData
import Charts

struct CollectionStatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedCards: [SavedCard]
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Overall Stats Card
                        overallStatsCard
                        
                        // Faction Distribution
                        factionDistributionCard
                        
                        // Rarity Distribution
                        rarityDistributionCard
                        
                        // Game Type Distribution
                        gameTypeDistributionCard
                        
                        // Value Distribution
                        valueDistributionCard
                        
                        // Top Cards by Value
                        topCardsCard
                    }
                    .padding()
                }
            }
            .navigationTitle("COLLECTION STATS")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Overall Stats
    var overallStatsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("OVERALL STATISTICS")
                .font(.starWarsTitle(18))
                .foregroundColor(.white)
                .starWarsGlow()
            
            HStack(spacing: 20) {
                StatBox(
                    title: "TOTAL CARDS",
                    value: "\(savedCards.count)",
                    icon: "rectangle.stack.fill",
                    color: .starWarsYellow
                )
                
                StatBox(
                    title: "TOTAL VALUE",
                    value: String(format: "$%.2f", totalValue),
                    icon: "creditcard.fill",
                    color: .displayGreen
                )
            }
            
            HStack(spacing: 20) {
                StatBox(
                    title: "AVG VALUE",
                    value: String(format: "$%.2f", averageValue),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .hologramBlue
                )
                
                StatBox(
                    title: "UNIQUE CARDS",
                    value: "\(uniqueCardCount)",
                    icon: "sparkles",
                    color: .rebelOrange
                )
            }
        }
        .padding()
        .starWarsCard()
    }
    
    // MARK: - Faction Distribution
    var factionDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("FACTION DISTRIBUTION")
                .font(.starWarsTitle(18))
                .foregroundColor(.white)
                .starWarsGlow()
            
            ForEach(factionStats, id: \.faction) { stat in
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: factionIcon(for: stat.faction))
                            .foregroundColor(factionColor(for: stat.faction))
                        Text(stat.faction.uppercased())
                            .font(.starWarsBody(14))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("\(stat.count)")
                        .font(.starWarsDisplay(16))
                        .foregroundColor(factionColor(for: stat.faction))
                    
                    Text("(\(stat.percentage)%)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                GeometryReader { geometry in
                    Rectangle()
                        .fill(factionColor(for: stat.faction).opacity(0.2))
                        .frame(width: geometry.size.width)
                        .overlay(
                            Rectangle()
                                .fill(factionColor(for: stat.faction))
                                .frame(width: geometry.size.width * (Double(stat.count) / Double(savedCards.count)))
                                .animation(.easeInOut(duration: 0.5), value: stat.count),
                            alignment: .leading
                        )
                }
                .frame(height: 20)
                .cornerRadius(10)
            }
        }
        .padding()
        .starWarsCard()
    }
    
    // MARK: - Rarity Distribution
    var rarityDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("RARITY DISTRIBUTION")
                .font(.starWarsTitle(18))
                .foregroundColor(.white)
                .starWarsGlow()
            
            ForEach(rarityStats, id: \.rarity) { stat in
                HStack {
                    RarityBadge(rarity: stat.rarity)
                    
                    Spacer()
                    
                    Text("\(stat.count)")
                        .font(.starWarsDisplay(16))
                        .foregroundColor(.white)
                    
                    Text("(\(stat.percentage)%)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .starWarsCard()
    }
    
    // MARK: - Game Type Distribution
    var gameTypeDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("GAME TYPE DISTRIBUTION")
                .font(.starWarsTitle(18))
                .foregroundColor(.white)
                .starWarsGlow()
            
            ForEach(gameTypeStats, id: \.gameType) { stat in
                HStack {
                    Text(stat.gameType.uppercased())
                        .font(.starWarsBody(14))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(stat.count)")
                        .font(.starWarsDisplay(16))
                        .foregroundColor(.starWarsYellow)
                    
                    Text("(\(stat.percentage)%)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .starWarsCard()
    }
    
    // MARK: - Value Distribution Chart
    var valueDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("VALUE DISTRIBUTION")
                .font(.starWarsTitle(18))
                .foregroundColor(.white)
                .starWarsGlow()
            
            if !valueRanges.isEmpty {
                Chart(valueRanges, id: \.range) { item in
                    BarMark(
                        x: .value("Range", item.range),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(Color.starWarsYellow.gradient)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(Color.white)
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .padding()
        .starWarsCard()
    }
    
    // MARK: - Top Cards by Value
    var topCardsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("TOP CARDS BY VALUE")
                .font(.starWarsTitle(18))
                .foregroundColor(.white)
                .starWarsGlow()
            
            ForEach(topCards.prefix(5)) { card in
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(card.name.uppercased())
                            .font(.starWarsBody(14))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        HStack(spacing: 10) {
                            if let faction = card.faction {
                                Text(faction)
                                    .font(.caption)
                                    .foregroundColor(factionColor(for: faction))
                            }
                            
                            Text(card.rarity)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    if let price = card.tcgplayerPrice {
                        Text(String(format: "$%.2f", price))
                            .font(.starWarsDisplay(16))
                            .foregroundColor(.displayGreen)
                            .starWarsGlow(color: .displayGreen)
                    }
                }
            }
        }
        .padding()
        .starWarsCard()
    }
    
    // MARK: - Computed Properties
    var totalValue: Double {
        savedCards.compactMap { $0.tcgplayerPrice }.reduce(0, +)
    }
    
    var averageValue: Double {
        guard !savedCards.isEmpty else { return 0 }
        return totalValue / Double(savedCards.count)
    }
    
    var uniqueCardCount: Int {
        Set(savedCards.map { $0.name }).count
    }
    
    var factionStats: [(faction: String, count: Int, percentage: Int)] {
        let factionCounts = Dictionary(grouping: savedCards) { card in
            card.faction ?? "Unknown"
        }
        
        return factionCounts.map { faction, cards in
            let percentage = savedCards.isEmpty ? 0 : Int((Double(cards.count) / Double(savedCards.count)) * 100)
            return (faction: faction, count: cards.count, percentage: percentage)
        }
        .sorted { $0.count > $1.count }
    }
    
    var rarityStats: [(rarity: String, count: Int, percentage: Int)] {
        let rarityCounts = Dictionary(grouping: savedCards) { card in
            card.rarity
        }
        
        return rarityCounts.map { rarity, cards in
            let percentage = savedCards.isEmpty ? 0 : Int((Double(cards.count) / Double(savedCards.count)) * 100)
            return (rarity: rarity, count: cards.count, percentage: percentage)
        }
        .sorted { rarityOrder($0.rarity) < rarityOrder($1.rarity) }
    }
    
    var gameTypeStats: [(gameType: String, count: Int, percentage: Int)] {
        let gameTypeCounts = Dictionary(grouping: savedCards) { card in
            card.starWarsGameType?.rawValue ?? card.gameType
        }
        
        return gameTypeCounts.map { gameType, cards in
            let percentage = savedCards.isEmpty ? 0 : Int((Double(cards.count) / Double(savedCards.count)) * 100)
            return (gameType: gameType, count: cards.count, percentage: percentage)
        }
        .sorted { $0.count > $1.count }
    }
    
    var valueRanges: [(range: String, count: Int)] {
        let ranges = [
            (range: "$0-10", min: 0.0, max: 10.0),
            (range: "$10-25", min: 10.0, max: 25.0),
            (range: "$25-50", min: 25.0, max: 50.0),
            (range: "$50-100", min: 50.0, max: 100.0),
            (range: "$100+", min: 100.0, max: Double.infinity)
        ]
        
        return ranges.compactMap { range in
            let count = savedCards.filter { card in
                let value = card.tcgplayerPrice ?? 0
                return value >= range.min && value < range.max
            }.count
            
            return count > 0 ? (range: range.range, count: count) : nil
        }
    }
    
    var topCards: [SavedCard] {
        savedCards
            .filter { $0.tcgplayerPrice != nil }
            .sorted { ($0.tcgplayerPrice ?? 0) > ($1.tcgplayerPrice ?? 0) }
    }
    
    // MARK: - Helper Functions
    func rarityOrder(_ rarity: String) -> Int {
        switch rarity.lowercased() {
        case "legendary", "hyperspace": return 0
        case "rare": return 1
        case "uncommon": return 2
        case "common": return 3
        default: return 4
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

// MARK: - Stat Box Component
struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.starWarsTitle(20))
                .foregroundColor(color)
                .starWarsGlow(color: color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(10)
    }
}