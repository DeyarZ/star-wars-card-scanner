# Push Instructions

The repository cannot be pushed directly because it contains an API key in the git history. Here's how to push the code:

## Option 1: Create a new repository

1. Create a new GitHub repository (or delete and recreate the current one)
2. Copy all the project files (except .git folder) to a new directory
3. Initialize a new git repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit - TCG Scanner App - Star Wars Edition"
   git branch -M main
   git remote add origin https://github.com/DeyarZ/tcg-scanner.git
   git push -u origin main --force
   ```

## Option 2: Use the GitHub web interface

1. Go to https://github.com/DeyarZ/tcg-scanner
2. Click "Add file" > "Upload files"
3. Drag and drop all project files (except .git folder)
4. Commit directly to main branch

## Option 3: Clean the git history

1. Use BFG Repo-Cleaner or git-filter-branch to remove the API key from history
2. Instructions: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

## Important Files to Include

Make sure to include:
- All .swift files in the project (tcgscanner/)
- Assets.xcassets/ (including the app icon)
- Info.plist
- paywallbackgroundvideo.mp4
- app icon.png
- README.md
- The .xcodeproj file

## Note about the API Key

The CardScannerService.swift file has been updated to load the API key from Info.plist or environment variables instead of hardcoding it. Users will need to add their own OpenAI API key.