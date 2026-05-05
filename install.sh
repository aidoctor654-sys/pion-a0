#!/usr/bin/env bash
set -e

echo "╔══════════════════════════════════════════════╗"
echo "║  PION π-1 · Agent Zero on Android            ║"
echo "║  proot Debian ARM64 · autonomous AI          ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Check Termux
if [ -z "$TERMUX_VERSION" ]; then
  echo "[!] Requires Termux"; exit 1
fi
echo "[✓] Termux detected"

# Install proot-distro
pkg install proot-distro -y

# Install Debian
echo "[→] Installing Debian ARM64..."
proot-distro install debian

# System deps
echo "[→] Installing system packages...")
proot-distro login debian -- bash -c "
  apt update && apt install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    git curl wget build-essential \
    libffi-dev libssl-dev libxml2-dev libxslt1-dev \
    libjpeg-dev zlib1g-dev libsqlite3-dev \
    libmagic1 ffmpeg poppler-utils tesseract-ocr \
    openssh-client rsync jq sqlite3 htop nano vim tmux
"

# Node.js
echo "[→] Installing Node.js 22..."
proot-distro login debian -- bash -c "
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt install -y nodejs
  npm install -g http-server pm2 typescript ts-node
"

# Agent Zero
echo "[→] Cloning Agent Zero..."
proot-distro login debian -- bash -c "
  cd ~ && git clone https://github.com/agent0ai/agent-zero.git
"

# Python deps
echo "[→] Installing Python deps (this takes a while)..."
proot-distro login debian -- bash -c "
  cd ~/agent-zero && python3 -m venv .venv && source .venv/bin/activate
  pip install --upgrade pip setuptools wheel
  pip install flask python-dotenv pydantic tiktoken markdown \
    duckduckgo-search lxml_html_clean beautifulsoup4 html2text \
    nest-asyncio uvicorn python-socketio wsproto \
    openai litellm langchain-core langchain-community \
    faiss-cpu torch --index-url https://download.pytorch.org/whl/cpu \
    sentence-transformers GitPython watchdog psutil paramiko pypdf pymupdf
"

# Config
echo "[→] Configuring..."
proot-distro login debian -- bash -c "
  mkdir -p ~/agent-zero/usr
  cat > ~/agent-zero/usr/.env << 'ENV'
WEB_UI_HOST=0.0.0.0
WEB_UI_PORT=8421
AUTH_LOGIN=admin
AUTH_PASSWORD=pion
ENV
"

echo ""
echo "[✓] PION π-1 installed!"
echo "  Run:  ~/pion-a0/start.sh"
echo "  Web:  http://localhost:8421"
