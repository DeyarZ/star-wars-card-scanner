//
//  AnimatedPaywallBackground.swift
//  yugiohcardscanner
//

import SwiftUI

struct AnimatedPaywallBackground: View {
    @State private var animationAmount = 0.0
    @State private var cardRotation = 0.0
    @State private var glowAmount = 0.5
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.08),
                    Color(red: 0.12, green: 0.08, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated card shapes
            ForEach(0..<6) { index in
                YugiohCardShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.6, blue: 0.2).opacity(0.1),
                                Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 200)
                    .rotationEffect(.degrees(Double(index) * 60 + animationAmount))
                    .rotation3DEffect(
                        .degrees(cardRotation),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 1
                    )
                    .offset(
                        x: CGFloat(index % 2 == 0 ? -100 : 100) + sin(animationAmount * .pi / 180) * 20,
                        y: CGFloat(index * 80 - 200) + cos(animationAmount * .pi / 180) * 10
                    )
                    .blur(radius: 2)
                    .opacity(0.3)
            }
            
            // Floating particles
            ForEach(0..<20) { index in
                Circle()
                    .fill(Color(red: 1.0, green: 0.8, blue: 0.2))
                    .frame(width: CGFloat.random(in: 2...6))
                    .opacity(glowAmount)
                    .blur(radius: 1)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .offset(y: -animationAmount.truncatingRemainder(dividingBy: 800) + 400)
            }
            
            // Egyptian hieroglyph-style patterns
            ForEach(0..<3) { row in
                HStack(spacing: 50) {
                    ForEach(0..<4) { col in
                        EgyptianSymbol()
                            .stroke(
                                Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.1),
                                lineWidth: 1
                            )
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(animationAmount * 0.5))
                    }
                }
                .offset(y: CGFloat(row * 250 - 300))
                .opacity(0.3)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                animationAmount = 360
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                cardRotation = 15
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowAmount = 1.0
            }
        }
    }
}

struct YugiohCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 8
        
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                   radius: cornerRadius,
                   startAngle: .degrees(-90),
                   endAngle: .degrees(0),
                   clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius,
                   startAngle: .degrees(0),
                   endAngle: .degrees(90),
                   clockwise: false)
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius,
                   startAngle: .degrees(90),
                   endAngle: .degrees(180),
                   clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                   radius: cornerRadius,
                   startAngle: .degrees(180),
                   endAngle: .degrees(270),
                   clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

struct EgyptianSymbol: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Eye of Horus simplified
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                         control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                         control: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY),
                         control: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                         control: CGPoint(x: rect.minX, y: rect.minY))
        
        // Inner circle
        path.move(to: CGPoint(x: rect.midX + rect.width * 0.2, y: rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                   radius: rect.width * 0.2,
                   startAngle: .degrees(0),
                   endAngle: .degrees(360),
                   clockwise: false)
        
        return path
    }
}