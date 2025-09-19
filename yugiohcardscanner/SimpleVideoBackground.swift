//
//  SimpleVideoBackground.swift
//  yugiohcardscanner
//

import SwiftUI
import AVKit

struct SimpleVideoBackground: View {
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            // Fallback color
            Color(red: 0.11, green: 0.11, blue: 0.19)
                .ignoresSafeArea()
            
            if let player = player {
                VideoPlayer(player: player)
                    .disabled(true) // Disable controls
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        player.isMuted = true
                    }
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    private func setupPlayer() {
        // Try different paths
        let videoName = "paywallbackgroundvideo"
        
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            print("✅ Found video in bundle")
            player = AVPlayer(url: url)
            
            // Loop the video
            player?.actionAtItemEnd = .none
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player?.currentItem,
                queue: .main
            ) { _ in
                self.player?.seek(to: .zero)
                self.player?.play()
            }
            
            player?.play()
            player?.isMuted = true
        } else {
            print("❌ Video not found in bundle")
            
            // List all resources
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let resources = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    print("All bundle files:")
                    resources.forEach { print("  - \($0)") }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}