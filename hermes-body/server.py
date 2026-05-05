#!/usr/bin/env python3
"""PION pi-1 · Hermes Body · Minimal API server"""
import os, subprocess, json, asyncio
from http.server import HTTPServer, BaseHTTPRequestHandler

PORT = int(os.environ.get('PORT', '8421'))
BIND = os.environ.get('HOST', '0.0.0.0')

class PionHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/' or self.path == '/index.html':
            self.send_response(200)
            self.send_header('Content-Type', 'text/html')
            self.end_headers()
            with open(os.path.join(os.path.dirname(__file__), 'index.html'), 'rb') as f:
                self.wfile.write(f.read())
        elif self.path == '/api/device':
            self.json_response(self.get_device())
        elif self.path == '/app.js':
            self.send_response(200)
            self.send_header('Content-Type', 'application/javascript')
            self.end_headers()
            with open(os.path.join(os.path.dirname(__file__), 'app.js'), 'rb') as f:
                self.wfile.write(f.read())
        elif self.path == '/style.css':
            self.send_response(200)
            self.send_header('Content-Type', 'text/css')
            self.end_headers()
            with open(os.path.join(os.path.dirname(__file__), 'style.css'), 'rb') as f:
                self.wfile.write(f.read())
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path == '/api/shell':
            length = int(self.headers.get('Content-Length', 0))
            body = json.loads(self.rfile.read(length))
            cmd = body.get('cmd', '')
            try:
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
                self.json_response({
                    'status': 'ok',
                    'output': result.stdout + result.stderr,
                    'code': result.returncode
                })
            except Exception as e:
                self.json_response({'status': 'error', 'output': str(e)})

    def json_response(self, data):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def get_device(self):
        info = {}
        for k in ['model', 'device', 'brand', 'product', 'hardware']:
            try:
                with open(f'/system/build.prop') as f:
                    for line in f:
                        if f'ro.{k}' in line:
                            info[k] = line.split('=',1)[1].strip()
            except: pass
        info['status'] = 'alive'
        return info

    def log_message(self, fmt, *args): pass

if __name__ == '__main__':
    print(f'[PION] Hermes Body on {BIND}:{PORT}')
    HTTPServer((BIND, PORT), PionHandler).serve_forever()
