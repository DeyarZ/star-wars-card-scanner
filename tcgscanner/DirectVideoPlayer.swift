//
//  DirectVideoPlayer.swift
//  tcgscanner
//

import SwiftUI
import AVKit
import AVFoundation

struct DirectVideoPlayer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // Define the exact path to the video
        let videoFileName = "paywallbackgroundvideo"
        let videoFileExtension = "mp4"
        
        // Get the path to the app bundle
        let bundle = Bundle.main
        
        // Try to load from multiple possible locations
        var player: AVPlayer?
        
        // Method 1: Direct bundle resource
        if let videoURL = bundle.url(forResource: videoFileName, withExtension: videoFileExtension) {
            print("✅ Found video at: \(videoURL.path)")
            player = AVPlayer(url: videoURL)
        }
        // Method 2: Try with path
        else if let videoPath = bundle.path(forResource: videoFileName, ofType: videoFileExtension) {
            let videoURL = URL(fileURLWithPath: videoPath)
            print("✅ Found video at path: \(videoPath)")
            player = AVPlayer(url: videoURL)
        }
        // Method 3: Try to find in the app's directory
        else {
            // Get the app directory path
            let appPath = bundle.bundlePath
            let possiblePaths = [
                "\(appPath)/\(videoFileName).\(videoFileExtension)",
                "\(appPath)/yugiohcardscanner/\(videoFileName).\(videoFileExtension)",
            ]
            
            for path in possiblePaths {
                if FileManager.default.fileExists(atPath: path) {
                    let videoURL = URL(fileURLWithPath: path)
                    print("✅ Found video at custom path: \(path)")
                    player = AVPlayer(url: videoURL)
                    break
                }
            }
        }
        
        if player == nil {
            print("❌ FUCKING VIDEO NOT FOUND!")
            print("Bundle path: \(bundle.bundlePath)")
            print("Resource path: \(bundle.resourcePath ?? "nil")")
            
            // List all mp4 files in bundle
            if let resourcePath = bundle.resourcePath {
                do {
                    let allFiles = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    let mp4Files = allFiles.filter { $0.hasSuffix(".mp4") }
                    print("MP4 files in bundle: \(mp4Files.isEmpty ? "NONE FOUND" : mp4Files.joined(separator: ", "))")
                } catch {
                    print("Error listing files: \(error)")
                }
            }
        }
        
        if let player = player {
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = view.bounds
            view.layer.addSublayer(playerLayer)
            
            // Store player layer for updates
            view.layer.setValue(playerLayer, forKey: "playerLayer")
            
            // Mute and loop
            player.isMuted = true
            player.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                player.seek(to: .zero)
                player.play()
            }
            
            // Start playing
            player.play()
            
            // Keep playing when app becomes active
            NotificationCenter.default.addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: .main
            ) { _ in
                player.play()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update player layer frame on view updates
        if let playerLayer = uiView.layer.value(forKey: "playerLayer") as? AVPlayerLayer {
            playerLayer.frame = uiView.bounds
        }
    }
}