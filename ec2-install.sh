#!/bin/bash

#######################################################
# EC2 Installation Script
# Complete setup from scratch
#######################################################

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Student Registration App - EC2 Complete Installation   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Update system
echo -e "${YELLOW}[Step 1/6]${NC} Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y
echo -e "${GREEN}✓ System updated${NC}"
echo ""

# Step 2: Install Docker
echo -e "${YELLOW}[Step 2/6]${NC} Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu
    rm get-docker.sh
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
fi
echo ""

# Step 3: Install Docker Compose
echo -e "${YELLOW}[Step 3/6]${NC} Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✓ Docker Compose already installed${NC}"
fi
echo ""

# Step 4: Download/Clone application
echo -e "${YELLOW}[Step 4/6]${NC} Setting up application directory..."
if [ ! -d /home/ubuntu/student-registration-app ]; then
    echo "How do you want to get the application?"
    echo "1) Clone from Git (requires repository URL)"
    echo "2) Download from URL"
    echo "3) Assume already present"
    read -p "Choice (1-3): " choice
    
    case $choice in
        1)
            read -p "Enter Git repository URL: " git_url
            cd /home/ubuntu
            git clone "$git_url" student-registration-app
            ;;
        2)
            read -p "Enter download URL: " download_url
            cd /home/ubuntu
            wget "$download_url" -O app.zip || curl -o app.zip "$download_url"
            unzip app.zip
            rm app.zip
            ;;
        3)
            echo "Skipping download..."
            ;;
    esac
fi

if [ -d /home/ubuntu/student-registration-app ]; then
    cd /home/ubuntu/student-registration-app
    echo -e "${GREEN}✓ Application directory ready${NC}"
else
    echo -e "${RED}✗ Application directory not found${NC}"
    exit 1
fi
echo ""

# Step 5: Configure for EC2
echo -e "${YELLOW}[Step 5/6]${NC} Configuring for EC2..."
bash ec2-startup.sh
echo ""

# Step 6: Setup auto-start (crontab)
echo -e "${YELLOW}[Step 6/6]${NC} Setting up auto-start on reboot..."

# Make startup script executable
chmod +x /home/ubuntu/student-registration-app/ec2-startup.sh
chmod +x /home/ubuntu/student-registration-app/update-ip.sh

# Add to crontab if not already there
if ! (crontab -l 2>/dev/null | grep -q "ec2-startup.sh"); then
    (crontab -l 2>/dev/null || true; echo "@reboot sleep 30 && /home/ubuntu/student-registration-app/ec2-startup.sh >> /home/ubuntu/app-startup.log 2>&1") | crontab -
    echo -e "${GREEN}✓ Auto-start configured${NC}"
else
    echo -e "${GREEN}✓ Auto-start already configured${NC}"
fi
echo ""

# Final status
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete! ✓                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get IP
EC2_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo -e "${GREEN}📍 Your Application is Ready!${NC}"
echo ""
echo -e "${BLUE}Access Points:${NC}"
echo "  Frontend:  http://$EC2_IP"
echo "  Backend:   http://$EC2_IP:5000/api"
echo ""
echo -e "${BLUE}Useful Commands:${NC}"
echo "  View logs:      docker-compose logs -f"
echo "  Stop app:       cd ~/student-registration-app && docker-compose down"
echo "  Restart app:    cd ~/student-registration-app && docker-compose restart"
echo "  Update IP:      ~/student-registration-app/update-ip.sh"
echo ""
echo -e "${BLUE}Auto-Restart:${NC}"
echo "  ✓ Application will auto-start on instance reboot"
echo "  ✓ IP will be auto-detected and configured"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  EC2 Guide:       ~/student-registration-app/EC2_DEPLOYMENT.md"
echo "  Setup Guide:     ~/student-registration-app/SETUP.md"
echo "  Full Docs:       ~/student-registration-app/README.md"
echo ""
echo -e "${YELLOW}Note:${NC} If you restart the EC2 instance without Elastic IP,"
echo "      you can run: ~/student-registration-app/update-ip.sh"
echo ""
