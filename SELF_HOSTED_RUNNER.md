# Self-Hosted GitHub Actions Runner Setup

## Overview

This guide will help you set up a self-hosted GitHub Actions runner on your EC2 instance. This allows you to run CI/CD pipelines for **free** without using GitHub Actions minutes.

## Prerequisites

- EC2 instance running Ubuntu (or similar Linux distribution)
- SSH access to your EC2 instance
- Docker and Docker Compose installed on EC2
- GitHub repository access

## Step-by-Step Setup

### Step 1: Connect to Your EC2 Instance

```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### Step 2: Run the Setup Script

```bash
# Copy the setup script to EC2 or run directly
curl -o setup-runner.sh https://raw.githubusercontent.com/mashady/gems-project/main/setup-runner.sh
chmod +x setup-runner.sh
./setup-runner.sh
```

Or manually:

```bash
# Create directory
mkdir -p ~/actions-runner && cd ~/actions-runner

# Download runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

# Extract
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
```

### Step 3: Get Registration Token

1. Go to your GitHub repository
2. Click **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Select **Linux** and **x64**
5. Copy the registration token (looks like: `AXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)

### Step 4: Configure the Runner

```bash
cd ~/actions-runner

# Replace YOUR_USERNAME and YOUR_TOKEN with actual values
./config.sh --url https://github.com/YOUR_USERNAME/gem-store --token YOUR_TOKEN

./config.sh --url https://github.com/mashady/gems-project --token ARVO7STRHTHLWU5IXYMS6ILJGL65Y
```

When prompted:
- **Runner name:** `gem-store-runner` (or any name)
- **Work folder:** Press Enter for default (`_work`)
- **Run as service:** Type `Y` (yes)

### Step 5: Install as a Service

```bash
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
```

### Step 6: Verify Runner is Online

1. Go to GitHub: Repository → **Settings** → **Actions** → **Runners**
2. You should see your runner listed as **"Online"** with a green dot

## Ensure Docker is Available

Make sure Docker is installed and the runner user can access it:

```bash
# Install Docker (if not already installed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add runner user to docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker _runner  # Runner service user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Restart runner service
cd ~/actions-runner
sudo ./svc.sh restart
```

## How It Works

Once set up:
1. **Tests run** on your EC2 instance (free, no minute limits)
2. **Deployment happens** directly on the same EC2 instance
3. **No GitHub Actions minutes** are consumed
4. **Faster builds** since everything runs locally

## Managing the Runner

### Check Status
```bash
cd ~/actions-runner
sudo ./svc.sh status
```

### View Logs
```bash
cd ~/actions-runner
tail -f _diag/Runner_*.log
```

### Stop/Start/Restart
```bash
sudo ./svc.sh stop
sudo ./svc.sh start
sudo ./svc.sh restart
```

### Uninstall (if needed)
```bash
cd ~/actions-runner
sudo ./svc.sh stop
sudo ./svc.sh uninstall

# Get removal token from GitHub: Settings → Actions → Runners → Click runner → Remove
./config.sh remove --token YOUR_REMOVAL_TOKEN
```

## Troubleshooting

### Runner Not Appearing Online
- Check runner service: `sudo ./svc.sh status`
- Check logs: `tail -f ~/actions-runner/_diag/Runner_*.log`
- Verify network connectivity
- Check firewall rules

### Docker Permission Denied
```bash
sudo usermod -aG docker $USER
sudo usermod -aG docker _runner
sudo ./svc.sh restart
```

### Runner Keeps Going Offline
- Check EC2 instance is running
- Verify runner service is running: `sudo systemctl status actions.runner.*`
- Check disk space: `df -h`
- Review logs for errors

### Workflow Fails with "No runner available"
- Ensure runner is online in GitHub
- Check runner labels match workflow requirements
- Verify runner is not busy with another job

## Security Considerations

⚠️ **Important Security Notes:**

1. **Only use for trusted repositories** - The runner has access to your code and secrets
2. **Keep runner updated** - Update regularly for security patches
3. **Use labels** - Control which jobs run on which runners
4. **Network isolation** - Consider firewall rules
5. **Regular monitoring** - Check logs regularly

## Benefits

✅ **Free** - No GitHub Actions minute limits  
✅ **Fast** - Runs on your infrastructure  
✅ **Control** - Full control over the environment  
✅ **Private** - Code stays on your server  
✅ **Custom** - Install any tools you need  

## Next Steps

1. Set up the runner using the steps above
2. Push code to trigger the workflow
3. Watch it run on your self-hosted runner
4. Enjoy unlimited free CI/CD! 🎉

## Support

If you encounter issues:
- Check GitHub Actions logs
- Review runner logs: `~/actions-runner/_diag/`
- Check Docker: `docker ps` and `docker-compose --version`
- Verify network connectivity

