#!/data/data/com.termux/files/usr/bin/bash
echo "[PION] Stopping Agent Zero..."
proot-distro login debian -- bash -c "pkill -f run_ui.py 2>/dev/null" || true
echo "[PION] Stopped."
