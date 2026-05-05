#!/usr/bin/env python3
"""PION π-1 · Wrapper API · Sync shell + proot Debian bridge"""
import os, subprocess, json, threading
from http.server import HTTPServer, BaseHTTPRequestHandler

PORT = int(os.environ.get('PORT', '8423'))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        routes = {
            '/ping': lambda: {'status':'ok','service':'pion-a0-wrapper'},
            '/api/device': lambda: {'model':'SM-G991B','arch':'aarch64','os':'debian-proot','status':'alive'},
            '/api/status': lambda: self.get_status(),
        }
        if self.path in routes:
            self.json_resp(routes[self.path]())
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path == '/api/shell':
            body = json.loads(self.rfile.read(int(self.headers.get('Content-Length',0))))
            cmd = body.get('cmd','')
            mode = body.get('mode','termux')  # termux or proot
            if mode == 'proot':
                cmd = f'proot-distro login debian -- bash -c {json.dumps(cmd)}'
            try:
                r = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
                self.json_resp({'status':'ok','output':r.stdout+r.stderr,'code':r.returncode})
            except subprocess.TimeoutExpired:
                self.json_resp({'status':'timeout','output':'Command timed out (30s)'})
            except Exception as e:
                self.json_resp({'status':'error','output':str(e)})

    def get_status(self):
        return {
            'proot': self._check('proot-distro login debian -- bash -c "echo OK"'),
            'python': self._check('proot-distro login debian -- bash -c "source ~/agent-zero/.venv/bin/activate && python3 -c \\"import flask; print(flash.__version__)\\""'),
            'torch': self._check('proot-distro login debian -- bash -c "source ~/agent-zero/.venv/bin/activate && python3 -c \\"import torch; print(torch.__version__)\\""'),
            'node': self._check('proot-distro login debian -- bash -c "node --version"'),
            'a0': os.path.exists('/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root/agent-zero/agent.py'),
            'disk': self._disk(),
        }

    def _check(self, cmd):
        try:
            r = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=10)
            return r.stdout.strip() if r.returncode == 0 else f'error: {r.stderr.strip()[:100]}'
        except: return 'error'

    def _disk(self):
        try:
            r = subprocess.run('df -h /data', shell=True, capture_output=True, text=True)
            return r.stdout.strip()
        except: return 'unknown'

    def json_resp(self, data):
        self.send_response(200)
        self.send_header('Content-Type','application/json')
        self.send_header('Access-Control-Allow-Origin','*')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def log_message(self, *a): pass

if __name__ == '__main__':
    print(f'[PION] Wrapper API on 0.0.0.0:{PORT}')
    HTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
