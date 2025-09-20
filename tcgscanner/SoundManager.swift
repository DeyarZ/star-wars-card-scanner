//
//  SoundManager.swift
//  starwarscardscanner
//
//  Star Wars themed sound effects manager
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    // Sound effect names
    enum SoundEffect: String {
        case lightsaberOn = "lightsaber_on"
        case lightsaberOff = "lightsaber_off"
        case blasterShot = "blaster_shot"
        case r2d2Beep = "r2d2_beep"
        case forceUse = "force_use"
        case cardScanned = "card_scanned"
        case success = "success"
        case error = "error_sound"
        
        // System sounds as fallback
        var systemSoundID: SystemSoundID {
            switch self {
            case .lightsaberOn, .cardScanned:
                return 1057 // Tink
            case .lightsaberOff:
                return 1050 // SMS Received
            case .blasterShot:
                return 1016 // SMS Sent
            case .r2d2Beep, .success:
                return 1025 // New Mail
            case .forceUse:
                return 1003 // Chime
            case .error:
                return 1053 // SMS Alert
            }
        }
    }
    
    @Published var isSoundEnabled: Bool = true
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playSound(_ sound: SoundEffect) {
        guard isSoundEnabled else { return }
        
        // For MVP, use system sounds
        // In production, you would load actual Star Wars sound files
        AudioServicesPlaySystemSound(sound.systemSoundID)
        
        // Optionally add haptic feedback
        addHapticFeedback(for: sound)
    }
    
    private func addHapticFeedback(for sound: SoundEffect) {
        let generator = UINotificationFeedbackGenerator()
        
        switch sound {
        case .success, .cardScanned:
            generator.notificationOccurred(.success)
        case .error:
            generator.notificationOccurred(.warning)
        default:
            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
            impactGenerator.prepare()
            impactGenerator.impactOccurred()
        }
    }
    
    // MARK: - Convenience Methods
    func playCardScanned() {
        playSound(.cardScanned)
    }
    
    func playSuccess() {
        playSound(.success)
    }
    
    func playError() {
        playSound(.error)
    }
    
    func playLightsaberOn() {
        playSound(.lightsaberOn)
    }
    
    func playLightsaberOff() {
        playSound(.lightsaberOff)
    }
}

