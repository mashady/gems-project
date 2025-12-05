# Gem Store - Full Stack Application

## Project Structure

```
gems-project/
├── backend/          # Laravel PHP application
├── frontend/         # React (Vite) application
├── .envs/           # Environment configuration files
│   ├── .env.dev
│   ├── .env.test
│   └── .env.prod
├── docker-compose.dev.yml
├── docker-compose.test.yml
├── docker-compose.prod.yml
└── .github/workflows/ci-cd.yml
```

## Environment Setup

### Development Environment

```bash
# Start development environment with hot reload
docker-compose -f docker-compose.dev.yml up --build

# Access:
# - Frontend: http://localhost:5173
# - Backend: http://localhost:8000
# - MySQL: localhost:3307
```

### Testing Environment

```bash
# Run tests in isolated environment
docker-compose -f docker-compose.test.yml up --build

# Tests run automatically and containers exit
```

### Production Environment

```bash
# Build and start production environment
docker-compose -f docker-compose.prod.yml up --build -d

# Access:
# - Application: http://localhost (via Nginx)
# - HTTPS: https://localhost (if SSL certificates configured)
```

## Environment Variables

Edit the following files with your configuration:

- `.envs/.env.dev` - Development environment
- `.envs/.env.test` - Testing environment  
- `.envs/.env.prod` - Production environment

**Important:** Set `APP_KEY` in all environment files:
```bash
php artisan key:generate
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) automatically:
1. Runs tests on push/PR
2. Copies code to EC2 server (main branch only)
3. Builds and deploys Docker containers on EC2

### Required GitHub Secrets:
- `EC2_HOST` - Your EC2 instance public IP or domain
- `EC2_SSH_KEY` - Your EC2 SSH private key (entire .pem file content)

### EC2 Setup Requirements:
- Docker and Docker Compose installed on EC2
- `.envs/.env.prod` file created on EC2 with production environment variables
- Security Group configured to allow SSH (port 22) and HTTP/HTTPS (ports 80, 443)

## Commands

### Development
```bash
# Start dev environment
docker-compose -f docker-compose.dev.yml up

# Stop dev environment
docker-compose -f docker-compose.dev.yml down

# View logs
docker-compose -f docker-compose.dev.yml logs -f
```

### Testing
```bash
# Run all tests
docker-compose -f docker-compose.test.yml up --build

# Run backend tests only
docker-compose -f docker-compose.test.yml up backend

# Run frontend tests only
docker-compose -f docker-compose.test.yml up frontend
```

### Production
```bash
# Build and start
docker-compose -f docker-compose.prod.yml up --build -d

# Stop
docker-compose -f docker-compose.prod.yml down

# View logs
docker-compose -f docker-compose.prod.yml logs -f
```
