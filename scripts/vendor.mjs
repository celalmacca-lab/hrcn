// Kütüphaneleri www/lib içine indirir → APK tamamen offline, uzak sunucu bağımlılığı YOK.
// Node 18+ gereklidir (global fetch). Kullanım: npm run vendor
import { writeFileSync, mkdirSync } from 'node:fs';
const libs = {
  'chart.umd.min.js': 'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js',
  'xlsx.full.min.js': 'https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js',
  'peerjs.min.js':    'https://cdn.jsdelivr.net/npm/peerjs@1.5.4/dist/peerjs.min.js',
  'qrcode.js':        'https://cdn.jsdelivr.net/npm/qrcode-generator@1.4.4/qrcode.js',
};
mkdirSync('www/lib', { recursive: true });
for (const [file, url] of Object.entries(libs)) {
  const r = await fetch(url);
  if (!r.ok) throw new Error('İndirilemedi: ' + url + ' (' + r.status + ')');
  writeFileSync('www/lib/' + file, Buffer.from(await r.arrayBuffer()));
  console.log('✓ gömüldü: www/lib/' + file);
}
console.log('Tüm kütüphaneler yerelleştirildi — uygulama artık offline çalışır.');
