//
//  AlternativeVisionService.swift
//  tcgscanner
//
//  Alternative card detection using image hashing and pre-built card database
//

import Foundation
import UIKit
import CoreImage
import Vision

class AlternativeVisionService {
    static let shared = AlternativeVisionService()
    
    private init() {}
    
    // MARK: - Enhanced OCR with specific Star Wars card patterns (legacy Yu-Gi-Oh support)
    func enhancedCardRecognition(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        // Try multiple recognition strategies
        recognizeCardName(from: cgImage) { cardName in
            if let name = cardName {
                completion(name)
            } else {
                // If OCR fails, try pattern matching
                self.recognizeByPatternMatching(image: image, completion: completion)
            }
        }
    }
    
    private func recognizeCardName(from cgImage: CGImage, completion: @escaping (String?) -> Void) {
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            // Look for text in the top portion of the card (where the name usually is)
            let topObservations = observations.filter { $0.boundingBox.origin.y > 0.7 }
            
            // Try to find the card name (usually the largest text at the top)
            var possibleNames: [(text: String, confidence: Float, size: CGFloat)] = []
            
            for observation in topObservations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                
                let text = candidate.string
                let confidence = candidate.confidence
                let height = observation.boundingBox.height
                
                // Filter out common non-name text
                if !self.isLikelyCardName(text) { continue }
                
                possibleNames.append((text: text, confidence: confidence, size: height))
            }
            
            // Sort by size (larger text is more likely the card name)
            possibleNames.sort { $0.size > $1.size }
            
            if let bestMatch = possibleNames.first {
                print("Found potential card name: \(bestMatch.text) (confidence: \(bestMatch.confidence))")
                completion(bestMatch.text)
            } else {
                completion(nil)
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false // Card names might not be real words
        request.regionOfInterest = CGRect(x: 0, y: 0.7, width: 1.0, height: 0.3) // Top 30% of card
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    private func isLikelyCardName(_ text: String) -> Bool {
        // Filter out common card text that isn't the name
        let excludedPhrases = [
            "SPELL CARD", "TRAP CARD", "EFFECT", "FUSION", "SYNCHRO", "XYZ", // Legacy Yu-Gi-Oh terms
            "LINK", "PENDULUM", "1st Edition", "Limited Edition", "©", "™"
        ]
        
        let upperText = text.uppercased()
        for phrase in excludedPhrases {
            if upperText.contains(phrase) {
                return false
            }
        }
        
        // Card names are usually at least 3 characters
        return text.count >= 3
    }
    
    // MARK: - Pattern Matching Approach
    private func recognizeByPatternMatching(image: UIImage, completion: @escaping (String?) -> Void) {
        // Try to match card by its visual features
        detectCardFeatures(from: image) { features in
            if features != nil {
                // Based on detected features, make educated guesses
                self.guessCardByFeatures(features: features!, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
    
    private func detectCardFeatures(from image: UIImage, completion: @escaping (CardFeatures?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        // Detect card color/type
        let cardType = detectCardType(from: ciImage)
        
        // Detect star level (for monster cards) - legacy Yu-Gi-Oh feature
        detectStarLevel(from: image) { level in
            let features = CardFeatures(
                cardType: cardType,
                starLevel: level,
                dominantColor: self.dominantColor(from: ciImage)
            )
            completion(features)
        }
    }
    
    private func detectCardType(from ciImage: CIImage) -> CardType {
        // Analyze card border color
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return .unknown }
        
        // Sample colors from card border
        let borderColors = sampleBorderColors(from: cgImage)
        
        // Determine card type based on border color
        if isYellowish(borderColors) { return .normal }
        else if isOrange(borderColors) { return .effect }
        else if isBlue(borderColors) { return .ritual }
        else if isPurple(borderColors) { return .fusion }
        else if isWhite(borderColors) { return .synchro }
        else if isBlack(borderColors) { return .xyz }
        else if isGreen(borderColors) { return .spell } // Legacy Yu-Gi-Oh
        else if isPink(borderColors) { return .trap } // Legacy Yu-Gi-Oh
        
        return .unknown
    }
    
    private func detectStarLevel(from image: UIImage, completion: @escaping (Int) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(0)
            return
        }
        
        // Use Vision to detect star symbols
        let request = VNDetectRectanglesRequest { request, error in
            // Count detected star-like shapes
            // This is simplified - in reality you'd need more sophisticated star detection
            let starCount = request.results?.count ?? 0
            completion(min(starCount, 12)) // Max 12 stars
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    // Helper functions
    private func sampleBorderColors(from image: CGImage) -> [UIColor] {
        // Sample colors from card border regions
        // Implementation would sample specific pixels
        return []
    }
    
    private func dominantColor(from image: CIImage) -> UIColor {
        // Calculate dominant color
        return UIColor.gray
    }
    
    private func isYellowish(_ colors: [UIColor]) -> Bool { false }
    private func isOrange(_ colors: [UIColor]) -> Bool { false }
    private func isBlue(_ colors: [UIColor]) -> Bool { false }
    private func isPurple(_ colors: [UIColor]) -> Bool { false }
    private func isWhite(_ colors: [UIColor]) -> Bool { false }
    private func isBlack(_ colors: [UIColor]) -> Bool { false }
    private func isGreen(_ colors: [UIColor]) -> Bool { false }
    private func isPink(_ colors: [UIColor]) -> Bool { false }
    
    private func guessCardByFeatures(features: CardFeatures, completion: @escaping (String?) -> Void) {
        // Make educated guesses based on features
        // This would need a local database of card features
        completion(nil)
    }
}

struct CardFeatures {
    let cardType: CardType
    let starLevel: Int
    let dominantColor: UIColor
}

enum CardType {
    case normal, effect, ritual, fusion, synchro, xyz, pendulum, link
    case spell, trap // Legacy Yu-Gi-Oh card types
    case unknown
}