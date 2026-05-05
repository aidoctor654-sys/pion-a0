#!/data/data/com.termux/files/usr/bin/bash
# PION π-1 · Start Agent Zero
PORT="${1:-8421}"
echo "[PION] Starting Agent Zero on port $PORT..."
proot-distro login debian -- bash -c "
  cd ~/agent-zero
  source .venv/bin/activate
  mkdir -p usr
  export WEB_UI_HOST=0.0.0.0
  export WEB_UI_PORT=$PORT
  python3 run_ui.py
"
