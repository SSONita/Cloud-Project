# Full-Stack App — React + Node.js + PostgreSQL

A complete full-stack application with user authentication, JWT sessions, and profile image uploads. Built to run locally and structured for easy deployment to AWS (EC2 + RDS + S3).

---

## Project Structure

```
app/
├── client/                  # React frontend (port 3000)
│   ├── public/
│   └── src/
│       ├── api.js           # Axios instance with JWT interceptor
│       ├── App.js           # Router setup
│       ├── App.css          # Global styles
│       ├── context/
│       │   └── AuthContext.js
│       ├── components/
│       │   └── ProtectedRoute.js
│       └── pages/
│           ├── Login.js
│           ├── Register.js
│           └── Dashboard.js
│
└── server/                  # Express backend (port 8000)
    ├── index.js             # Entry point
    ├── db.js                # PostgreSQL connection + schema init
    ├── .env                 # Environment variables
    ├── middleware/
    │   └── auth.js          # JWT verification middleware
    ├── routes/
    │   ├── auth.js          # POST /api/auth/register, /api/auth/login
    │   └── user.js          # GET /api/user/profile, POST /api/upload
    └── uploads/             # Stored profile images (auto-created)
```

---

## Prerequisites

- **Node.js** v18+ — https://nodejs.org
- **PostgreSQL** v14+ — https://www.postgresql.org/download/

---

## 1. PostgreSQL Setup

### macOS (Homebrew)
```bash
brew install postgresql@15
brew services start postgresql@15
createdb fullstack_app
```

### Ubuntu / Debian
```bash
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo -u postgres createdb fullstack_app
# Set a password for the postgres user:
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
```

### Windows
Download and install from https://www.postgresql.org/download/windows/  
Then open pgAdmin or psql and run:
```sql
CREATE DATABASE fullstack_app;
```

> The app auto-creates the `users` table on first startup — no manual migrations needed.
> you could use dbeaver or anything else that you like

---

## 2. Backend Setup

```bash
cd server
npm install
```

Edit `.env`

Start the server:
```bash
npm run server       # with nodemon (auto-restarts on changes)
# or
npm start            # plain node
```

You should see:
```
✓ Database initialized
✓ Server running at http://localhost:8000
```

---

## 3. Frontend Setup

```bash
cd client
npm install
npm start
```

The React app opens at **http://localhost:3000**  
API calls are proxied to `http://localhost:8000` via the `"proxy"` field in `client/package.json`.

---

## API Reference

| Method | Endpoint               | Auth? | Description               |
|--------|------------------------|-------|---------------------------|
| POST   | `/api/auth/register`   | No    | Register a new user        |
| POST   | `/api/auth/login`      | No    | Login, returns JWT         |
| GET    | `/api/user/profile`    | Yes   | Get current user info      |
| POST   | `/api/upload`          | Yes   | Upload profile image       |

### Register
```json
POST /api/auth/register
{ "name": "Jane Smith", "email": "jane@example.com", "password": "secret123" }
```

### Login
```json
POST /api/auth/login
{ "email": "jane@example.com", "password": "secret123" }
```

### Upload (multipart/form-data)
```
POST /api/upload
Header: Authorization: Bearer <token>
Body: image (file field)
```

---

## Database Schema

```sql
CREATE TABLE users (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(255) NOT NULL,
  email      VARCHAR(255) UNIQUE NOT NULL,
  password   VARCHAR(255) NOT NULL,
  image_url  TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## AWS Deployment Path

This app is structured to move to AWS with minimal changes:

| Local            | AWS Equivalent         | Change needed                        |
|------------------|------------------------|--------------------------------------|
| PostgreSQL local | **RDS (PostgreSQL)**   | Update `.env` DB_HOST/USER/PASS      |
| `/uploads` folder| **S3 bucket**          | Swap multer disk storage → S3 SDK    |
| `localhost:5000` | **EC2 instance**       | Set `REACT_APP_API_URL` env var      |
| React dev server | **S3 static + CloudFront** | Run `npm run build`, upload `/build` |

---

## Notes

- Uploaded images are served statically from `http://localhost:8000/uploads/<filename>`
- JWT tokens expire after **7 days**
- Max upload size: **5 MB**, accepted types: JPG, PNG, GIF, WebP
- Passwords are hashed with **bcrypt** (10 salt rounds)
