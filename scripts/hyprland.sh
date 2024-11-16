#!/bin/bash
# https://github.com/Aul16

# Set the name of the log file to include the current date and time
LOG="logs/install-$(date +%d-%H%M%S)_hyprland.log"

# Install additional packages
git_pkgs="grimblast-git hyprpicker-git"
hypr_pkgs="hyprland aquamarine rofi-wayland wlogout dunst alacritty hyprlock hyprcursor hyprlang hyprutils hypridle noto-fonts noto-fonts-emoji"
app_pkgs="mate-polkit noise-suppression-for-voice thunar tumbler thunar-archive-plugin xdg-user-dirs xdg-desktop-portal-hyprland qt5ct libva qt5-wayland qt6-wayland"
theme_pkgs="nordic-theme papirus-icon-theme starship"

# Remove polkit
if pacman -Qi polkit > /dev/null 2>&1; then
    sudo pacman -R --noconfirm polkit
fi

aur_helper="yay"
if ! $aur_helper -S --noconfirm $git_pkgs $hypr_pkgs $app_pkgs $theme_pkgs 2>&1 | tee -a $LOG; then
    echo -e "\e[1A\e[K${ERROR} - Failed to install additional packages - please check the install.log \n"
    exit 1
fi

xdg-user-dirs-update
echo
echo -e "${GREEN} All necessary packages installed successfully."


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