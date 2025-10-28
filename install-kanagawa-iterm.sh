#!/bin/bash

# Kanagawa iTerm2 Theme Installer
# This script installs the Kanagawa theme for iTerm2 to match your Neovim theme

echo "🎨 Installing Kanagawa theme for iTerm2..."

# Color scheme file location
THEME_FILE="$HOME/.config/nvim/Kanagawa.itermcolors"

# Check if the theme file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "❌ Error: Kanagawa.itermcolors not found at $THEME_FILE"
    exit 1
fi

echo "✅ Found Kanagawa theme file"

# Check if iTerm2 is installed
if [ ! -d "/Applications/iTerm.app" ]; then
    echo "❌ Error: iTerm2 not found in /Applications/"
    echo "   Please install iTerm2 first: https://iterm2.com/"
    exit 1
fi

echo "✅ iTerm2 found"

# Open the color scheme file with iTerm2
echo "📥 Opening Kanagawa color scheme..."
open "$THEME_FILE"

echo ""
echo "🎯 Next steps to complete installation:"
echo ""
echo "1. iTerm2 should have opened with the import dialog"
echo "2. Click 'Import' to add the Kanagawa theme"
echo "3. Go to iTerm2 → Preferences → Profiles → Colors"
echo "4. Select 'Kanagawa' from the Color Presets dropdown"
echo "5. Set this profile as default (optional):"
echo "   - Go to iTerm2 → Preferences → Profiles → General"
echo "   - Click 'Other Actions...' → 'Set as Default'"
echo ""
echo "🎨 Your terminal will now match your Neovim theme perfectly!"
echo ""
echo "💡 Pro tip: You can also:"
echo "   - Adjust opacity: Profiles → Window → Transparency"
echo "   - Enable blur: Profiles → Window → Blur"
echo "   - Change font: Profiles → Text → Font"
echo ""
echo "🚀 Recommended font: 'JetBrainsMono Nerd Font' or 'FiraCode Nerd Font'"