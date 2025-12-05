#!/bin/bash

set -e

echo "🚀 Setting up Gem Store project..."

# Generate APP_KEY if not set
APP_KEY=$(php -r "echo 'base64:' . base64_encode(random_bytes(32));" 2>/dev/null || echo "base64:$(openssl rand -base64 32)")

# Update .env files with APP_KEY
echo "📝 Setting APP_KEY in environment files..."

for env_file in .envs/.env.dev .envs/.env.test .envs/.env.prod; do
    if [ -f "$env_file" ]; then
        # Check if APP_KEY is empty or not set
        if grep -q "^APP_KEY=$" "$env_file" || ! grep -q "^APP_KEY=" "$env_file"; then
            if grep -q "^APP_KEY=" "$env_file"; then
                sed -i "s|^APP_KEY=.*|APP_KEY=$APP_KEY|" "$env_file"
            else
                sed -i "/^APP_NAME=/a APP_KEY=$APP_KEY" "$env_file"
            fi
            echo "✅ Updated $env_file"
        else
            echo "⏭️  $env_file already has APP_KEY set"
        fi
    fi
done

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Review and update .envs/.env.dev with your database credentials"
echo "2. Start development environment:"
echo "   docker-compose -f docker-compose.dev.yml up --build"
echo ""
echo "3. Access your application:"
echo "   - Frontend: http://localhost:5173"
echo "   - Backend:  http://localhost:8000"
echo ""

