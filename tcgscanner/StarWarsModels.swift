//
//  StarWarsModels.swift
//  starwarscardscanner
//
//  Created for Star Wars card scanning
//

import Foundation

// MARK: - Star Wars Game Type
enum StarWarsGameType: String, CaseIterable, Codable {
    case unlimited = "Star Wars Unlimited"
    case destiny = "Star Wars Destiny"
}

// MARK: - Star Wars Card Protocol
protocol StarWarsCard {
    var id: String { get }
    var name: String { get }
    var cardType: String { get }
    var description: String { get }
    var rarity: String { get }
    var imageUrl: String { get }
    var thumbnailUrl: String? { get }
    var gameType: StarWarsGameType { get }
}

// MARK: - Star Wars Unlimited Card
struct StarWarsUnlimitedCard: Codable, StarWarsCard {
    let id: String
    let name: String
    let cardType: String // Leader, Base, Unit, Event, Upgrade
    let description: String
    let rarity: String
    let imageUrl: String
    let thumbnailUrl: String?
    let gameType: StarWarsGameType
    
    // Star Wars Unlimited specific attributes
    let cost: Int?
    let power: Int?
    let health: Int?
    let traits: [String]?
    let aspect: String? // Vigilance, Command, Aggression, etc.
    let arena: String? // Space, Ground, or Both
    let subtitle: String?
    let uniqueness: Bool?
    let setCode: String?
    let setNumber: String?
}

// MARK: - Star Wars Destiny Card
struct StarWarsDestinyCard: Codable, StarWarsCard {
    let id: String
    let name: String
    let cardType: String // Character, Upgrade, Support, Event, Plot, Battlefield
    let description: String
    let rarity: String
    let imageUrl: String
    let thumbnailUrl: String?
    let gameType: StarWarsGameType
    
    // Star Wars Destiny specific attributes
    let cost: Int?
    let points: String? // e.g., "9/12" for character points
    let health: Int? // for characters
    let affiliation: String? // Hero, Villain, Neutral
    let color: String? // Blue, Red, Yellow, Gray
    let diceSides: [String]? // for cards with dice
    let subtitle: String?
    let setCode: String?
    let setNumber: String?
}

// MARK: - Price Data
struct CardPriceData: Codable {
    let tcgplayerPrice: Double?
    let tcgplayerMarketPrice: Double?
    let tcgplayerLowPrice: Double?
    let tcgplayerHighPrice: Double?
    let ebayPrice: Double?
    let ebayAveragePrice: Double?
    let currency: String
    let lastUpdated: Date?
}

// MARK: - Card Set Information
struct CardSetInfo: Codable {
    let setName: String
    let setCode: String
    let rarity: String
    let rarityCode: String?
    let price: Double?
    let printDate: String?
}