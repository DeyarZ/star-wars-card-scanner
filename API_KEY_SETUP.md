# OpenAI API Key Setup

## Required for Card Recognition

This app uses OpenAI's GPT-4 Vision API to identify and analyze Star Wars cards. You need to add your own API key to make the scanning functionality work.

## Setup Instructions

1. **Get an API Key**
   - Visit: https://platform.openai.com/api-keys
   - Create an account or sign in
   - Generate a new API key

2. **Add Your API Key**
   - Open `tcgscanner/CardScannerService.swift`
   - Find line 22: `private let openAIAPIKey: String = "YOUR_OPENAI_API_KEY_HERE"`
   - Replace `"YOUR_OPENAI_API_KEY_HERE"` with your actual API key

3. **Example**
   ```swift
   private let openAIAPIKey: String = "sk-proj-YOUR_ACTUAL_KEY_HERE"
   ```

## Security Note

⚠️ **Never commit your actual API key to version control!**

The placeholder `"YOUR_OPENAI_API_KEY_HERE"` is intentionally invalid to prevent accidental exposure of real API keys.

## Alternative Recognition

If you don't want to use OpenAI's API, the app will fall back to a basic alternative recognition method, though it will be less accurate.