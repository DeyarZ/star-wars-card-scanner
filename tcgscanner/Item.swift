//
//  Item.swift
//  tcgscanner
//
//  Created by Deyar Zakir on 18.09.25.
//

import Foundation
import SwiftData

@Model
final class SavedCard {
    var id: UUID
    var name: String
    var cardType: String
    var gameType: String // TCGType as string for SwiftData
    var cardDescription: String
    var rarity: String
    var imageUrl: String
    var thumbnailUrl: String?
    var imageData: Data? // Store actual photo taken by user
    
    // Price data
    var tcgplayerPrice: Double?
    var cardmarketPrice: Double?
    var ebayPrice: Double?
    var estimatedValue: Double?
    
    // Grading info
    var condition: String?
    var psaRating: Int?
    
    // Metadata
    var dateScanned: Date
    var isFavorite: Bool
    
    // Generic attributes storage as JSON string
    var attributesJSON: String?
    
    // Computed property for typed game type
    var starWarsGameType: StarWarsGameType? {
        StarWarsGameType(rawValue: gameType)
    }
    
    // Computed property for attributes dictionary
    var attributes: [String: Any]? {
        get {
            guard let json = attributesJSON,
                  let data = json.data(using: .utf8),
                  let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return nil
            }
            return dict
        }
        set {
            guard let newValue = newValue,
                  let data = try? JSONSerialization.data(withJSONObject: newValue),
                  let string = String(data: data, encoding: .utf8) else {
                attributesJSON = nil
                return
            }
            attributesJSON = string
        }
    }
    
    init(name: String, cardType: String, gameType: String, cardDescription: String, 
         rarity: String, imageUrl: String, thumbnailUrl: String? = nil,
         imageData: Data? = nil, tcgplayerPrice: Double? = nil, cardmarketPrice: Double? = nil, 
         ebayPrice: Double? = nil, psaRating: Int? = nil, condition: String? = nil,
         attributes: [String: Any]? = nil) {
        self.id = UUID()
        self.name = name
        self.cardType = cardType
        self.gameType = gameType
        self.cardDescription = cardDescription
        self.rarity = rarity
        self.imageUrl = imageUrl
        self.thumbnailUrl = thumbnailUrl
        self.imageData = imageData
        self.tcgplayerPrice = tcgplayerPrice
        self.cardmarketPrice = cardmarketPrice
        self.ebayPrice = ebayPrice
        self.estimatedValue = [tcgplayerPrice, cardmarketPrice, ebayPrice].compactMap { $0 }.first
        self.psaRating = psaRating
        self.condition = condition
        self.dateScanned = Date()
        self.isFavorite = false
        self.attributes = attributes
    }
    
    // Convenience initializer from Star Wars card
    convenience init(from card: any StarWarsCard, priceData: CardPriceData? = nil, psaRating: Int? = nil, condition: String? = nil) {
        self.init(
            name: card.name,
            cardType: card.cardType,
            gameType: card.gameType.rawValue,
            cardDescription: card.description,
            rarity: card.rarity,
            imageUrl: card.imageUrl,
            thumbnailUrl: card.thumbnailUrl,
            imageData: nil,
            tcgplayerPrice: priceData?.tcgplayerPrice,
            cardmarketPrice: nil, // Not available for Star Wars cards
            ebayPrice: priceData?.ebayPrice,
            psaRating: psaRating,
            condition: condition,
            attributes: [:] // Build attributes based on card type
        )
    }
    
    // Helper methods for Star Wars specific attributes
    var power: Int? {
        attributes?["power"] as? Int
    }
    
    var health: Int? {
        attributes?["health"] as? Int
    }
    
    var cost: Int? {
        attributes?["cost"] as? Int
    }
    
    var aspect: String? {
        attributes?["aspect"] as? String
    }
    
    var arena: String? {
        attributes?["arena"] as? String
    }
    
    var faction: String? {
        attributes?["faction"] as? String
    }
    
    // Legacy Yu-Gi-Oh attributes for backward compatibility
    var attack: String {
        if let power = attributes?["power"] as? Int {
            return String(power)
        }
        // Legacy support
        if let atk = attributes?["atk"] as? Int {
            return String(atk)
        }
        return "N/A"
    }
    
    var defense: String {
        if let health = attributes?["health"] as? Int {
            return String(health)
        }
        // Legacy support
        if let def = attributes?["def"] as? Int {
            return String(def)
        }
        return "N/A"
    }
    
    var level: Int {
        // For Star Wars cards, level might be represented by cost
        if let cost = attributes?["cost"] as? Int {
            return cost
        }
        return attributes?["level"] as? Int ?? 0
    }
    
    var attribute: String {
        attributes?["attribute"] as? String ?? "Unknown"
    }
    
    var traits: [String]? {
        attributes?["traits"] as? [String]
    }
}