#!/usr/bin/env bash
# Google Play, TÜM yeni uygulama ve güncellemelerin en az API 35 hedeflemesini
# zorunlu kılıyor. Ayrıca her yüklemede versionCode benzersiz ve artan olmalı.
# "npx cap add android" SONRASI, "npx cap sync" ÖNCESİ çalıştırılmalı.
set -e
 
VARS="android/variables.gradle"
BUILD_GRADLE="android/app/build.gradle"
 
# ---- SDK hedefini 36'ya sabitle ----
if [ -f "$VARS" ]; then
  if grep -q "compileSdkVersion" "$VARS"; then
    sed -i.bak 's/compileSdkVersion = [0-9]*/compileSdkVersion = 36/' "$VARS" && rm -f "$VARS.bak"
    echo "compileSdkVersion -> 36"
  fi
  if grep -q "targetSdkVersion" "$VARS"; then
    sed -i.bak 's/targetSdkVersion = [0-9]*/targetSdkVersion = 36/' "$VARS" && rm -f "$VARS.bak"
    echo "targetSdkVersion -> 36"
  fi
else
  echo "variables.gradle bulunamadı — SDK yaması atlandı."
fi
 
# ---- versionCode'u benzersiz ve artan yap ----
# GitHub build numarasını kullan (her build otomatik artar, çakışma olmaz).
# Eğer GITHUB_RUN_NUMBER yoksa (yerel), varsayılan 2 kullan.
VCODE="${GITHUB_RUN_NUMBER:-2}"
# Play Store'da 1 zaten kullanildi; en az 2 olmali. Guvenlik icin +1.
VCODE=$((VCODE + 1))
 
if [ -f "$BUILD_GRADLE" ]; then
  if grep -q "versionCode" "$BUILD_GRADLE"; then
    sed -i.bak "s/versionCode [0-9]*/versionCode $VCODE/" "$BUILD_GRADLE" && rm -f "$BUILD_GRADLE.bak"
    echo "versionCode -> $VCODE"
  fi
  if grep -q "versionName" "$BUILD_GRADLE"; then
    sed -i.bak "s/versionName \"[^\"]*\"/versionName \"1.0.$VCODE\"/" "$BUILD_GRADLE" && rm -f "$BUILD_GRADLE.bak"
    echo "versionName -> 1.0.$VCODE"
  fi
else
  echo "build.gradle bulunamadı — versionCode yaması atlandı."
fi
 
echo "Android yaması tamamlandı (SDK 36 + versionCode $VCODE)."
 






