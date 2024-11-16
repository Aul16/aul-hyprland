FONT_DIR="$HOME/.local/share/fonts"
FONT_ZIP="$FONT_DIR/Meslo.zip"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"

# Check if Meslo Nerd-font is already installed
if fc-list | grep -qi "Meslo"; then
    echo "Meslo Nerd-fonts are already installed."
    exit 0
fi

echo "Installing Meslo Nerd-fonts..."

# Create the fonts directory if it doesn't exist
mkdir -p "$FONT_DIR"

# Download the font zip file if it doesn't already exist
if [ ! -f "$FONT_ZIP" ]; then
    wget -O "$FONT_ZIP" "$FONT_URL" || {
        echo "Failed to download Meslo Nerd-fonts from $FONT_URL"
        exit 1
    }
else
    echo "Meslo.zip already exists in $FONT_DIR, skipping download."
fi

if [ ! -d "$FONT_DIR/Meslo" ]; then
    unzip -o "$FONT_ZIP" -d "$FONT_DIR" || {
        echo "Failed to unzip $FONT_ZIP"
        exit 1
    }
else
    echo "Meslo font files already unzipped in $FONT_DIR, skipping unzip."
fi
rm "$FONT_ZIP"
fc-cache -fv # Rebuild the font cache
echo "Meslo Nerd-fonts installed successfully"
