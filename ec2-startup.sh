#!/bin/bash

#######################################################
# EC2 Startup Script - Auto-configure IP and start app
#######################################################

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Student Registration App - EC2 Startup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Get EC2 public IP
echo -e "${BLUE}[*] Detecting EC2 public IP...${NC}"
EC2_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

if [ -z "$EC2_PUBLIC_IP" ]; then
    echo -e "${RED}[!] Failed to detect EC2 IP${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] EC2 Public IP: $EC2_PUBLIC_IP${NC}"
echo ""

# Get EC2 private IP
echo -e "${BLUE}[*] Detecting EC2 private IP...${NC}"
EC2_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo -e "${GREEN}[✓] EC2 Private IP: $EC2_PRIVATE_IP${NC}"
echo ""

# Set application directory
APP_DIR="/home/ubuntu/student-registration-app"

if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}[!] Application directory not found at $APP_DIR${NC}"
    exit 1
fi

cd "$APP_DIR"
echo -e "${BLUE}[*] Working directory: $APP_DIR${NC}"
echo ""

# Create/update configuration file
echo -e "${BLUE}[*] Creating EC2 configuration...${NC}"
cat > "$APP_DIR/ec2-config.env" << EOF
# Auto-generated EC2 Configuration
# Generated: $(date)
EC2_PUBLIC_IP=$EC2_PUBLIC_IP
EC2_PRIVATE_IP=$EC2_PRIVATE_IP
BACKEND_URL=http://$EC2_PUBLIC_IP:5000/api
FRONTEND_URL=http://$EC2_PUBLIC_IP
API_HOSTNAME=$EC2_PUBLIC_IP
EOF

echo -e "${GREEN}[✓] Configuration file created${NC}"
cat "$APP_DIR/ec2-config.env"
echo ""

# Update frontend script with correct IP
echo -e "${BLUE}[*] Updating frontend configuration...${NC}"

# Create a config.js that will be used by the frontend
cat > "$APP_DIR/frontend/config.js" << 'EOF'
// Auto-generated EC2 frontend configuration
// This detects the correct backend API URL automatically

(function() {
  // Get hostname from URL bar (EC2 IP or domain)
  const hostname = window.location.hostname;
  
  // Construct API URL
  window.API_BASE_URL = 'http://' + hostname + ':5000/api';
  
  console.log('API Configuration:');
  console.log('- Hostname: ' + hostname);
  console.log('- API URL: ' + window.API_BASE_URL);
})();
EOF

echo -e "${GREEN}[✓] Frontend configuration updated${NC}"
echo ""

# Check if Docker is running
echo -e "${BLUE}[*] Checking Docker status...${NC}"
if ! docker ps > /dev/null 2>&1; then
    echo -e "${BLUE}[*] Starting Docker service...${NC}"
    sudo systemctl start docker
    sleep 5
fi

echo -e "${GREEN}[✓] Docker is running${NC}"
echo ""

# Stop existing containers
echo -e "${BLUE}[*] Stopping existing containers...${NC}"
docker-compose down 2>/dev/null || true
sleep 2
echo -e "${GREEN}[✓] Containers stopped${NC}"
echo ""

# Start Docker Compose
echo -e "${BLUE}[*] Starting Docker Compose services...${NC}"
docker-compose up -d

# Wait for services to start
echo -e "${BLUE}[*] Waiting for services to start (30 seconds)...${NC}"
sleep 30

echo ""
echo -e "${BLUE}[*] Checking service status...${NC}"
docker-compose ps
echo ""

# Check if backend is responding
echo -e "${BLUE}[*] Verifying backend API...${NC}"
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}[✓] Backend API is responding${NC}"
else
    echo -e "${RED}[!] Backend API is not responding yet${NC}"
fi
echo ""

# Final status
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Application Started Successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "📍 Access your application:"
echo -e "${BLUE}   Frontend:  http://$EC2_PUBLIC_IP${NC}"
echo -e "${BLUE}   Backend:   http://$EC2_PUBLIC_IP:5000/api${NC}"
echo ""
echo "🔍 View logs:"
echo -e "${BLUE}   All logs:     docker-compose logs -f${NC}"
echo -e "${BLUE}   Backend:      docker-compose logs backend${NC}"
echo -e "${BLUE}   Frontend:     docker-compose logs frontend${NC}"
echo -e "${BLUE}   Database:     docker-compose logs mysql${NC}"
echo ""
echo "🛑 Stop application:"
echo -e "${BLUE}   docker-compose down${NC}"
echo ""
echo "📝 Configuration saved to: $APP_DIR/ec2-config.env"
echo ""

# Log startup
echo "[$(date)] Application started with IP $EC2_PUBLIC_IP" >> /home/ubuntu/app-startup.log

echo -e "${GREEN}✓ Startup complete!${NC}"
