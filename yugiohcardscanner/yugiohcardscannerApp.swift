//
//  yugiohcardscannerApp.swift
//  yugiohcardscanner
//
//  Created by Deyar Zakir on 18.09.25.
//

import SwiftUI
import SwiftData

@main
struct yugiohcardscannerApp: App {
    @StateObject private var premiumManager = PremiumManager.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedCard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(premiumManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
