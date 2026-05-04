# Comprehensive Setup Guide

## 🚀 Getting Started

This Student Registration Application is a complete, production-ready solution with Docker support. Follow these steps to get it running.

## Option 1: Docker Compose (Easiest)

### 1. Install Docker
- **Windows/Mac**: Download Docker Desktop from https://www.docker.com/products/docker-desktop
- **Linux**: Follow the official installation guide

### 2. Navigate to project directory
```bash
cd student-registration-app
```

### 3. Build and Start Services
```bash
docker-compose up --build
```

First run will download images and build containers (~5-10 minutes).

### 4. Access the Application
- **Frontend**: Open http://localhost in your browser
- **API**: http://localhost:5000/api
- **Database**: localhost:3306 (MySQL)

### 5. Test the Application
1. Fill out the registration form
2. Click "Register Student"
3. Scroll down to see the student in the table
4. Try searching, editing, and deleting

### 6. Stop the Application
```bash
docker-compose down
```

---

## Option 2: Manual Setup (Linux/Mac)

### Prerequisites
- Node.js 18+
- MySQL 8.0+
- npm or yarn

### Backend Setup

```bash
# Navigate to backend directory
cd student-registration-app/backend

# Install dependencies
npm install

# Create/update .env file
cat > .env << EOF
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password123
DB_NAME=student_registration
PORT=5000
EOF

# Create MySQL database
mysql -u root -p'password123' -e "CREATE DATABASE IF NOT EXISTS student_registration;"

# Start the server
npm start
```

Backend runs on http://localhost:5000

### Frontend Setup

```bash
# Navigate to frontend directory
cd student-registration-app/frontend

# Start a simple HTTP server
python -m http.server 8000
# Or: npx http-server
# Or: php -S localhost:8000
```

Frontend runs on http://localhost:8000

---

## Option 3: Docker Manual Build

### Build Images
```bash
# Build backend image
docker build -t student-registration-backend ./backend

# Build frontend image
docker build -t student-registration-frontend ./frontend
```

### Run Containers
```bash
# Run MySQL
docker run -d --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=password123 \
  -e MYSQL_DATABASE=student_registration \
  -p 3306:3306 \
  mysql:8.0

# Run Backend
docker run -d --name backend \
  -e DB_HOST=mysql-db \
  -e DB_USER=root \
  -e DB_PASSWORD=password123 \
  -e DB_NAME=student_registration \
  -p 5000:5000 \
  --link mysql-db:mysql-db \
  student-registration-backend

# Run Frontend
docker run -d --name frontend \
  -p 80:80 \
  student-registration-frontend
```

---

## 🔧 Environment Variables

### Backend (.env)
```
DB_HOST=mysql           # MySQL host
DB_USER=root            # MySQL user
DB_PASSWORD=password123 # MySQL password
DB_NAME=student_registration  # Database name
PORT=5000               # Backend port
```

### Frontend (script.js)
```javascript
const API_URL = 'http://localhost:5000/api';  // API endpoint
```

---

## 📋 Form Fields

When registering a student, you'll need:
- **Full Name** - Student's complete name
- **Email** - Valid email address (must be unique)
- **Phone** - Contact number
- **Date of Birth** - Student's DOB
- **Gender** - Male/Female/Other
- **Street Address** - Home address
- **City** - City of residence
- **State** - State/Province
- **Zip/Postal Code** - Postal code

---

## 🎯 Features to Try

1. **Register a Student**
   - Fill all fields and click "Register"
   - See success message
   - Student appears in table

2. **Search Students**
   - Type in the search box
   - Results filter in real-time
   - Search by name or email

3. **Edit Student**
   - Click "Edit" button in any row
   - Modify details in modal
   - Click "Save Changes"

4. **Delete Student**
   - Click "Delete" button
   - Confirm deletion
   - Student removed from list

5. **Responsive Design**
   - Resize browser window
   - Layout adapts to mobile
   - All features work on mobile

---

## 🐛 Troubleshooting

### "Cannot connect to database"
```bash
# Check MySQL is running
docker ps  # Should show mysql container

# Restart containers
docker-compose down
docker-compose up --build
```

### "Port 3306 already in use"
```bash
# Change port in docker-compose.yml
# Line: "3306:3306" → "3307:3306"

# Or kill process using port (Windows)
netstat -ano | findstr :3306
taskkill /PID <PID> /F
```

### "Frontend can't reach API"
- Check backend is running: `curl http://localhost:5000/api/health`
- Update API_URL in frontend/script.js if needed
- Check CORS settings in backend

### "Email already exists error"
- This email is already registered
- Try with a different email

### "Docker image build fails"
```bash
# Clear Docker cache and rebuild
docker-compose down
docker system prune -a
docker-compose up --build
```

---

## 📊 Useful Commands

### Docker Compose
```bash
docker-compose up                    # Start services
docker-compose up --build            # Rebuild and start
docker-compose down                  # Stop all services
docker-compose logs -f               # View logs
docker-compose logs backend          # View specific service logs
docker-compose ps                    # List running containers
```

### Docker
```bash
docker ps                            # List running containers
docker images                        # List images
docker logs <container-name>         # View container logs
docker exec -it <container-name> bash  # Access container shell
```

### MySQL
```bash
# Access MySQL from host
mysql -u root -p'password123' -h 127.0.0.1

# Inside container
docker exec -it mysql-db mysql -u root -p'password123'

# View students
SELECT * FROM student_registration.students;
```

---

## 🔐 Security Notes

### For Local Development:
✅ Current setup is fine for testing

### For Production:
⚠️ Do NOT use these credentials

1. Change database password
2. Use strong passwords
3. Enable HTTPS
4. Add user authentication
5. Implement API rate limiting
6. Use environment secrets
7. Add input validation
8. Enable CORS only for frontend domain

---

## 📱 Responsive Breakpoints

The application is optimized for:
- 📱 Mobile: 320px - 480px
- 📱 Tablet: 481px - 1024px
- 🖥️ Desktop: 1025px+

---

## ⚡ Performance Optimization

For better performance:

1. **Database**: Add indexes on frequently searched columns
2. **Frontend**: Implement pagination for large datasets
3. **API**: Add response caching
4. **Images**: Optimize Docker images
5. **Network**: Use CDN for static assets

---

## 🎓 Learning Resources

- **Express.js**: https://expressjs.com/
- **MySQL**: https://dev.mysql.com/doc/
- **Docker**: https://docs.docker.com/
- **HTML/CSS/JavaScript**: https://mdn.mozilla.org/

---

## 📞 Support

If you encounter issues:
1. Check the README.md
2. Review error messages carefully
3. Check Docker logs: `docker-compose logs`
4. Ensure all ports are available
5. Verify internet connection for downloading images

---

**Happy coding! 🚀**
