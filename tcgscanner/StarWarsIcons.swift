//
//  StarWarsIcons.swift
//  starwarscardscanner
//
//  Star Wars themed icons and symbols
//

import SwiftUI

// MARK: - Star Wars Icon System
struct StarWarsIcon: View {
    let name: StarWarsIconName
    let size: CGFloat
    
    var body: some View {
        switch name {
        case .rebel:
            RebelIcon()
                .frame(width: size, height: size)
        case .empire:
            EmpireIcon()
                .frame(width: size, height: size)
        case .jedi:
            JediIcon()
                .frame(width: size, height: size)
        case .sith:
            SithIcon()
                .frame(width: size, height: size)
        case .mandalorian:
            MandalorianIcon()
                .frame(width: size, height: size)
        case .credits:
            CreditsIcon()
                .frame(width: size, height: size)
        case .lightsaber:
            LightsaberIcon()
                .frame(width: size, height: size)
        case .starship:
            StarshipIcon()
                .frame(width: size, height: size)
        }
    }
}

enum StarWarsIconName {
    case rebel
    case empire
    case jedi
    case sith
    case mandalorian
    case credits
    case lightsaber
    case starship
}

// MARK: - Rebel Alliance Icon
struct RebelIcon: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                // Simplified rebel symbol
                path.move(to: CGPoint(x: center.x, y: center.y - radius))
                path.addLine(to: CGPoint(x: center.x - radius * 0.3, y: center.y + radius * 0.5))
                path.addLine(to: CGPoint(x: center.x - radius * 0.8, y: center.y + radius * 0.2))
                path.addLine(to: CGPoint(x: center.x - radius * 0.2, y: center.y + radius * 0.2))
                path.addLine(to: CGPoint(x: center.x, y: center.y - radius * 0.3))
                path.addLine(to: CGPoint(x: center.x + radius * 0.2, y: center.y + radius * 0.2))
                path.addLine(to: CGPoint(x: center.x + radius * 0.8, y: center.y + radius * 0.2))
                path.addLine(to: CGPoint(x: center.x + radius * 0.3, y: center.y + radius * 0.5))
                path.closeSubpath()
            }
            .fill(Color.lightsaberRed)
        }
    }
}

// MARK: - Empire Icon
struct EmpireIcon: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                
                Path { path in
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    let radius = min(geometry.size.width, geometry.size.height) / 2 * 0.8
                    
                    // Six spokes
                    for i in 0..<6 {
                        let angle = Double(i) * Double.pi / 3
                        let x = center.x + radius * cos(angle)
                        let y = center.y + radius * sin(angle)
                        
                        path.move(to: center)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.white, lineWidth: 2)
            }
        }
    }
}

// MARK: - Jedi Icon
struct JediIcon: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Jedi symbol (simplified)
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.1))
                path.addQuadCurve(to: CGPoint(x: width * 0.2, y: height * 0.9),
                                  control: CGPoint(x: width * 0.1, y: height * 0.5))
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.1))
                path.addQuadCurve(to: CGPoint(x: width * 0.8, y: height * 0.9),
                                  control: CGPoint(x: width * 0.9, y: height * 0.5))
                path.move(to: CGPoint(x: width * 0.2, y: height * 0.9))
                path.addLine(to: CGPoint(x: width * 0.8, y: height * 0.9))
            }
            .stroke(Color.lightsaberBlue, lineWidth: 2)
        }
    }
}

// MARK: - Sith Icon
struct SithIcon: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Sith symbol (triangle based)
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.1))
                path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.9))
                path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.9))
                path.closeSubpath()
                
                // Inner triangle
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.3))
                path.addLine(to: CGPoint(x: width * 0.3, y: height * 0.7))
                path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.7))
                path.closeSubpath()
            }
            .fill(Color.lightsaberRed)
        }
    }
}

// MARK: - Mandalorian Icon
struct MandalorianIcon: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Mythosaur skull simplified
                path.addEllipse(in: CGRect(x: width * 0.3, y: height * 0.2,
                                           width: width * 0.4, height: height * 0.4))
                
                // Horns
                path.move(to: CGPoint(x: width * 0.2, y: height * 0.3))
                path.addQuadCurve(to: CGPoint(x: width * 0.1, y: height * 0.1),
                                  control: CGPoint(x: width * 0.1, y: height * 0.2))
                
                path.move(to: CGPoint(x: width * 0.8, y: height * 0.3))
                path.addQuadCurve(to: CGPoint(x: width * 0.9, y: height * 0.1),
                                  control: CGPoint(x: width * 0.9, y: height * 0.2))
            }
            .stroke(Color.imperialGray, lineWidth: 2)
        }
    }
}

// MARK: - Credits Icon
struct CreditsIcon: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color.starWarsYellow, lineWidth: 2)
                
                Text("₹")
                    .font(.system(size: geometry.size.width * 0.6, weight: .bold, design: .default))
                    .foregroundColor(.starWarsYellow)
            }
        }
    }
}

// MARK: - Lightsaber Icon
struct LightsaberIcon: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Blade
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.lightsaberBlue, Color.white],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.7)
                    .starWarsGlow(color: .lightsaberBlue)
                
                // Hilt
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray)
                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.3)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: - Starship Icon
struct StarshipIcon: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // X-wing simplified
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.1))
                path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.8))
                path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.9))
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.1))
                path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.8))
                path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.9))
                
                // Body
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.1))
                path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.9))
            }
            .stroke(Color.imperialGray, lineWidth: 2)
        }
    }
}

// MARK: - Icon Helper Extension
extension View {
    func starWarsIcon(_ name: StarWarsIconName, size: CGFloat = 24) -> some View {
        StarWarsIcon(name: name, size: size)
    }
}