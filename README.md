# 🎓 Student Registration Application

 *Simple, Beautiful, and Powerful Student Management System*

A modern, full-stack Student Registration System with a beautiful UI, Node.js backend API, and MySQL database. Deploy locally or on AWS EC2 with automatic IP handling.

---

## ✨ What You Can Do

### Register Students
- Fill simple form with student details
- Automatic validation
- Success confirmation message

### Manage Student Records
- **View All** - See complete student list in professional table
- **Search** - Find students by name or email instantly
- **Edit** - Update student information anytime
- **Delete** - Remove student records with confirmation

### Technical Features
- ✅ Beautiful modern UI with gradient design
- ✅ Fully responsive (desktop, tablet, mobile)
- ✅ RESTful API for all operations
- ✅ MySQL database for persistent storage
- ✅ Docker containerization
- ✅ Automatic IP detection for EC2
- ✅ Auto-restart on failure
- ✅ Health checks and logging

---

## 🚀 Quick Setup (Choose One)

### Option 1: Docker (Easiest - Recommended)
```bash
cd student-registration-app
docker-compose up --build
```
Opens on: `http://localhost`

### Option 2: Windows Batch
```batch
setup.bat
```

### Option 3: Mac/Linux Bash
```bash
bash setup.sh
```

### Option 4: Manual Setup
```bash
# Backend
cd backend
npm install
npm start

# Frontend (new terminal)
cd frontend
python -m http.server 8000
# Open: http://localhost:8000
```
   ```bash
   docker-compose up --build
   ```

3. **Access the application:**
   - Frontend: http://localhost
   - Backend API: http://localhost:5000
   - Database: localhost:3306

4. **Stop the application:**
   ```bash
   docker-compose down
   ```

### Manual Setup (Without Docker)

#### Backend Setup

1. **Install dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **Configure database connection:**
   - Edit `.env` file with your MySQL credentials

3. **Start the backend server:**
   ```bash
   npm start
   ```
   Server will run on `http://localhost:5000`

#### Frontend Setup

1. **Install web server (optional):**
   ```bash
   # Using Python
   python -m http.server 8000
   
   # Or using Node.js
   npx http-server
   ```

2. **Open in browser:**
   - http://localhost:8000 (or your configured port)

3. **Update API URL in script.js if needed:**
   ```javascript
   const API_URL = 'http://localhost:5000/api';
   ---

## 📋 Commands Reference

### Docker Compose
```bash
docker-compose up --build          # Build and start
docker-compose down                # Stop all services
docker-compose ps                  # View running containers
docker-compose logs -f             # View logs
docker-compose restart             # Restart all services
```

### Backend Development
```bash
cd backend
npm install                        # Install dependencies
npm start                          # Start server
npm run dev                        # Start with auto-reload
```

### Docker (Individual Services)
```bash
docker-compose logs backend        # Backend logs
docker-compose logs mysql          # Database logs
docker-compose exec mysql mysql -u root -p'password123'  # Access MySQL
```

### Makefile Commands (if available)
```bash
make help                          # Show all commands
make up                            # Start services
make down                          # Stop services
make logs                          # View logs
make clean                         # Clean containers
```

---

## 🔗 API Endpoints

### Base URL: `http://localhost:5000/api`

| Method | Endpoint | Action |
|--------|----------|--------|
| **POST** | `/students` | Create new student |
| **GET** | `/students` | Get all students |
| **GET** | `/students/:id` | Get one student |
| **PUT** | `/students/:id` | Update student |
| **DELETE** | `/students/:id` | Delete student |
| **GET** | `/health` | Check backend status |

### Example: Register Student
```bash
curl -X POST http://localhost:5000/api/students \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "dateOfBirth": "2005-01-15",
    "gender": "Male",
    "address": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001"
  }'
```

---

## 🌍 Deploy on AWS EC2

### 3 Simple Steps

#### Step 1: Launch EC2 Instance
1. Go to AWS Console → EC2
2. Launch Ubuntu 22.04 LTS, t2.micro
3. Create security group (allow ports: 22, 80, 5000)
4. Note your **Public IP**

#### Step 2: Install & Run
```bash
ssh -i your-key.pem ubuntu@YOUR_IP

# Get application
git clone <repo-url> student-registration-app
cd student-registration-app

# Run installation script
bash ec2-install.sh
```

#### Step 3: Open Browser
```
http://YOUR_IP
```

✅ **Done! Application is live!**

### Important Notes
- IP may change when you restart (without Elastic IP)
- Frontend **auto-detects your EC2 IP** - no manual config needed
- If IP changes, run: `bash update-ip.sh`
- Use Elastic IP for permanent IP (recommended)

---

## 🗄️ Database

**Name:** `student_registration`

### Students Table
```sql
CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(15) NOT NULL,
  dateOfBirth DATE NOT NULL,
  gender VARCHAR(10) NOT NULL,
  address VARCHAR(255) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  zipCode VARCHAR(10) NOT NULL,
  enrollmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Default Credentials:**
- User: `root`
- Password: `password123`

---

## 📁 Project Structure

```
student-registration-app/
├── backend/              # Node.js API
│   ├── server.js        # Express server
│   ├── package.json     # Dependencies
│   └── Dockerfile       # Container config
├── frontend/            # Web UI
│   ├── index.html       # Page structure
│   ├── style.css        # Styling
│   ├── script.js        # Frontend logic
│   └── Dockerfile       # Container config
├── docker-compose.yml   # Docker setup
└── README.md            # This file
```

---

## 🔧 Form Fields

Student registration requires:
- Full Name
- Email (unique)
- Phone Number
- Date of Birth
- Gender
- Street Address
- City
- State/Province
- Zip/Postal Code

---

## ⚠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| **Port already in use** | Change port in docker-compose.yml or kill process |
| **Can't connect API** | Check if backend running: `curl http://localhost:5000/api/health` |
| **Database error** | Restart: `docker-compose down && docker-compose up --build` |
| **On EC2, page won't load** | Try fresh IP: `curl http://169.254.169.254/latest/meta-data/public-ipv4` |
| **IP changed on EC2** | Run: `bash update-ip.sh` |

---

## 💡 Features Summary

✨ **Register Students** - Simple form with validation
✨ **View List** - Professional table display
✨ **Search** - Find by name or email
✨ **Edit** - Update any student details
✨ **Delete** - Remove student records
✨ **Beautiful UI** - Gradient design, responsive layout
✨ **Mobile Ready** - Works on all devices
✨ **Production Ready** - Docker, health checks, auto-restart

---

## 📦 Tech Stack

- **Frontend:** HTML5, CSS3, JavaScript (Vanilla - no frameworks)
- **Backend:** Node.js, Express.js
- **Database:** MySQL 8.0
- **Server:** Nginx
- **Containerization:** Docker, Docker Compose

---

## 📄 License

MIT License - Feel free to use and modify.

---

**Need help?** Check the commands above or review the code in `/backend` and `/frontend` directories.
