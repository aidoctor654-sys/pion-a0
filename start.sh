#!/data/data/com.termux/files/usr/bin/bash
# ╔══════════════════════════════════════════════╗
# ║  PION π-1 · Start All Services               ║
# ╚══════════════════════════════════════════════╝

echo "[PION] Starting PION π-1..."

# Kill existing
pkill -f "wrapper.py" 2>/dev/null
pkill -f "python3.*8423" 2>/dev/null

# Start Wrapper API on 8423
python3 ~/pion-a0/hermes-body/wrapper.py &
WRAPPER_PID=$!
echo "[PION] Wrapper API on :8423 (PID: $WRAPPER_PID)"

# Start Hermes Body PION on 8422 (if not already running)
if ! curl -s http://localhost:8422/ping >/dev/null 2>&1; then
    echo "[PION] Waiting for PION on :8422..."
fi

# Start Agent Zero in proot Debian
echo "[PION] Starting Agent Zero in proot Debian..."
proot-distro login debian -- bash -c "
  cd ~/agent-zero && source .venv/bin/activate && mkdir -p usr
  export WEB_UI_HOST=0.0.0.0
  export WEB_UI_PORT=8421
  python3 run_ui.py
" &
A0_PID=$!
echo "[PION] Agent Zero on :8421 (PID: $A0_PID)"

echo ""
echo "[PION] ════════════════════════════════"
echo "[PION] PION π-1 is running!"
echo "[PION]   Wrapper API:  http://localhost:8423"
echo "[PION]   Hermes Body:  http://localhost:8422"
echo "[PION]   Agent Zero:   http://localhost:8421"
echo "[PION] ════════════════════════════════"
