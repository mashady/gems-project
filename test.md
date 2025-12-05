#!/bin/bash
set -e

echo "🚀 Setting up EC2 for Gem Store deployment..."

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential tools
echo "🔧 Installing essential tools..."
sudo apt install -y curl wget git unzip software-properties-common

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo usermod -aG docker ubuntu
    rm get-docker.sh
fi

# Start and enable Docker
echo "▶️ Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
echo "🐙 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Install Node.js 20
echo "📦 Installing Node.js 20..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Add swap space (4GB) to prevent OOM issues
echo "💾 Setting up swap space..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Create project directory
echo "📁 Creating project directories..."
mkdir -p ~/gem-store
mkdir -p ~/gem-store/frontend-dist
mkdir -p ~/gem-store/.envs

# Set up Git credentials (optional - for private repos)
echo "🔐 Setting up Git (optional)..."
# Uncomment and add your token if needed:
# git config --global credential.helper store
# echo "https://YOUR_USERNAME:YOUR_TOKEN@github.com" > ~/.git-credentials
# chmod 600 ~/.git-credentials

# Verify installations
echo ""
echo "✅ Setup complete! Verifying installations..."
echo ""
echo "Docker version:"
docker --version
echo ""
echo "Docker Compose version:"
docker-compose --version
echo ""
echo "Node.js version:"
node --version
echo ""
echo "npm version:"
npm --version
echo ""
echo "Memory status:"
free -h
echo ""
echo "Disk space:"
df -h
echo ""
echo "✅ All set! Now set up the GitHub Actions runner:"
echo "   1. Go to: https://github.com/mashady/gems-project/settings/actions/runners/new"
echo "   2. Copy the registration token"
echo "   3. Run: cd ~/actions-runner && ./config.sh --url https://github.com/mashady/gems-project --token YOUR_TOKEN"
echo "   4. Run: sudo ./svc.sh install && sudo ./svc.sh start"