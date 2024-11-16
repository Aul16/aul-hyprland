#!/bin/bash
# https://github.com/Aul16


# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_yay.log"

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Check for AUR helper and install if not found
ISAUR=$(command -v yay)
if [ -n "$ISAUR" ]; then
  printf "\n%s - AUR helper already installed, moving on.\n" "${OK}"
else
  printf "\n%s - AUR helper was NOT located\n" "$WARN"
  printf "\n%s - Installing yay from AUR\n" "${NOTE}"
  git clone https://aur.archlinux.org/yay.git || { printf "%s - Failed to clone yay from AUR\n" "${ERROR}"; exit 1; }
  cd yay || { printf "%s - Failed to enter yay directory\n" "${ERROR}"; exit 1; }
  makepkg -si --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to install yay from AUR\n" "${ERROR}"; exit 1; }

  # moving install logs in to Install-Logs folder
  mv install*.log ../logs/ || true   
  cd ..
fi

clear