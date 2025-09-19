# Yu-Gi-Oh Card Scanner

An iOS app that uses AI to scan, identify, and price Yu-Gi-Oh trading cards.

## Features

- **AI-Powered Card Recognition**: Uses GPT-4 Vision to identify cards from camera photos
- **Real-time Pricing**: Get current market prices from TCGPlayer, Cardmarket, and eBay
- **PSA Grading Estimation**: AI estimates the condition and PSA grade of your cards
- **Collection Management**: Save and track your card collection
- **Search Database**: Search the complete Yu-Gi-Oh card database
- **Premium Features**: 
  - Free users: 1 scan per day
  - Premium users: Unlimited scans
  - Weekly ($6.99) or Yearly ($99.99) subscriptions

## Setup

### 1. OpenAI API Key

You need an OpenAI API key to use the card scanning feature.

1. Get your API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Add it to your app in one of two ways:

#### Option A: Info.plist (Recommended for development)
Add this to your `Info.plist`:
```xml
<key>OPENAI_API_KEY</key>
<string>your-api-key-here</string>
```

#### Option B: Environment Variable
Set the environment variable `OPENAI_API_KEY` in your scheme settings.

### 2. In-App Purchases

The app uses StoreKit 2 for premium subscriptions. Make sure to:
1. Configure your products in App Store Connect
2. Use these product IDs:
   - `com.manuelworlitzer.yugiohcardscanner.premium.weekly`
   - `com.manuelworlitzer.yugiohcardscanner.premium.yearly`

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Architecture

- **SwiftUI** for UI
- **SwiftData** for local storage
- **AVFoundation** for camera
- **StoreKit 2** for subscriptions
- **GPT-4 Vision API** for card recognition
- **YGOPRODeck API** for card data

## Security Note

Never commit API keys to source control. The app is configured to read the API key from Info.plist or environment variables.