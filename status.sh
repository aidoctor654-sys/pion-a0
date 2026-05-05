#!/data/data/com.termux/files/usr/bin/bash
PORT="${1:-8421}"
echo "=== PION π-1 Status ==="
echo "  proot Debian: $(proot-distro login debian -- bash -c 'uname -m' 2>/dev/null || echo 'not running')"
echo "  Python: $(proot-distro login debian -- bash -c 'source ~/agent-zero/.venv/bin/activate && python3 --version' 2>/dev/null || echo 'not found')"
echo "  Agent Zero: $(proot-distro login debian -- bash -c 'ls ~/agent-zero/agent.py' 2>/dev/null || echo 'not found')"
echo "  Port $PORT: $(curl -s -o /dev/null -w '%{http_code}' http://localhost:$PORT 2>/dev/null || echo 'not responding')"
