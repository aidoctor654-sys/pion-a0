// PION π-1 · Hermes Body · Terminal + API
const WS_URL = `ws://${location.host}/ws`;
const API_URL = '/api';

const out = document.getElementById('out');
const cmd = document.getElementById('cmd');

function log(text, cls='d') {
  const d = document.createElement('div');
  d.className = cls;
  d.textContent = text;
  out.appendChild(d);
  out.scrollTop = out.scrollHeight;
}

async function api(path, opts) {
  try {
    const r = await fetch(API + path, opts);
    return await r.text();
  } catch(e) { return e.message; }
}

async function run() {
  const c = cmd.value.trim();
  if (!c) return;
  log('$ ' + c, 'i');
  cmd.value = '';
  const r = await api('/shell', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({cmd: c})
  });
  try { log(JSON.parse(r).output || r); }
  catch { log(r); }
}

async function device() {
  log('--- device ---', 'w');
  const r = await api('/device');
  try { const d = JSON.parse(r); Object.entries(d).forEach(([k,v]) => log(`${k}: ${v}`, 'd')); }
  catch { log(r, 'd'); }
}

cmd.addEventListener('keydown', e => { if (e.key === 'Enter') run(); });
log('PION π-1', 'i');
log('hermes-body · terminal + api', 'd');
