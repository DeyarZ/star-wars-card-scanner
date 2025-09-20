//
//  CardScannerService.swift
//  starwarscardscanner
//
//  Created by Assistant on 18.09.25.
//

import Foundation
import Vision
import UIKit

class CardScannerService {
    static let shared = CardScannerService()
    
    // Currently selected Star Wars game type
    var currentGameType: StarWarsGameType = .unlimited
    
    // IMPORTANT: Users need to add their OpenAI API key here
    // Get your API key from: https://platform.openai.com/api-keys
    // IMPORTANT: Add your OpenAI API key here
    // Get your API key from: https://platform.openai.com/api-keys
    private let openAIAPIKey: String = "YOUR_OPENAI_API_KEY_HERE"
    
    var lastCardAnalysis: [String: Any]?
    
    private init() {}
    
    // MARK: - Vision AI Card Recognition
    func identifyCard(from image: UIImage, completion: @escaping (String?) -> Void) {
        // First check if API key is set
        guard !openAIAPIKey.isEmpty && openAIAPIKey != "YOUR_OPENAI_API_KEY_HERE" else {
            print("⚠️ OpenAI API key not set. Using alternative recognition method...")
            print("For better accuracy, add your OpenAI API key in CardScannerService.swift")
            print("Get your key from: https://platform.openai.com/api-keys")
            
            // Use alternative recognition method
            AlternativeVisionService.shared.enhancedCardRecognition(from: image, completion: completion)
            return
        }
        
        // Convert image to base64
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        // Create request to OpenAI Vision API
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Build prompt based on current Star Wars game type
        let prompt = buildPrompt(for: currentGameType)
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 150
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Vision API Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            // Debug: Print response
            if let httpResponse = response as? HTTPURLResponse {
                print("API Response Status: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("API Response: \(String(data: data, encoding: .utf8) ?? "No response")")
                }
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    print("GPT Response: \(content)")
                    
                    // Strip markdown code blocks if present
                    var cleanContent = content
                    if cleanContent.contains("```json") {
                        cleanContent = cleanContent
                            .replacingOccurrences(of: "```json\n", with: "")
                            .replacingOccurrences(of: "```json", with: "")
                            .replacingOccurrences(of: "\n```", with: "")
                            .replacingOccurrences(of: "```", with: "")
                    }
                    cleanContent = cleanContent.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Fix common JSON issues
                    if !cleanContent.hasSuffix("}") && !cleanContent.hasSuffix("\"") {
                        cleanContent += "\""  // Add missing quote
                    }
                    if !cleanContent.hasSuffix("}") {
                        cleanContent += "\n}"  // Add missing brace
                    }
                    
                    // Parse the JSON response from GPT
                    if let cardData = cleanContent.data(using: .utf8),
                       let cardInfo = try? JSONSerialization.jsonObject(with: cardData) as? [String: Any],
                       let cardName = cardInfo["name"] as? String {
                        
                        print("Vision AI identified card: \(cardName)")
                        print("Full card info: \(cardInfo)")
                        
                        // Store the full analysis for later use
                        self.lastCardAnalysis = cardInfo
                        
                        completion(cardName)
                    } else {
                        print("Failed to parse GPT response as JSON")
                        
                        // Try simple text response as fallback
                        let cleanedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !cleanedContent.isEmpty && cleanedContent != "NOT_FOUND" {
                            print("Using raw response as card name: \(cleanedContent)")
                            completion(cleanedContent)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    print("Failed to parse OpenAI response")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - Build Star Wars game-specific prompt
    private func buildPrompt(for gameType: StarWarsGameType) -> String {
        switch gameType {
        case .unlimited:
            return """
            Analyze this Star Wars Unlimited card and provide ONLY a JSON response with these fields:
            - name: exact card name
            - subtitle: character subtitle if any
            - rarity: Common/Uncommon/Rare/Legendary/etc
            - set: set code (e.g., SOR for Spark of Rebellion)
            - number: card number in set (e.g., 149/252)
            - faction: Light Side/Dark Side/Neutral
            - aspect: Vigilance/Command/Aggression/Cunning/Villainy/Heroism
            - cost: resource cost (TOP RIGHT number on the card)
            - power: power/attack value (RED number, often middle-left with sword icon) - MUST include if visible
            - hp: health/hit points (BLUE number, often middle-right with shield icon) - MUST include if visible
            - traits: array of traits (e.g., ["Jedi", "Force"])
            - arena: Ground/Space (look for icons)
            - type: Leader/Base/Unit/Event/Upgrade
            - condition: Near Mint/Lightly Played/Moderately Played/Heavily Played/Damaged
            - psa_rating: 1-10 based on condition
            - estimated_raw_value: realistic market value in USD
            - centering_notes: brief centering observation
            
            CRITICAL: For Unit cards, you MUST identify:
            - COST in the TOP RIGHT corner (usually white number in black circle)
            - POWER as the RED number (attack value)
            - HP as the BLUE number (health value)
            If these values are visible on the card, include them. Do not return null/N/A if they are clearly visible.
            """
            
        case .destiny:
            return """
            Analyze this Star Wars Destiny card and provide ONLY a JSON response with these fields:
            - name: exact card name
            - subtitle: character subtitle if any
            - rarity: Starter/Common/Uncommon/Rare/Legendary
            - set: set code
            - number: card number
            - faction: Light Side/Dark Side/Neutral (based on affiliation - Hero/Villain/Neutral)
            - affiliation: Hero/Villain/Neutral
            - color: Blue/Red/Yellow/Gray
            - type: Character/Upgrade/Support/Event/Plot/Battlefield
            - points: character point values (if character)
            - health: health value (if character)
            - dice_sides: array of dice sides (if has dice)
            - cost: resource cost
            - condition: Near Mint/Lightly Played/Moderately Played/Heavily Played/Damaged
            - psa_rating: 1-10 based on condition
            - estimated_raw_value: realistic market value in USD
            """
        }
    }
    
    // MARK: - Fetch Card Data from Analysis
    func fetchCardData(cardName: String, completion: @escaping ((any StarWarsCard)?) -> Void) {
        // Clean up card name for searching
        let cleanedName = cardName
            .replacingOccurrences(of: "™", with: "")
            .replacingOccurrences(of: "©", with: "")
            .replacingOccurrences(of: "'", with: "'")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Searching for card: \(cleanedName)")
        
        // For Star Wars cards, create from the AI analysis
        createCardFromAnalysis(name: cleanedName, completion: completion)
    }
    
    // MARK: - Create card from AI analysis
    private func createCardFromAnalysis(name: String, completion: @escaping ((any StarWarsCard)?) -> Void) {
        guard let analysis = lastCardAnalysis else {
            completion(nil)
            return
        }
        
        switch currentGameType {
        case .unlimited:
            let card = StarWarsUnlimitedCard(
                id: UUID().uuidString,
                name: name,
                cardType: analysis["type"] as? String ?? "Unknown",
                description: analysis["text"] as? String ?? "",
                rarity: analysis["rarity"] as? String ?? "Unknown",
                imageUrl: "", // Will be filled later
                thumbnailUrl: nil,
                gameType: .unlimited,
                cost: analysis["cost"] as? Int,
                power: analysis["power"] as? Int,
                health: analysis["hp"] as? Int,
                traits: analysis["traits"] as? [String],
                aspect: analysis["aspect"] as? String,
                arena: analysis["arena"] as? String,
                subtitle: analysis["subtitle"] as? String,
                uniqueness: nil,
                setCode: analysis["set"] as? String,
                setNumber: analysis["number"] as? String
            )
            completion(card)
            
        case .destiny:
            let card = StarWarsDestinyCard(
                id: UUID().uuidString,
                name: name,
                cardType: analysis["type"] as? String ?? "Unknown",
                description: analysis["text"] as? String ?? "",
                rarity: analysis["rarity"] as? String ?? "Unknown",
                imageUrl: "", // Will be filled later
                thumbnailUrl: nil,
                gameType: .destiny,
                cost: analysis["cost"] as? Int,
                points: analysis["points"] as? String,
                health: analysis["health"] as? Int,
                affiliation: analysis["affiliation"] as? String,
                color: analysis["color"] as? String,
                diceSides: analysis["dice_sides"] as? [String],
                subtitle: analysis["subtitle"] as? String,
                setCode: analysis["set"] as? String,
                setNumber: analysis["number"] as? String
            )
            completion(card)
        }
    }
    
    // MARK: - Convert StarWarsCard to SavedCard
    func convertToSavedCard(from card: any StarWarsCard, psaRating: Int? = nil) -> SavedCard {
        // Extract price from analysis if available
        var tcgplayerPrice: Double?
        var estimatedValue: Double?
        
        if let analysis = lastCardAnalysis {
            if let rawValue = analysis["estimated_raw_value"] as? Double {
                estimatedValue = rawValue
                tcgplayerPrice = rawValue
            } else if let rawValueString = analysis["estimated_raw_value"] as? String {
                estimatedValue = Double(rawValueString.replacingOccurrences(of: "$", with: ""))
                tcgplayerPrice = estimatedValue
            }
        }
        
        // Build attributes based on card type
        var attributes: [String: Any] = [:]
        
        // Add faction information from analysis
        if let faction = lastCardAnalysis?["faction"] as? String {
            attributes["faction"] = faction
        }
        
        if let unlimitedCard = card as? StarWarsUnlimitedCard {
            if let cost = unlimitedCard.cost { attributes["cost"] = cost }
            if let power = unlimitedCard.power { attributes["power"] = power }
            if let health = unlimitedCard.health { attributes["health"] = health }
            if let traits = unlimitedCard.traits { attributes["traits"] = traits }
            if let aspect = unlimitedCard.aspect { attributes["aspect"] = aspect }
            if let arena = unlimitedCard.arena { attributes["arena"] = arena }
        } else if let destinyCard = card as? StarWarsDestinyCard {
            if let cost = destinyCard.cost { attributes["cost"] = cost }
            if let points = destinyCard.points { attributes["points"] = points }
            if let health = destinyCard.health { attributes["health"] = health }
            if let affiliation = destinyCard.affiliation { attributes["affiliation"] = affiliation }
            if let color = destinyCard.color { attributes["color"] = color }
            if let diceSides = destinyCard.diceSides { attributes["diceSides"] = diceSides }
        }
        
        return SavedCard(
            name: card.name,
            cardType: card.cardType,
            gameType: card.gameType.rawValue,
            cardDescription: card.description,
            rarity: card.rarity,
            imageUrl: card.imageUrl,
            thumbnailUrl: card.thumbnailUrl,
            tcgplayerPrice: tcgplayerPrice,
            cardmarketPrice: nil,
            ebayPrice: nil,
            psaRating: psaRating ?? (lastCardAnalysis?["psa_rating"] as? Int),
            condition: lastCardAnalysis?["condition"] as? String,
            attributes: attributes
        )
    }
    
    // MARK: - Estimate PSA Grade
    func estimatePSAGrade(from analysis: [String: Any]?) -> Int {
        guard let analysis = analysis else { return 7 }
        
        // If we already have a PSA rating from the analysis, use it
        if let rating = analysis["psa_rating"] as? Int {
            return rating
        }
        
        // Otherwise estimate based on condition
        let condition = (analysis["condition"] as? String ?? "").lowercased()
        
        switch condition {
        case let c where c.contains("mint") && !c.contains("near"):
            return 10
        case let c where c.contains("near mint"):
            return 9
        case let c where c.contains("lightly played"):
            return 7
        case let c where c.contains("moderately played"):
            return 5
        case let c where c.contains("heavily played"):
            return 3
        case let c where c.contains("damaged"):
            return 1
        default:
            return 7
        }
    }
}

// MARK: - Legacy Support Extension (for backward compatibility with ContentView)
extension CardScannerService {
    // Maintain backward compatibility for ContentView
    func convertToSavedCard(from apiData: YGOCardData, psaRating: Int) -> SavedCard {
        // Create a minimal saved card for legacy support
        return SavedCard(
            name: apiData.name,
            cardType: apiData.type,
            gameType: "Legacy",
            cardDescription: apiData.desc,
            rarity: apiData.card_sets?.first?.set_rarity ?? "Unknown",
            imageUrl: apiData.card_images.first?.image_url ?? "",
            thumbnailUrl: apiData.card_images.first?.image_url_small,
            tcgplayerPrice: Double(apiData.card_prices.first?.tcgplayer_price ?? "0"),
            cardmarketPrice: Double(apiData.card_prices.first?.cardmarket_price ?? "0"),
            ebayPrice: Double(apiData.card_prices.first?.ebay_price ?? "0"),
            psaRating: psaRating,
            condition: nil,
            attributes: [
                "atk": apiData.atk as Any,
                "def": apiData.def as Any,
                "level": apiData.level as Any,
                "attribute": apiData.attribute as Any,
                "race": apiData.race
            ]
        )
    }
}

// MARK: - Legacy YGOPRODeck API Models (for backward compatibility)
struct YGOCardResponse: Codable {
    let data: [YGOCardData]
}

struct YGOCardData: Codable {
    let id: Int
    let name: String
    let type: String
    let desc: String
    let atk: Int?
    let def: Int?
    let level: Int?
    let race: String
    let attribute: String?
    let card_sets: [CardSet]?
    let card_images: [CardImage]
    let card_prices: [CardPrice]
}

struct CardSet: Codable {
    let set_name: String
    let set_rarity: String
}

struct CardImage: Codable {
    let id: Int
    let image_url: String
    let image_url_small: String
}

struct CardPrice: Codable {
    let cardmarket_price: String
    let tcgplayer_price: String
    let ebay_price: String
}

// MARK: - Helper Methods
extension CardScannerService {
    func generateEbayLink(for cardName: String) -> String {
        let cleanedName = cardName
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: "'", with: "")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let gamePrefix = currentGameType == .unlimited ? "star+wars+unlimited" : "star+wars+destiny"
        return "https://www.ebay.com/sch/i.html?_nkw=\(gamePrefix)+\(cleanedName)"
    }
}