//
//  CardDetailView.swift
//  yugiohcardscanner
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
                Color(red: 0.05, green: 0.05, blue: 0.05)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Card Image
                        if let image = loadedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 400)
                                .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.5), radius: 10)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .frame(height: 400)
                                .overlay(
                                    ProgressView()
                                        .tint(Color(red: 1.0, green: 0.8, blue: 0.2))
                                )
                        }
                        
                        // Card Info
                        VStack(alignment: .leading, spacing: 15) {
                            Text(card.name.uppercased())
                                .font(.custom("Arial Black", size: 24))
                                .kerning(1)
                                .foregroundColor(.white)
                            
                            HStack {
                                Label("LV.\(card.level)", systemImage: "star.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                                
                                Spacer()
                                
                                Text(card.attribute)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                            .font(.custom("Arial Black", size: 14))
                            
                            // PSA Rating
                            if let psaRating = card.psaRating {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("PSA RATING")
                                            .font(.custom("Arial Black", size: 16))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Text("\(psaRating)")
                                            .font(.custom("Arial Black", size: 24))
                                            .foregroundColor(psaColor(for: psaRating))
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
                                                        .font(.custom("Arial Black", size: 12))
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
                                                        .font(.custom("Arial Black", size: 12))
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
                                                        .font(.custom("Arial Black", size: 12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        .padding(.top, 5)
                                        
                                        Divider()
                                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        
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
                                .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                                .cornerRadius(10)
                            }
                            
                            // Stats
                            if card.type.contains("Monster") {
                                HStack {
                                    VStack {
                                        Text("ATTACK")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(card.attack)
                                            .font(.custom("Arial Black", size: 20))
                                            .foregroundColor(.red)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("DEFENSE")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(card.defense)
                                            .font(.custom("Arial Black", size: 20))
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                                .cornerRadius(10)
                            }
                            
                            // Description
                            Text(card.cardDescription)
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                .padding()
                                .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                                .cornerRadius(10)
                            
                            // Prices
                            VStack(alignment: .leading, spacing: 10) {
                                Text("MARKET PRICES")
                                    .font(.custom("Arial Black", size: 18))
                                    .foregroundColor(.white)
                                
                                if let tcgPrice = card.tcgplayerPrice {
                                    HStack {
                                        Text("TCGPlayer")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "$%.2f", tcgPrice))
                                            .font(.custom("Arial Black", size: 16))
                                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                                    }
                                }
                                
                                if let marketPrice = card.cardmarketPrice {
                                    HStack {
                                        Text("Cardmarket")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "€%.2f", marketPrice))
                                            .font(.custom("Arial Black", size: 16))
                                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                                    }
                                }
                                
                                if let ebayPrice = card.ebayPrice {
                                    HStack {
                                        Text("eBay Average")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(String(format: "$%.2f", ebayPrice))
                                            .font(.custom("Arial Black", size: 16))
                                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
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
                                            .font(.custom("Arial Black", size: 16))
                                            .foregroundColor(Color(red: 0.5, green: 1.0, blue: 0.5))
                                    }
                                }
                            }
                            .padding()
                            .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                            .cornerRadius(10)
                            
                            // eBay Button
                            Link(destination: URL(string: CardScannerService.shared.generateEbayLink(cardName: card.name))!) {
                                HStack {
                                    Image(systemName: "cart.fill")
                                    Text("SEARCH ON EBAY")
                                        .font(.custom("Arial Black", size: 16))
                                        .kerning(1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 0.8, blue: 0.2))
                                .foregroundColor(.black)
                                .cornerRadius(10)
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
                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                }
            }
        }
        .onAppear {
            loadCardImage()
        }
    }
    
    func loadCardImage() {
        guard let url = URL(string: card.imageUrl) else { return }
        
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
        case 10: return .green
        case 9: return Color(red: 0.7, green: 1.0, blue: 0.0)
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.2)
        case 7: return .orange
        default: return .red
        }
    }
}