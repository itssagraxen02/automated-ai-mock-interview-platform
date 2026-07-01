# 🤖 AI Mock Interview Platform
### MERN Stack + Mamdani Fuzzy Logic | Zero-Install Database

---

## ⚡ Quick Start (3 commands)

```bash
# 1. Install all dependencies
npm run setup

# 2. Seed the database with sample questions + accounts
npm run seed

# 3. Start both servers
npm run dev
```

Then open **http://localhost:3000**

**Login credentials (ready after seeding):**
| Account | Email | Password |
|---------|-------|----------|
| Admin   | admin@mockinterview.com | Admin@123456 |
| Demo    | demo@mockinterview.com  | Demo@123456  |

---

## 🖥 One-Click Setup Scripts

**Windows** — Double-click `setup-and-run.bat`

**Mac / Linux:**
```bash
chmod +x setup-and-run.sh
./setup-and-run.sh
```

These scripts install everything, seed the DB, start both servers, and open the browser automatically.

---

## 📋 Prerequisites

- **Node.js v18+** → https://nodejs.org
- **No MongoDB needed** — uses NeDB embedded database (data stored in `backend/data/`)
- **OpenAI API key** → optional (works without it using keyword-based fallback)

---

## 🔮 Fuzzy Logic Architecture

This platform implements a **Mamdani Fuzzy Inference System** that evaluates answers
across 5 linguistic dimensions:

| Dimension | Crisp Input (0–10) | Description |
|-----------|-------------------|-------------|
| Keyword Relevance | `keywordCoverage` | % of expected keywords present |
| Completeness | `lengthScore` | Answer length vs optimal range |
| Clarity | `aiConfidence` | AI/keyword relevance score |
| Technical Depth | `timeEfficiency` | Time used vs time limit |
| Communication | `coherenceScore` | Structural coherence |

### Fuzzy Sets (input domain 0–10)
```
poor:      trapezoid [0,   0,   2,   4.5]
average:   triangle  [2,   5,   7.5]
good:      triangle  [5,   7.5, 9.5]
excellent: trapezoid [7.5, 9,   10,  10]
```

### Inference Method
- Weighted aggregation across 5 dimensions
- Output activation maps to `poor | average | good | excellent`
- Defuzzification: **Centroid method** over [0, 100]

### Score → Grade
| Score | Grade |
|-------|-------|
| ≥ 80 | Excellent |
| ≥ 60 | Good |
| ≥ 40 | Average |
| < 40 | Poor |

---

## 📁 Project Structure

```
ai-mock-interview/
├── setup-and-run.bat          ← Windows one-click launcher
├── setup-and-run.sh           ← Mac/Linux one-click launcher
│
├── backend/
│   ├── .env                   ← Environment variables (auto-created)
│   ├── server.js              ← Express + Socket.io entry point
│   ├── seeder.js              ← Seeds 16 questions + 2 users
│   ├── data/                  ← NeDB files (auto-created on first run)
│   │   ├── users.db
│   │   ├── questions.db
│   │   └── sessions.db
│   ├── config/
│   │   ├── nedb.js            ← Embedded database setup
│   │   └── socket.js          ← WebSocket events
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── sessionController.js
│   │   └── analyticsController.js
│   ├── middleware/
│   │   ├── auth.js            ← JWT protect
│   │   └── errorHandler.js
│   ├── models/               (NeDB — no Mongoose schemas needed)
│   ├── routes/               (7 route files)
│   └── services/
│       ├── fuzzyLogicEngine.js   ← Mamdani FIS implementation
│       └── aiEvaluationService.js ← OpenAI + fallback evaluator
│
└── frontend/
    └── src/
        ├── App.js             ← Routes + auth guards
        ├── context/AuthContext.js
        ├── services/api.js    ← Axios + API helpers
        ├── components/common/Navbar.js
        └── pages/
            ├── LandingPage.js
            ├── LoginPage.js
            ├── RegisterPage.js
            ├── DashboardPage.js
            ├── InterviewSetupPage.js
            ├── InterviewPage.js   ← Live interview + timer
            ├── ResultsPage.js     ← Fuzzy score breakdown
            ├── HistoryPage.js
            ├── AnalyticsPage.js
            └── ProfilePage.js
```

---

## 🔌 API Reference

| Method | Route | Auth | Description |
|--------|-------|------|-------------|
| POST | `/api/auth/register` | No | Register new user |
| POST | `/api/auth/login` | No | Login → JWT token |
| GET | `/api/auth/me` | Yes | Get current user |
| POST | `/api/sessions` | Yes | Create interview session |
| PUT | `/api/sessions/:id/start` | Yes | Start session timer |
| POST | `/api/sessions/:id/answer` | Yes | Submit + evaluate answer |
| PUT | `/api/sessions/:id/complete` | Yes | Finish, calculate final score |
| GET | `/api/sessions` | Yes | Get user's session history |
| GET | `/api/sessions/:id` | Yes | Get session detail |
| GET | `/api/analytics/me` | Yes | Personal analytics + trends |
| GET | `/api/analytics/leaderboard` | Yes | Top performers |
| GET | `/api/questions` | Yes | Browse question bank |
| POST | `/api/questions/generate` | Yes | AI-generate new questions |
| GET | `/api/interviews/config` | Yes | Domains, difficulties, durations |
| GET | `/api/health` | No | Server health check |

---

## ⚙️ Environment Variables (`backend/.env`)

```env
PORT=5000
NODE_ENV=development
JWT_SECRET=any_long_random_string_here
JWT_EXPIRE=30d
OPENAI_API_KEY=            # optional — sk-... from platform.openai.com
FRONTEND_URL=http://localhost:3000
```

The `.env` file is pre-created with safe defaults. You only need to add
your OpenAI key to enable AI-powered question generation and feedback.

---

## 🛠 Available Scripts

From the **root** directory:
```bash
npm run setup     # Install all dependencies (root + backend + frontend)
npm run seed      # Seed database with questions and user accounts
npm run dev       # Start backend (5000) + frontend (3000) concurrently
npm run server    # Start backend only
npm run client    # Start frontend only
```

From **backend/**:
```bash
npm run dev       # nodemon (auto-restart on changes)
npm run seed      # Same as root npm run seed
```

---

## 🧩 Domains Supported

JavaScript · Python · Java · React · Node.js · Data Structures ·
Algorithms · System Design · Database · Machine Learning ·
DevOps · Behavioral · HR · General

---

## 📝 Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 18, React Router v6, Axios, Socket.io-client |
| Backend | Node.js, Express.js, Socket.io |
| Database | **NeDB** (embedded, zero-install, file-based) |
| AI Engine | OpenAI GPT-3.5 (optional) + keyword fallback |
| Fuzzy Logic | Custom Mamdani FIS (pure JS, no library) |
| Auth | JWT + bcryptjs |
