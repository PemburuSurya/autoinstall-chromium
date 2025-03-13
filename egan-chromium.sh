#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m' # Reset color

# Print "CRYPTO CONSOLE" with vibrant colors
echo -e "${CYAN}=============================="
echo -e "       ${GREEN}CRYPTO CONSOLE${CYAN}        "
echo -e "${CYAN}==============================${RESET}"

# Predefined answers
followed="yes"
install_docker="yes"
install_compose="yes"
custom_user="egan"
password="rumiyah123"
IP_PUBLIC=$(curl -s ipinfo.io/ip)

# Skip the follow prompt since the answer is already set
echo "Please follow us at: https://x.com/cryptoconsol"
# read -p "Have you followed us? (yes/no): " followed  # Commented out

if [[ "$followed" != "yes" ]]; then
    echo "Please follow us and run the script again."
    exit 1
fi

echo "Updating VPS..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing prerequisites..."
sudo apt install -y curl ca-certificates

# Install Docker
if [[ "$install_docker" == "yes" ]]; then
    echo "Installing Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    docker --version
else
    echo "Skipping Docker installation."
fi

# Install Docker Compose
if [[ "$install_compose" == "yes" ]]; then
    echo "Installing Docker Compose..."
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
else
    echo "Skipping Docker Compose installation."
fi

# Set up Chromium project directory
echo "Setting up Chromium project directory..."
mkdir -p ~/chromium
cd ~/chromium

# Create docker-compose.yml
echo "Creating docker-compose.yml..."
cat <<EOF > docker-compose.yml
services:
  chromium:
    image: lscr.io/linuxserver/chromium:latest
    container_name: chromium_browser
    environment:
      - PUID=1000  # User ID for file permissions
      - PGID=1000  # Group ID for file permissions
      - TZ=Europe/London  # Adjust timezone
      - CUSTOM_USER=${custom_user}  # Set your own username
      - PASSWORD=${password}  # Set your password
      - CHROME_CLI=https://www.google.com  # Optional: Default starting page
    ports:
      - "3050:3000"  # Adjust ports if necessary
      - "3051:3001"
    security_opt:
      - seccomp:unconfined
    volumes:
      - /root/chromium/config:/config  # Config directory for Chromium
    shm_size: "1gb"  # Prevents crashes by giving the container enough shared memory
    restart: unless-stopped  # Automatically restart on failures or reboots
EOF

# Start Chromium container
echo "Starting Chromium container..."
docker-compose up -d

# Output completion message with separators and red color
echo -e "${RED}/////////////////////////////////////////////////////////////////////////////${RESET}"
echo -e "${RED}Chromium Browser Instalasi Telah Selasai${RESET}"
echo -e "${RED}Akses Unutk Chromium Browser${RESET}"
echo -e "${RED}${IP_PUBLIC}:12323${RESET}"
echo -e "${RED}Username: egan${RESET}"
echo -e "${RED}Password: rumiyah123${RESET}"
echo -e "${RED}/////////////////////////////////////////////////////////////////////////////${RESET}"
