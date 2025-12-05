# EC2 Setup Commands

## On EC2 Instance

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create project directory
mkdir -p ~/gem-store
cd ~/gem-store
mkdir -p .envs

# Create production environment file
nano .envs/.env.prod
# Add your production environment variables here

# Verify Docker installation
docker --version
docker-compose --version