# Deployment Guide - EC2

## Prerequisites

1. **EC2 Instance Running**
   - Ubuntu 22.04 LTS (recommended)
   - Minimum: t3.medium (2 vCPU, 4GB RAM)
   - Storage: 20GB+ available

2. **Security Group Configuration**
   - Port 22 (SSH) - from your IP
   - Port 80 (HTTP) - from anywhere (0.0.0.0/0)
   - Port 443 (HTTPS) - from anywhere (0.0.0.0/0)

3. **SSH Access**
   - Your EC2 key pair (.pem file)

## Step 1: Initial EC2 Setup

### 1.1 Connect to EC2
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### 1.2 Install Docker
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Log out and back in for group changes
exit
```

### 1.3 Verify Installation
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
docker --version
docker-compose --version
```

### 1.4 Create Project Directory
```bash
mkdir -p ~/gem-store
cd ~/gem-store
mkdir -p .envs
```

### 1.5 Create Production Environment File
```bash
nano .envs/.env.prod
```

Add your production environment variables:
- `APP_KEY` (generate with: `php artisan key:generate`)
- Database credentials
- Mail configuration
- Other service credentials

## Step 2: Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

1. **EC2_HOST**
   - Value: Your EC2 public IP (e.g., `54.123.45.67`)
   - Or your domain if you have one (e.g., `ec2.example.com`)

2. **EC2_SSH_KEY**
   - Value: Entire content of your `.pem` file
   - Get it with: `cat your-key.pem`
   - Copy everything including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`

## Step 3: Test Deployment

1. **Push to main branch:**
   ```bash
   git add .
   git commit -m "Setup EC2 deployment"
   git push origin main
   ```

2. **Watch GitHub Actions:**
   - Go to GitHub → Actions tab
   - Watch the workflow run
   - Check deploy step logs

3. **Verify on EC2:**
   ```bash
   ssh -i your-key.pem ubuntu@your-ec2-ip
   cd ~/gem-store
   docker-compose -f docker-compose.prod.yml ps
   docker-compose -f docker-compose.prod.yml logs -f
   ```

## Step 4: Access Your Application

Once deployed, access your application at:
- **HTTP:** `http://your-ec2-ip`
- **HTTPS:** `https://your-ec2-ip` (if SSL configured)

## Manual Deployment (if needed)

If you need to deploy manually:

```bash
# SSH into EC2
ssh -i your-key.pem ubuntu@your-ec2-ip

# Navigate to project
cd ~/gem-store

# Pull latest code (if using git)
git pull origin main

# Stop existing containers
docker-compose -f docker-compose.prod.yml down

# Build and start containers
docker-compose -f docker-compose.prod.yml up -d --build

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Check status
docker-compose -f docker-compose.prod.yml ps
```

## Troubleshooting

### Deployment fails with SSH connection error
- Check EC2_HOST secret is correct
- Verify EC2_SSH_KEY is complete (includes BEGIN/END lines)
- Ensure Security Group allows SSH from GitHub Actions IPs
- Test SSH connection manually: `ssh -i your-key.pem ubuntu@your-ec2-ip`

### Containers fail to start
- Check `.envs/.env.prod` file exists and has correct values
- Verify database credentials
- Check logs: `docker-compose -f docker-compose.prod.yml logs`

### Port already in use
- Check what's using the port: `sudo lsof -i :80`
- Stop conflicting services or change port in `docker-compose.prod.yml`

### Out of disk space
- Clean up old images: `docker image prune -a`
- Remove unused volumes: `docker volume prune`

## Maintenance Commands

```bash
# View running containers
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f [service-name]

# Restart a service
docker-compose -f docker-compose.prod.yml restart [service-name]

# Stop all containers
docker-compose -f docker-compose.prod.yml down

# Start containers
docker-compose -f docker-compose.prod.yml up -d

# Rebuild and restart
docker-compose -f docker-compose.prod.yml up -d --build

# Clean up unused Docker resources
docker system prune -a
```

## Security Best Practices

1. **Keep EC2 updated:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Use strong passwords** in `.envs/.env.prod`

3. **Restrict SSH access** in Security Group to your IP only

4. **Set up SSL/TLS** for HTTPS (use Let's Encrypt)

5. **Regular backups** of database and important files

6. **Monitor logs** regularly for suspicious activity

