//
//  VideoPlayerView.swift
//  yugiohcardscanner
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    let videoName: String
    let videoType: String = "mp4"
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoName: videoName, videoType: videoType)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerView = uiView as? PlayerUIView {
            playerView.play()
        }
    }
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerLooper: AVPlayerLooper?
    
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        
        // Try to find the video in the main bundle
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            print("Video file not found: \(videoName).\(videoType)")
            // Set a background color so we know the view is there
            backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.19, alpha: 1.0)
            return
        }
        
        // Create player item and queue player for seamless looping
        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        // Create looper for seamless loop
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        player = queuePlayer
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        layer.addSublayer(playerLayer)
        
        // Mute video
        player?.isMuted = true
        
        // Start playing
        player?.play()
        
        // Ensure video keeps playing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func applicationDidBecomeActive() {
        player?.play()
    }
    
    func play() {
        player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}