#!/bin/bash

# TCG Scanner Migration Script
# This script helps complete the migration from Yu-Gi-Oh to Star Wars TCG Scanner

echo "==================================="
echo "TCG Scanner Migration Helper"
echo "==================================="
echo ""
echo "This script will help you complete the migration from Yu-Gi-Oh Card Scanner to TCG Scanner (Star Wars Edition)"
echo ""
echo "IMPORTANT: Close Xcode before running this script!"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# Create backup
echo "Creating backup..."
cp -r . ../starwarscardscanner_backup_$(date +%Y%m%d_%H%M%S)

echo ""
echo "Step 1: Removing old test directories..."
rm -rf yugiohcardscannerTests
rm -rf yugiohcardscannerUITests
echo "✓ Old test directories removed"

echo ""
echo "Step 2: Removing old files..."
rm -f yugiohcardscanner/yugiohcardscannerApp.swift
rm -f yugiohcardscanner/yugiohcardscanner.entitlements
echo "✓ Old files removed"

echo ""
echo "Step 3: Renaming project file..."
if [ -d "yugiohcardscanner.xcodeproj" ]; then
    mv yugiohcardscanner.xcodeproj tcgscanner.xcodeproj
    echo "✓ Project file renamed"
else
    echo "⚠️  Project file already renamed or not found"
fi

echo ""
echo "Step 4: Renaming main folder..."
if [ -d "yugiohcardscanner" ]; then
    mv yugiohcardscanner tcgscanner
    echo "✓ Main folder renamed"
else
    echo "⚠️  Main folder already renamed or not found"
fi

echo ""
echo "Step 5: Updating project file references..."
if [ -f "tcgscanner.xcodeproj/project.pbxproj" ]; then
    # Update references in project.pbxproj
    sed -i '' 's/yugiohcardscanner/tcgscanner/g' tcgscanner.xcodeproj/project.pbxproj
    echo "✓ Project file references updated"
else
    echo "⚠️  Could not find project.pbxproj"
fi

echo ""
echo "==================================="
echo "Migration Complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "1. Open tcgscanner.xcodeproj in Xcode"
echo "2. Update the scheme name from 'yugiohcardscanner' to 'tcgscanner'"
echo "3. Clean build folder (Shift+Cmd+K)"
echo "4. Build and run the project"
echo ""
echo "The app is now ready as TCG Scanner - Star Wars Edition!"
echo ""
echo "Note: A backup was created in the parent directory with timestamp."