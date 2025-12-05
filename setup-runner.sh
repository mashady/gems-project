#!/bin/bash
set -e

echo "🚀 Setting up GitHub Actions Self-Hosted Runner"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "❌ Please do not run as root. Run as a regular user."
   exit 1
fi

# Create directory
RUNNER_DIR="$HOME/actions-runner"
mkdir -p "$RUNNER_DIR" && cd "$RUNNER_DIR"

echo "📥 Downloading GitHub Actions Runner..."
# Download latest runner (update version as needed)
RUNNER_VERSION="2.311.0"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L "$RUNNER_URL"

echo "📦 Extracting runner..."
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

echo ""
echo "✅ Runner downloaded and extracted!"
echo ""
echo "📝 Next steps:"
echo "1. Go to your GitHub repository:"
echo "   https://github.com/YOUR_USERNAME/gem-store/settings/actions/runners/new"
echo ""
echo "2. Select 'Linux' and 'x64'"
echo ""
echo "3. Copy the registration token"
echo ""
echo "4. Run the following command (replace YOUR_TOKEN and YOUR_USERNAME):"
echo "   cd $RUNNER_DIR"
echo "   ./config.sh --url https://github.com/YOUR_USERNAME/gems-project --token YOUR_TOKEN"
echo ""
echo "5. Install and start the service:"
echo "   sudo ./svc.sh install"
echo "   sudo ./svc.sh start"
echo "   sudo ./svc.sh status"
echo ""
echo "6. Verify in GitHub: Repository → Settings → Actions → Runners"
echo ""

