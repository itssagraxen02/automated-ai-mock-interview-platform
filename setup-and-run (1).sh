#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║                                                      ║"
echo "  ║       AI MOCK INTERVIEW PLATFORM — AUTO SETUP       ║"
echo "  ║          MERN Stack + Fuzzy Logic Engine             ║"
echo "  ║                                                      ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}[ERROR] Node.js not found!${NC}"
    echo "Install from: https://nodejs.org (v18+)"
    exit 1
fi
NODE_VER=$(node --version)
echo -e "${GREEN}[OK]${NC} Node.js $NODE_VER"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}[ERROR] npm not found!${NC}"
    exit 1
fi
echo -e "${GREEN}[OK]${NC} npm $(npm --version)"

echo ""
echo -e "${BOLD}[1/4] Installing root dependencies...${NC}"
npm install --silent
[ $? -ne 0 ] && echo -e "${RED}[FAIL] Root install failed${NC}" && exit 1
echo -e "${GREEN}  ✓ Done${NC}"

echo ""
echo -e "${BOLD}[2/4] Installing backend dependencies...${NC}"
cd backend && npm install --silent
[ $? -ne 0 ] && echo -e "${RED}[FAIL] Backend install failed${NC}" && exit 1
echo -e "${GREEN}  ✓ Done${NC}"
cd ..

echo ""
echo -e "${BOLD}[3/4] Installing frontend dependencies...${NC}"
cd frontend && npm install --silent
[ $? -ne 0 ] && echo -e "${RED}[FAIL] Frontend install failed${NC}" && exit 1
echo -e "${GREEN}  ✓ Done${NC}"
cd ..

echo ""
echo -e "${BOLD}[4/4] Seeding database...${NC}"
cd backend && node seeder.js
SEED_STATUS=$?
cd ..
[ $SEED_STATUS -ne 0 ] && echo -e "${YELLOW}[WARN] Seeder issue, continuing...${NC}"

echo ""
echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║                                                      ║"
echo "  ║   ✅ SETUP COMPLETE! Starting servers...            ║"
echo "  ║                                                      ║"
echo "  ║   Backend  : http://localhost:5000                   ║"
echo "  ║   Frontend : http://localhost:3000                   ║"
echo "  ║                                                      ║"
echo "  ║   LOGIN CREDENTIALS:                                 ║"
echo "  ║   Email    : admin@mockinterview.com                 ║"
echo "  ║   Password : Admin@123456                            ║"
echo "  ║                                                      ║"
echo "  ║   Demo User: demo@mockinterview.com                  ║"
echo "  ║   Password : Demo@123456                             ║"
echo "  ║                                                      ║"
echo "  ║   Press Ctrl+C to stop all servers                   ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Stopping servers...${NC}"
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo -e "${GREEN}Servers stopped.${NC}"
    exit 0
}
trap cleanup SIGINT SIGTERM

# Start backend
echo -e "${CYAN}Starting backend on port 5000...${NC}"
cd backend && npm run dev &
BACKEND_PID=$!
cd ..

# Wait for backend
sleep 4

# Start frontend
echo -e "${CYAN}Starting frontend on port 3000...${NC}"
cd frontend && npm start &
FRONTEND_PID=$!
cd ..

# Auto-open browser after delay
sleep 8
if command -v xdg-open &>/dev/null; then
    xdg-open http://localhost:3000 &>/dev/null &
elif command -v open &>/dev/null; then
    open http://localhost:3000 &>/dev/null &
fi

echo -e "\n${GREEN}Both servers running! Press Ctrl+C to stop.${NC}\n"

# Keep alive
wait $BACKEND_PID $FRONTEND_PID
