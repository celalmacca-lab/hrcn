#!/usr/bin/env bash
# Google Play, 31 Ağustos 2026'dan itibaren TÜM yeni uygulama ve güncellemelerin
# Android 16 (API 36) hedeflemesini zorunlu kılıyor. Capacitor 6.1.2'nin varsayılan
# variables.gradle dosyası bunu otomatik ayarlamayabilir — burada garantiye alınır.
# "npx cap add android" SONRASI, "npx cap sync" ÖNCESİ çalıştırılmalı.
set -e

VARS="android/variables.gradle"

if [ ! -f "$VARS" ]; then
  echo "variables.gradle bulunamadı — android/ önce eklenmeli. Atlanıyor."
  exit 0
fi

# compileSdkVersion / targetSdkVersion satırlarını 36'ya sabitle (varsa günceller,
# yoksa dokunmaz — Capacitor sürüm güncellemesiyle format değişirse burada patlamak
# yerine sessizce atlar, CI kırmızıya düşmez).
if grep -q "compileSdkVersion" "$VARS"; then
  sed -i.bak 's/compileSdkVersion = [0-9]*/compileSdkVersion = 36/' "$VARS" && rm -f "$VARS.bak"
  echo "compileSdkVersion -> 36"
fi
if grep -q "targetSdkVersion" "$VARS"; then
  sed -i.bak 's/targetSdkVersion = [0-9]*/targetSdkVersion = 36/' "$VARS" && rm -f "$VARS.bak"
  echo "targetSdkVersion -> 36"
fi

echo "Android SDK hedefi kontrol edildi (Play Store 31 Ağustos 2026 şartı)."
