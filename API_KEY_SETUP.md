# OpenAI API Key Setup

## Required for Card Recognition

This app uses OpenAI's GPT-4 Vision API to identify and analyze Star Wars cards. You need to add your own API key to make the scanning functionality work.

## Setup Instructions

1. **Get an API Key**
   - Visit: https://platform.openai.com/api-keys
   - Create an account or sign in
   - Generate a new API key

2. **Add Your API Key (Secure Method)**
   - Copy `tcgscanner/Info.plist.template` to `tcgscanner/Info.plist`
   - Open `tcgscanner/Info.plist`
   - Find: `<string>YOUR_OPENAI_API_KEY_HERE</string>`
   - Replace `YOUR_OPENAI_API_KEY_HERE` with your actual API key

3. **Example**
   ```xml
   <key>OPENAI_API_KEY</key>
   <string>sk-proj-YOUR_ACTUAL_KEY_HERE</string>
   ```

4. **Important: Info.plist is now in .gitignore**
   - Your API key will NOT be committed to version control
   - Always use the template file for sharing code

## Security Note

⚠️ **Never commit your actual API key to version control!**

The placeholder `"YOUR_OPENAI_API_KEY_HERE"` is intentionally invalid to prevent accidental exposure of real API keys.

## Alternative Recognition

If you don't want to use OpenAI's API, the app will fall back to a basic alternative recognition method, though it will be less accurate.