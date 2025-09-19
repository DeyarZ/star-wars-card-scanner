//
//  PremiumManager.swift
//  yugiohcardscanner
//

import SwiftUI
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremium = false
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()
    @AppStorage("dailyScanCount") private var dailyScanCount = 0
    @AppStorage("lastScanDate") private var lastScanDateString = ""
    
    private let productIds = [
        "com.manuelworlitzer.yugiohcardscanner.premium.weekly",
        "com.manuelworlitzer.yugiohcardscanner.premium.yearly"
    ]
    
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in StoreKit.Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIds)
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedProducts: [Product] = []
        
        for await result in StoreKit.Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if let product = products.first(where: { $0.id == transaction.productID }) {
                    purchasedProducts.append(product)
                }
            } catch {
                print("Failed to verify transaction")
            }
        }
        
        self.purchasedProductIDs = Set(purchasedProducts.map { $0.id })
        self.isPremium = !purchasedProductIDs.isEmpty
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateCustomerProductStatus()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
    
    // Scan limiting logic
    func canScanToday() -> Bool {
        if isPremium {
            return true
        }
        
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        
        if lastScanDateString != today {
            // New day, reset count
            dailyScanCount = 0
            lastScanDateString = today
        }
        
        return dailyScanCount < 1
    }
    
    func recordScan() {
        if !isPremium {
            let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
            
            if lastScanDateString != today {
                dailyScanCount = 1
                lastScanDateString = today
            } else {
                dailyScanCount += 1
            }
        }
    }
    
    func getRemainingScansToday() -> Int {
        if isPremium {
            return -1 // Unlimited
        }
        
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        
        if lastScanDateString != today {
            return 1
        }
        
        return max(0, 1 - dailyScanCount)
    }
}

enum StoreError: Error {
    case failedVerification
}