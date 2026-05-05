#!/usr/bin/env bash
# Build minimal Debian ARM64 rootfs for PION π-1
# Run inside proot-distro debian
set -e

echo "[rootfs] Installing core packages..."
apt update && apt install -y --no-install-recommends \
  python3 python3-pip python3-venv \
  git curl wget ca-certificates \
  nodejs npm \
  openssh-client rsync jq sqlite3 \
  htop nano vim tmux \
  libffi-dev libssl-dev libxml2-dev libxslt1-dev \
  libjpeg-dev zlib1g-dev 2>/dev/null

echo "[rootfs] Installing Python packages..."
pip3 install --break-system-packages \
  flask python-dotenv pydantic tiktoken markdown \
  duckduckgo-search lxml_html_clean beautifulsoup4 html2text \
  nest-asyncio uvicorn python-socketio wsproto \
  openai litellm langchain-core langchain-community \
  faiss-cpu torch --index-url https://download.pytorch.org/whl/cpu \
  sentence-transformers GitPython watchdog psutil \
  paramiko pypdf pymupdf

echo "[rootfs] Installing Node.js globals..."
npm install -g http-server pm2 typescript

echo "[rootfs] Cloning Agent Zero..."
cd ~ && git clone https://github.com/agent0ai/agent-zero.git
cd agent-zero && python3 -m venv .venv && source .venv/bin/activate && \
  pip install -r requirements.txt || true

echo "[rootfs] ✅ Done"
