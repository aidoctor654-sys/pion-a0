# PION π-1

**Agent Zero on Android** · proot Debian ARM64 · autonomous AI container

No Docker. No QEMU. Native ARM. One command.

## Quick Start (Termux)

```bash
# Install
curl -fsSL https://raw.githubusercontent.com/aidoctor654-sys/pion-a0/main/install.sh | bash

# Run
~/pion-a0/start.sh

# Status
~/pion-a0/status.sh

# Stop
~/pion-a0/stop.sh
```

## What You Get

- Debian ARM64 via proot (native speed, no emulation)
- Python 3.13 + Agent Zero + all dependencies
- Node.js 22 + npm
- Hermes Body web UI (terminal + device API)
- Auto-start on boot

## Stack

| Component | Version |
|-----------|---------|
| Debian | 13 (trixie) ARM64 |
| Python | 3.13 |
| PyTorch | 2.11 (CPU) |
| Node.js | 22 |
| Agent Zero | latest |

## Architecture

```
Android → Termux → proot-distro → Debian ARM64
                                  → Agent Zero (Python)
                                  → Hermes Body (Web UI)
                                  → Node.js tools
```

No QEMU. No x86 emulation. Pure ARM64 native.

## APK Build

GitHub Actions builds the APK automatically on push to `main`.

The APK wraps:
- WebView (loads Hermes Body UI)
- Foreground service (keeps proot + Agent Zero alive)
- Boot receiver (auto-start on device boot)

## Ports

| Port | Service |
|------|---------|
| 8421 | Agent Zero Web UI |
| 8422 | Hermes Body API |
