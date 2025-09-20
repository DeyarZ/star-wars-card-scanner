//
//  StarWarsCardDatabase.swift
//  starwarscardscanner
//
//  Local database of popular Star Wars cards for MVP search
//

import Foundation

struct StarWarsCardDatabase {
    static let cards: [StarWarsUnlimitedCard] = [
        // Leaders
        StarWarsUnlimitedCard(
            id: "SOR_001",
            name: "Luke Skywalker",
            cardType: "Leader",
            description: "When Played: You may deploy a unit that costs 6 or less from your hand. It gains Ambush for this phase.",
            rarity: "Special Rare",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: nil,
            power: nil,
            health: 30,
            traits: ["Jedi", "Rebel"],
            aspect: "Heroism",
            arena: nil,
            subtitle: "Faithful Friend",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "001/252"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_002",
            name: "Darth Vader",
            cardType: "Leader",
            description: "When Played: Deal 2 damage to a unit.",
            rarity: "Special Rare",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: nil,
            power: nil,
            health: 30,
            traits: ["Sith", "Imperial"],
            aspect: "Villainy",
            arena: nil,
            subtitle: "Dark Lord of the Sith",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "002/252"
        ),
        
        // Units
        StarWarsUnlimitedCard(
            id: "SOR_149",
            name: "Mace Windu",
            cardType: "Unit",
            description: "When Played: You may deal damage to a unit equal to the number of cards in your hand.",
            rarity: "Legendary",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 7,
            power: 5,
            health: 7,
            traits: ["Force", "Jedi", "Republic"],
            aspect: "Vigilance",
            arena: "Ground",
            subtitle: "Party Crasher",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "149/252"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_210",
            name: "Emperor Palpatine",
            cardType: "Unit",
            description: "When Played: Deal 3 damage divided as you choose among enemy units.",
            rarity: "Legendary",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 8,
            power: 6,
            health: 8,
            traits: ["Force", "Sith", "Imperial"],
            aspect: "Villainy",
            arena: "Ground",
            subtitle: "Galactic Ruler",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "210/252"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_083",
            name: "Sabine Wren",
            cardType: "Unit",
            description: "Ambush. When Played: Deal 2 damage to a unit.",
            rarity: "Rare",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 4,
            power: 3,
            health: 4,
            traits: ["Mandalorian", "Rebel", "Spectre"],
            aspect: "Aggression",
            arena: "Ground",
            subtitle: "Explosives Artist",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "083/252"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_225",
            name: "Boba Fett",
            cardType: "Unit",
            description: "When Played: You may exhaust an enemy unit.",
            rarity: "Rare",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 5,
            power: 5,
            health: 4,
            traits: ["Bounty Hunter", "Underworld"],
            aspect: "Cunning",
            arena: "Ground",
            subtitle: "Collecting the Bounty",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "225/252"
        ),
        StarWarsUnlimitedCard(
            id: "SHD_089",
            name: "Ahsoka Tano",
            cardType: "Unit",
            description: "Shielded. When Played: Ready a resource.",
            rarity: "Legendary",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 6,
            power: 4,
            health: 6,
            traits: ["Force", "Rebel"],
            aspect: "Heroism",
            arena: "Ground",
            subtitle: "Peerless Warrior",
            uniqueness: true,
            setCode: "SHD",
            setNumber: "089/262"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_140",
            name: "Millennium Falcon",
            cardType: "Unit",
            description: "When Played: Return an enemy unit to its owner's hand.",
            rarity: "Legendary",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 7,
            power: 7,
            health: 7,
            traits: ["Vehicle", "Rebel"],
            aspect: "Heroism",
            arena: "Space",
            subtitle: "Piece of Junk",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "140/252"
        ),
        
        // Events
        StarWarsUnlimitedCard(
            id: "SOR_092",
            name: "Force Throw",
            cardType: "Event",
            description: "Deal 4 damage to a unit. If you control a Force unit, deal 6 damage instead.",
            rarity: "Common",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 3,
            power: nil,
            health: nil,
            traits: ["Force"],
            aspect: "Villainy",
            arena: nil,
            subtitle: nil,
            uniqueness: false,
            setCode: "SOR",
            setNumber: "092/252"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_215",
            name: "Overwhelming Barrage",
            cardType: "Event",
            description: "Deal 5 damage divided as you choose among any number of units.",
            rarity: "Rare",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 5,
            power: nil,
            health: nil,
            traits: nil,
            aspect: "Aggression",
            arena: nil,
            subtitle: nil,
            uniqueness: false,
            setCode: "SOR",
            setNumber: "215/252"
        ),
        
        // Bases
        StarWarsUnlimitedCard(
            id: "SOR_257",
            name: "Rebel Base",
            cardType: "Base",
            description: "Each friendly Rebel unit gets +1/+0.",
            rarity: "Common",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: nil,
            power: nil,
            health: 30,
            traits: ["Rebel"],
            aspect: nil,
            arena: nil,
            subtitle: "Yavin 4",
            uniqueness: false,
            setCode: "SOR",
            setNumber: "257/252"
        ),
        
        // More popular cards
        StarWarsUnlimitedCard(
            id: "SOR_044",
            name: "Han Solo",
            cardType: "Unit",
            description: "Ambush. When Played: Deal 3 damage to a unit.",
            rarity: "Rare",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 6,
            power: 5,
            health: 5,
            traits: ["Rebel", "Scoundrel"],
            aspect: "Cunning",
            arena: "Ground",
            subtitle: "Worth the Risk",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "044/252"
        ),
        StarWarsUnlimitedCard(
            id: "SOR_235",
            name: "Grand Moff Tarkin",
            cardType: "Unit",
            description: "When Defeated: Deal 3 damage to your base.",
            rarity: "Legendary",
            imageUrl: "",
            thumbnailUrl: nil,
            gameType: .unlimited,
            cost: 5,
            power: 3,
            health: 7,
            traits: ["Imperial", "Official"],
            aspect: "Command",
            arena: "Ground",
            subtitle: "Death Star Overseer",
            uniqueness: true,
            setCode: "SOR",
            setNumber: "235/252"
        )
    ]
    
    static func search(query: String) -> [StarWarsUnlimitedCard] {
        let lowercasedQuery = query.lowercased()
        
        if lowercasedQuery.isEmpty {
            return cards
        }
        
        return cards.filter { card in
            card.name.lowercased().contains(lowercasedQuery) ||
            (card.subtitle?.lowercased().contains(lowercasedQuery) ?? false) ||
            card.cardType.lowercased().contains(lowercasedQuery) ||
            (card.traits?.contains { $0.lowercased().contains(lowercasedQuery) } ?? false) ||
            (card.aspect?.lowercased().contains(lowercasedQuery) ?? false)
        }
    }
    
    // Get estimated price based on rarity
    static func getEstimatedPrice(for card: StarWarsUnlimitedCard) -> Double {
        switch card.rarity.lowercased() {
        case "special rare":
            return Double.random(in: 15...50)
        case "legendary":
            return Double.random(in: 10...35)
        case "rare":
            return Double.random(in: 3...12)
        case "uncommon":
            return Double.random(in: 1...4)
        case "common":
            return Double.random(in: 0.25...1.5)
        default:
            return 2.0
        }
    }
}