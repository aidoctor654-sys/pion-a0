#!/data/data/com.termux/files/usr/bin/bash
echo "[PION] Stopping..."
pkill -f "wrapper.py" 2>/dev/null
pkill -f "python3.*8423" 2>/dev/null
pkill -f "run_ui.py" 2>/dev/null
echo "[PION] All stopped."
