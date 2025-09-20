//
//  StarWarsTheme.swift
//  starwarscardscanner
//
//  Star Wars visual theme and styling
//

import SwiftUI

// MARK: - Star Wars Colors
extension Color {
    // Primary Colors
    static let starWarsYellow = Color(red: 1.0, green: 0.87, blue: 0)      // Classic opening crawl yellow
    static let lightsaberBlue = Color(red: 0.2, green: 0.6, blue: 1.0)    // Luke's lightsaber
    static let lightsaberRed = Color(red: 1.0, green: 0.2, blue: 0.2)     // Vader's lightsaber
    static let lightsaberGreen = Color(red: 0.2, green: 1.0, blue: 0.4)   // Yoda's lightsaber
    
    // Background Colors
    static let spaceBlack = Color(red: 0.02, green: 0.02, blue: 0.05)     // Deep space
    static let starFieldBlue = Color(red: 0.05, green: 0.08, blue: 0.15)  // Space with stars
    static let imperialGray = Color(red: 0.15, green: 0.15, blue: 0.17)   // Imperial ships
    
    // UI Colors
    static let hologramBlue = Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.8)
    static let rebelOrange = Color(red: 1.0, green: 0.5, blue: 0.1)
    static let displayGreen = Color(red: 0.4, green: 1.0, blue: 0.4)      // Ship displays
    
    // Card Rarity Colors
    static let commonGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let uncommonGreen = Color(red: 0.3, green: 0.8, blue: 0.3)
    static let rareBlue = lightsaberBlue
    static let legendaryPurple = Color(red: 0.7, green: 0.3, blue: 0.9)
    static let hyperspacePurple = Color(red: 0.6, green: 0.2, blue: 0.8)
}

// MARK: - Star Wars Fonts
extension Font {
    static func starWarsTitle(_ size: CGFloat) -> Font {
        // Using system heavy font to approximate Star Wars style
        // In production, you'd use custom Star Wars fonts
        .system(size: size, weight: .heavy, design: .default)
    }
    
    static func starWarsBody(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }
    
    static func starWarsDisplay(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .monospaced)
    }
}

// MARK: - Star Wars View Modifiers
extension View {
    func starWarsCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.imperialGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.hologramBlue, Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: Color.hologramBlue.opacity(0.3), radius: 5, x: 0, y: 2)
    }
    
    func starWarsGlow(color: Color = .starWarsYellow) -> some View {
        self
            .shadow(color: color.opacity(0.8), radius: 4)
            .shadow(color: color.opacity(0.4), radius: 8)
            .shadow(color: color.opacity(0.2), radius: 16)
    }
    
    func hologramEffect() -> some View {
        self.overlay(
            LinearGradient(
                colors: [
                    Color.hologramBlue.opacity(0.3),
                    Color.clear,
                    Color.hologramBlue.opacity(0.1),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.screen)
        )
    }
}

// MARK: - Animated Background
struct StarsBackground: View {
    @State private var animateStars = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base space color
                Color.spaceBlack
                    .ignoresSafeArea()
                
                // Stars layer 1 (distant)
                ForEach(0..<50) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.7)))
                        .frame(width: CGFloat.random(in: 1...2))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(animateStars ? 0.8 : 0.3)
                }
                
                // Stars layer 2 (closer)
                ForEach(0..<20) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.5...1.0)))
                        .frame(width: CGFloat.random(in: 2...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(animateStars ? 1.0 : 0.5)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateStars = true
            }
        }
    }
}

// MARK: - Lightsaber Loading Indicator
struct LightsaberLoadingView: View {
    @State private var isActivated = false
    let color: Color
    
    init(color: Color = .lightsaberBlue) {
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Hilt
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray)
                .frame(width: 20, height: 40)
            
            // Blade
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.8), Color.white],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(width: 6, height: isActivated ? 100 : 0)
                .starWarsGlow(color: color)
                .animation(.easeOut(duration: 0.5), value: isActivated)
        }
        .onAppear {
            isActivated = true
        }
    }
}

// MARK: - Faction Colors
enum StarWarsFaction {
    case lightSide
    case darkSide
    case neutral
    
    var color: Color {
        switch self {
        case .lightSide: return .lightsaberBlue
        case .darkSide: return .lightsaberRed
        case .neutral: return .commonGray
        }
    }
    
    var name: String {
        switch self {
        case .lightSide: return "Light Side"
        case .darkSide: return "Dark Side"
        case .neutral: return "Neutral"
        }
    }
}

// MARK: - Rarity Badge
struct RarityBadge: View {
    let rarity: String
    
    var color: Color {
        switch rarity.lowercased() {
        case "common": return .commonGray
        case "uncommon": return .uncommonGreen
        case "rare": return .rareBlue
        case "legendary": return .legendaryPurple
        case "hyperspace": return .hyperspacePurple
        default: return .starWarsYellow
        }
    }
    
    var body: some View {
        Text(rarity.uppercased())
            .font(.starWarsBody(10))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color)
                    .starWarsGlow(color: color)
            )
    }
}