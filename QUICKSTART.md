# Quick Start Guide

## 🚀 Immediate Next Steps

### 1. Run Setup Script
```bash
./setup.sh
```
This will generate and set `APP_KEY` for all environment files.

### 2. Review Environment Files
Edit `.envs/.env.dev` and update any values you need:
- Database credentials (already set with defaults)
- Mail configuration
- Any other service credentials

### 3. Start Development Environment
```bash
docker-compose -f docker-compose.dev.yml up --build
```

**First time will take a few minutes** to build images and install dependencies.

### 4. Access Your Application
Once containers are running:
- **Frontend (React)**: http://localhost:5173
- **Backend (Laravel API)**: http://localhost:8000
- **MySQL**: localhost:3307

### 5. Initialize Laravel (First Time Only)
In a new terminal, run:
```bash
docker-compose -f docker-compose.dev.yml exec backend php artisan migrate
```

## 📝 Common Commands

### Development
```bash
# Start (with logs)
docker-compose -f docker-compose.dev.yml up

# Start (detached)
docker-compose -f docker-compose.dev.yml up -d

# Stop
docker-compose -f docker-compose.dev.yml down

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Execute commands in backend
docker-compose -f docker-compose.dev.yml exec backend php artisan <command>

# Execute commands in frontend
docker-compose -f docker-compose.dev.yml exec frontend npm <command>
```

### Testing
```bash
# Run all tests
docker-compose -f docker-compose.test.yml up --build

# Run only backend tests
docker-compose -f docker-compose.test.yml up backend

# Run only frontend tests
docker-compose -f docker-compose.test.yml up frontend
```

## 🔧 Troubleshooting

### Port Already in Use
If ports 8000, 5173, or 3307 are in use:
1. Stop the conflicting service, or
2. Edit `docker-compose.dev.yml` and change the port mappings

### Database Connection Issues
1. Ensure MySQL container is running: `docker-compose -f docker-compose.dev.yml ps`
2. Check `.envs/.env.dev` has correct DB credentials
3. Wait a few seconds after starting for MySQL to initialize

### Permission Issues
```bash
# Fix Laravel storage permissions
docker-compose -f docker-compose.dev.yml exec backend chmod -R 775 storage bootstrap/cache
```

## 🎯 What's Next?

1. **Start coding!** Your dev environment has hot reload enabled
2. **Add API routes** in `backend/routes/api.php`
3. **Create React components** in `frontend/src/`
4. **Write tests** as you develop
5. **Push to GitHub** to trigger CI/CD pipeline

## 📚 Project Structure

- `backend/` - Laravel API
- `frontend/` - React app
- `.envs/` - Environment configurations
- `docker-compose.*.yml` - Environment-specific Docker configs

Happy coding! 🎉

