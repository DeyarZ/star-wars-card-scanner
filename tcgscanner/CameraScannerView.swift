//
//  CameraScannerView.swift
//  tcgscanner
//
//  Created by Assistant on 18.09.25.
//

import SwiftUI
import AVFoundation
import Vision

struct CameraScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var premiumManager: PremiumManager
    @Binding var scannedCard: SavedCard?
    @State private var isProcessing = false
    @State private var showingCardDetail = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            CameraPreview(isProcessing: $isProcessing, onCapture: processImage)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Spacer()
                
                if isProcessing {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Color(red: 1.0, green: 0.8, blue: 0.2))
                        
                        Text("ANALYZING CARD...")
                            .font(.custom("Arial Black", size: 16))
                            .kerning(2)
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                    .padding(40)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(20)
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Scan button
                Button(action: {
                    // Play lightsaber sound
                    SoundManager.shared.playLightsaberOn()
                    // Trigger capture
                    NotificationCenter.default.post(name: .capturePhoto, object: nil)
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .fill(Color(red: 1.0, green: 0.8, blue: 0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "eye.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 50)
                .disabled(isProcessing)
            }
        }
        .sheet(isPresented: $showingCardDetail) {
            if let card = scannedCard {
                CardDetailView(card: card)
            }
        }
    }
    
    func processImage(_ image: UIImage) {
        let capturedImage = image // Keep reference to the original image
        isProcessing = true
        errorMessage = nil
        
        // Use Vision AI to identify the card
        CardScannerService.shared.identifyCard(from: image) { identifiedCardName in
            guard let cardName = identifiedCardName else {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not identify card. Try better lighting or angle."
                    self.isProcessing = false
                }
                return
            }
            
            // Try to fetch card data
            CardScannerService.shared.fetchCardData(cardName: cardName) { cardData in
                DispatchQueue.main.async {
                    if let apiData = cardData {
                        // Get PSA rating from GPT analysis
                        let psaRating = CardScannerService.shared.estimatePSAGrade(from: CardScannerService.shared.lastCardAnalysis)
                        
                        // Convert to SavedCard
                        var savedCard = CardScannerService.shared.convertToSavedCard(from: apiData, psaRating: psaRating)
                        
                        // Add the captured photo to the saved card
                        savedCard.imageData = capturedImage.jpegData(compressionQuality: 0.8)
                        
                        // Save to database
                        self.modelContext.insert(savedCard)
                        try? self.modelContext.save()
                        
                        self.scannedCard = savedCard
                        self.isProcessing = false
                        
                        // Record the scan
                        self.premiumManager.recordScan()
                        
                        // Play success sound
                        SoundManager.shared.playCardScanned()
                        
                        // Don't dismiss - show the detail view instead
                        self.showingCardDetail = true
                    } else {
                        self.errorMessage = "Card not found in database"
                        self.isProcessing = false
                        SoundManager.shared.playError()
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let capturePhoto = Notification.Name("capturePhoto")
}

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var isProcessing: Bool
    let onCapture: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.onCapture = onCapture
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var onCapture: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(capturePhoto),
            name: .capturePhoto,
            object: nil
        )
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }
        
        photoOutput = AVCapturePhotoOutput()
        
        if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        onCapture?(image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
}