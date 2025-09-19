//
//  Item.swift
//  yugiohcardscanner
//
//  Created by Deyar Zakir on 18.09.25.
//

import Foundation
import SwiftData

@Model
final class SavedCard {
    var id: UUID
    var name: String
    var type: String
    var attack: String
    var defense: String
    var level: Int
    var attribute: String
    var cardDescription: String
    var rarity: String
    var imageUrl: String
    var tcgplayerPrice: Double?
    var cardmarketPrice: Double?
    var ebayPrice: Double?
    var psaRating: Int?
    var dateScanned: Date
    
    init(name: String, type: String, attack: String, defense: String, level: Int, 
         attribute: String, cardDescription: String, rarity: String, imageUrl: String,
         tcgplayerPrice: Double? = nil, cardmarketPrice: Double? = nil, 
         ebayPrice: Double? = nil, psaRating: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.attack = attack
        self.defense = defense
        self.level = level
        self.attribute = attribute
        self.cardDescription = cardDescription
        self.rarity = rarity
        self.imageUrl = imageUrl
        self.tcgplayerPrice = tcgplayerPrice
        self.cardmarketPrice = cardmarketPrice
        self.ebayPrice = ebayPrice
        self.psaRating = psaRating
        self.dateScanned = Date()
    }
}