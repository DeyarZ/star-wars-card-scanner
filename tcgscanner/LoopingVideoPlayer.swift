//
//  LoopingVideoPlayer.swift
//  tcgscanner
//

import SwiftUI
import AVKit
import AVFoundation

struct LoopingVideoPlayer: View {
    let videoName: String
    
    var body: some View {
        LoopingVideoPlayerRepresentable(videoName: videoName)
            .ignoresSafeArea()
    }
}

struct LoopingVideoPlayerRepresentable: UIViewControllerRepresentable {
    let videoName: String
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        
        // Try multiple locations for the video
        var videoURL: URL?
        
        // First try Bundle.main
        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            videoURL = URL(fileURLWithPath: path)
        }
        // Try with explicit bundle
        else if let bundleURL = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            videoURL = bundleURL
        }
        // Try Documents directory
        else if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let possibleURL = documentsPath.appendingPathComponent("\(videoName).mp4")
            if FileManager.default.fileExists(atPath: possibleURL.path) {
                videoURL = possibleURL
            }
        }
        
        if let url = videoURL {
            let player = AVPlayer(url: url)
            controller.player = player
            
            // Mute the video
            player.isMuted = true
            
            // Loop the video
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
            
            print("✅ Video loaded from: \(url.path)")
        } else {
            print("⚠️ Video file not found: \(videoName).mp4")
            print("Bundle path: \(Bundle.main.bundlePath)")
            print("Resource path: \(Bundle.main.resourcePath ?? "nil")")
            
            // List all files in bundle
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let resources = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    print("\nAll files in bundle:")
                    resources.forEach { print("  - \($0)") }
                    
                    let mp4Files = resources.filter { $0.hasSuffix(".mp4") }
                    print("\nMP4 files found: \(mp4Files.isEmpty ? "NONE" : mp4Files.joined(separator: ", "))")
                } catch {
                    print("Error listing resources: \(error)")
                }
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Ensure video is playing when view updates
        uiViewController.player?.play()
    }
}