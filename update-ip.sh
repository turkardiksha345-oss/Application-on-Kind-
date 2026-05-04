#!/bin/bash

#######################################################
# Update EC2 IP Configuration
# Run this after restarting your EC2 instance
#######################################################

echo "🔄 Updating EC2 IP Configuration..."
echo ""

# Get current EC2 public IP
echo "🔍 Detecting EC2 public IP..."
EC2_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

if [ -z "$EC2_PUBLIC_IP" ]; then
    echo "❌ Failed to detect EC2 IP"
    exit 1
fi

echo "✅ EC2 Public IP: $EC2_PUBLIC_IP"
echo ""

# Navigate to application directory
APP_DIR="/home/ubuntu/student-registration-app"
if [ ! -d "$APP_DIR" ]; then
    echo "❌ Application directory not found: $APP_DIR"
    exit 1
fi

cd "$APP_DIR"
echo "📂 Working in: $APP_DIR"
echo ""

# Update frontend config
echo "⚙️  Updating frontend configuration..."
cat > frontend/config.js << EOF
// Auto-generated EC2 frontend configuration
(function() {
  const hostname = window.location.hostname;
  window.API_BASE_URL = 'http://' + hostname + ':5000/api';
  console.log('API URL: ' + window.API_BASE_URL);
})();
EOF
echo "✅ Frontend configuration updated"
echo ""

# Update Docker environment if needed
echo "🐳 Stopping containers..."
docker-compose down
sleep 3
echo "✅ Containers stopped"
echo ""

echo "🚀 Starting containers..."
docker-compose up -d
sleep 30
echo "✅ Containers started"
echo ""

# Verify
echo "🔍 Checking services..."
docker-compose ps
echo ""

# Test backend
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ Backend is responding"
else
    echo "⏳ Backend still starting..."
fi
echo ""

echo "✨ Configuration Updated!"
echo ""
echo "📍 Your application is at:"
echo "   http://$EC2_PUBLIC_IP"
echo ""
