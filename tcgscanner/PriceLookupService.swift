//
//  PriceLookupService.swift
//  starwarscardscanner
//
//  Created for Star Wars card price lookups
//

import Foundation

class PriceLookupService {
    static let shared = PriceLookupService()
    
    private init() {}
    
    // MARK: - Fetch TCGPlayer Prices
    func fetchTCGPlayerPrice(for cardName: String, gameType: StarWarsGameType, completion: @escaping (Double?) -> Void) {
        // Clean card name for search
        let cleanedName = cardName
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: ":", with: "")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let gameQuery = gameType == .unlimited ? "Star+Wars+Unlimited" : "Star+Wars+Destiny"
        
        // TCGPlayer doesn't have a public API, so we'd need to either:
        // 1. Partner with them for API access
        // 2. Use the price from GPT's market knowledge
        // For now, we'll use GPT's estimated value
        
        // In a real implementation, this would make an API call
        // For MVP, return nil to use GPT's estimate
        completion(nil)
    }
    
    // MARK: - Generate Direct TCGPlayer Link
    func generateTCGPlayerLink(for cardName: String, gameType: StarWarsGameType) -> String {
        let cleanedName = cardName
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: "'", with: "")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let gamePrefix = gameType == .unlimited ? "star-wars-unlimited" : "star-wars-destiny"
        
        return "https://www.tcgplayer.com/search/\(gamePrefix)/product?productLineName=\(gamePrefix)&q=\(cleanedName)"
    }
    
    // MARK: - Update Card Prices
    func updatePricesForCard(_ card: SavedCard, completion: @escaping (Bool) -> Void) {
        guard let gameType = card.starWarsGameType else {
            completion(false)
            return
        }
        
        // For now, we rely on GPT's price estimate
        // In a full implementation, this would aggregate prices from multiple sources
        
        // The price is already set from GPT's analysis during scanning
        completion(true)
    }
}