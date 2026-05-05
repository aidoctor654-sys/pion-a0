#!/data/data/com.termux/files/usr/bin/bash
echo "═══════════════════════════════════"
echo "  PION π-1 · Status"
echo "═══════════════════════════════════"
echo ""
echo -n "  Wrapper API :8423  → " && curl -s http://localhost:8423/ping 2>/dev/null || echo "OFFLINE"
echo -n "  Hermes Body :8422  → " && curl -s -o /dev/null -w "%{http_code}" http://localhost:8422 2>/dev/null || echo "OFFLINE"
echo ""
echo -n "  Agent Zero  :8421  → "
A0=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8421 2>/dev/null)
if [ "$A0" = "200" ] || [ "$A0" = "404" ]; then echo "ONLINE"; else echo "OFFLINE"; fi
echo ""
echo "  Disk:"
df -h /data 2>/dev/null | tail -1
echo ""
echo "  Debian proot:"
ls /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root/agent-zero/agent.py >/dev/null 2>&1 && echo "  ✅ Agent Zero installed" || echo "  ❌ Agent Zero not found"
proot-distro list 2>/dev/null | grep debian && echo "  ✅ Debian" || echo "  ❌ Debian"
echo "═══════════════════════════════════"
