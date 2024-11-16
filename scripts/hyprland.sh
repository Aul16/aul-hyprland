#!/bin/bash
# https://github.com/Aul16

git_pkgs="grimblast-git hyprpicker-git"
hypr_pkgs="hyprland rofi wlogout dunst alacritty hyprcursor hyprlang noto-fonts noto-fonts-emoji"
app_pkgs="mate-polkit noise-suppression-for-voice thunar tumbler thunar-archive-plugin xdg-user-dirs xdg-desktop-portal-hyprland qt5ct libva qt5-wayland qt6-wayland"
theme_pkgs="nordic-theme papirus-icon-theme starship"

aur_helper="yay"
if ! $aur_helper -S --noconfirm $git_pkgs $hypr_pkgs $app_pkgs $theme_pkgs 2>&1 | tee -a $LOG; then
    print_error " Failed to install additional packages - please check the install.log \n"
    exit 1
fi

xdg-user-dirs-update
echo
print_success " All necessary packages installed successfully."


### Copy Config Files ###
read -n1 -rep "${CAT} Would you like to copy config files? (y,n)" CFG
if [[ $CFG =~ ^[Yy]$ ]]; then
    printf " Copying config files...\n"
    cp -r dotconfig/dunst ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/hypr ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/kitty ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/pipewire ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/rofi ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/wlogout ~/.config/ 2>&1 | tee -a $LOG
    
    # Set some files as exacutable 
    chmod +x ~/.config/hypr/xdg-portal-hyprland
fi

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

# BLUETOOTH
read -n1 -rep "${CAT} OPTIONAL - Would you like to install Bluetooth packages? (y/n)" BLUETOOTH
if [[ $BLUETOOTH =~ ^[Yy]$ ]]; then
    printf " Installing Bluetooth Packages...\n"
 blue_pkgs="bluez bluez-utils blueman"
    if ! yay -S --noconfirm $blue_pkgs 2>&1 | tee -a $LOG; then
       	print_error "Failed to install bluetooth packages - please check the install.log"    
    printf " Activating Bluetooth Services...\n"
    sudo systemctl enable --now bluetooth.service
    sleep 2
    fi
else
    printf "${YELLOW} No bluetooth packages installed..\n"
	fi