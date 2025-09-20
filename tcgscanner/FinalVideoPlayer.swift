//
//  FinalVideoPlayer.swift
//  tcgscanner
//

import SwiftUI
import AVKit
import AVFoundation

struct FinalVideoPlayer: View {
    @StateObject private var videoManager = VideoManager()
    
    var body: some View {
        ZStack {
            // Fallback gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.19),
                    Color(red: 0.18, green: 0.14, blue: 0.26)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Video player
            if let player = videoManager.player {
                GeometryReader { geometry in
                    AVPlayerControllerRepresentable(player: player)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                }
            }
            
            // Debug overlay - commented out since video is working
            /*
            if videoManager.showDebug {
                VStack {
                    Text("Video Debug Info")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(videoManager.debugMessage)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .padding()
            }
            */
        }
    }
}

class VideoManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var debugMessage = ""
    @Published var showDebug = false
    
    init() {
        setupVideo()
    }
    
    private func setupVideo() {
        // Method 1: Bundle.main.url
        if let url = Bundle.main.url(forResource: "paywallbackgroundvideo", withExtension: "mp4") {
            debugMessage = "✅ Found via Bundle.main.url: \(url.lastPathComponent)"
            createPlayer(with: url)
            return
        }
        
        // Method 2: Bundle.main.path
        if let path = Bundle.main.path(forResource: "paywallbackgroundvideo", ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            debugMessage = "✅ Found via Bundle.main.path: \(path)"
            createPlayer(with: url)
            return
        }
        
        // Method 3: Direct file in bundle
        let bundlePath = Bundle.main.bundlePath
        let videoPath = "\(bundlePath)/paywallbackgroundvideo.mp4"
        if FileManager.default.fileExists(atPath: videoPath) {
            let url = URL(fileURLWithPath: videoPath)
            debugMessage = "✅ Found in bundle root: \(videoPath)"
            createPlayer(with: url)
            return
        }
        
        // Show what's actually in the bundle
        debugMessage = "❌ Video not found. Bundle contents:\n"
        if let resourcePath = Bundle.main.resourcePath {
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                let mp4Files = contents.filter { $0.hasSuffix(".mp4") }
                if mp4Files.isEmpty {
                    debugMessage += "NO MP4 FILES FOUND IN BUNDLE!"
                } else {
                    debugMessage += "MP4 files: \(mp4Files.joined(separator: ", "))"
                }
            } catch {
                debugMessage += "Error reading bundle: \(error)"
            }
        }
        
        showDebug = true
        
        // Try to copy from project directory as last resort
        copyVideoToBundleIfNeeded()
    }
    
    private func copyVideoToBundleIfNeeded() {
        // This won't work in production but might help in development
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsPath.appendingPathComponent("paywallbackgroundvideo.mp4")
        
        // Check if already copied
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            debugMessage += "\n\n✅ Found in Documents"
            createPlayer(with: destinationURL)
        }
    }
    
    private func createPlayer(with url: URL) {
        player = AVPlayer(url: url)
        player?.isMuted = true
        
        // Loop video
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
        
        player?.play()
    }
}

struct AVPlayerControllerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        player.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player?.play()
    }
}