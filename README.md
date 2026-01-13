# Star Wars Card Scanner

An iOS app that uses AI to scan, identify, and price Star Wars trading cards.

## Features

- **AI-Powered Card Recognition**: Uses GPT-4 Vision to identify cards from camera photos
- **Star Wars Cards**: Full support for Star Wars Unlimited and Star Wars Destiny
- **Real-time Pricing**: Get current market prices from TCGPlayer and eBay
- **PSA Grading Estimation**: AI estimates the condition and PSA grade of your cards
- **Collection Management**: Save and track your card collection with total value
- **Search Database**: Search and browse card databases
- **Premium Features**: 
  - Free users: 1 scan per day
  - Premium users: Unlimited scans
  - Weekly ($6.99) or Yearly ($99.99) subscriptions

## Supported Trading Card Games

### Primary Support
- **Star Wars Unlimited** - Full support with detailed card attributes
- **Star Wars Destiny** - Full support with dice information


## Setup

### 1. OpenAI API Key

You need an OpenAI API key to use the card scanning feature.

1. Get your API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Add it to your app in one of two ways:

#### Option A: Info.plist (Recommended for development)
1. Copy `tcgscanner/Info.plist.template` to `tcgscanner/Info.plist`
2. Add your API key to `Info.plist`:
```xml
<key>OPENAI_API_KEY</key>
<string>your-api-key-here</string>
```
**Note:** Info.plist is in .gitignore for security

#### Option B: Environment Variable
Set the environment variable `OPENAI_API_KEY` in your scheme settings.

### 2. In-App Purchases

The app uses StoreKit 2 for premium subscriptions. Make sure to:
1. Configure your products in App Store Connect
2. Use these product IDs:
   - `com.manuelworlitzer.starwarscardscanner.premium.weekly`
   - `com.manuelworlitzer.starwarscardscanner.premium.yearly`

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
- **Generic TCG Model System** for multi-game support

## Project Structure

```
starwarscardscanner/
├── StarWarsModels.swift    # Star Wars card data models
├── CardScannerService.swift # AI card recognition service
├── ContentView.swift       # Main tab view
├── CameraScannerView.swift # Camera capture interface
├── CardDetailView.swift    # Card detail display
├── Item.swift             # SavedCard SwiftData model
└── ...
```

## Star Wars Card Attributes

### Star Wars Unlimited
- **Cost**: Resource cost to play
- **Power**: Attack strength
- **Health**: Hit points
- **Aspect**: Vigilance, Command, Aggression, etc.
- **Arena**: Ground, Space, or Both
- **Traits**: Character traits (Jedi, Force, etc.)

### Star Wars Destiny
- **Affiliation**: Hero, Villain, or Neutral
- **Color**: Blue, Red, Yellow, or Gray
- **Points**: Character point values
- **Dice Sides**: For cards with dice

## Security Note

Never commit API keys to source control. The app is configured to read the API key from Info.plist or environment variables.

## Future Enhancements

- Web scraping for Star Wars card databases
- Direct API integration when available
- Support for more TCGs
- Trading and marketplace features
- Deck building tools

