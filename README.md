# Harcana — Telefona Kurulabilir APK & Play Store Kılavuzu

**Harcana**, gelir/gider/abonelik/borç/yatırım/hedef yönetimi yapan, tek dosyalık (`www/index.html`),
%100 yerel (veri yalnızca cihazda `localStorage`'da) bir finans uygulamasıdır. Bu klasör onu bir
Android uygulamasına (APK) dönüştürmek için her şeyi içerir.

> Bu klasörde hazır `.apk` yok — çünkü imzalı APK derlemek Android SDK + Gradle ister.
> Aşağıdaki 3 yoldan biriyle APK'yı 5-10 dakikada, hiç yerel kurulum yapmadan alabilirsin.
> Uygulama tamamen offline çalışacak şekilde paketlendi: grafik/excel/QR kütüphaneleri APK'nın içine gömülür (YOL 1 ve YOL 3 bunu otomatik/elle yapar), açılışta hiçbir uzak sunucuya bağlanılmaz — bu yüzden "yükleniyor" ekranında takılma olmaz.


---

## YOL 1 — GitHub ile bulutta otomatik APK (ONERILEN)

ÇOK ÖNEMLI: Dosyalar repo'nun KOK dizininde olmali. Yani repo'ya girince ilk ekranda
`package.json`, `www`, `.github` KLASORLERINI dogrudan gormelisin. Eger her sey
`harcana/` diye tek bir alt klasorun icindeyse Actions CALISMAZ.

Ayrica: zip dosyasinin KENDISINI repoya yukleme. Once bilgisayarinda ac/cikar,
sonra ICINDEKI dosyalari yukle.

Repo kokunde olmasi gereken yapi:

    senin-repon/
    |- .github/workflows/build-apk.yml   <- bu olmazsa Actions calismaz
    |- www/
    |- scripts/
    |- capacitor.config.json
    |- package.json
    |- README.md

Adimlar:
1. github.com'da yeni repo olustur (Public en kolayi; Private de olur).
2. Repo sayfasinda "Add file" -> "Upload files".
3. Bu zip'i cikardiktan sonra ICINDEKI tum dosya ve klasorleri (gizli `.github` dahil)
   pencereye SURUKLE. Tek bir `harcana` klasoru degil, onun ICINDEKILER.
4. Asagida "Commit changes" de. Push olur olmaz Actions otomatik baslar.
5. Ust menude "Actions" sekmesine gec -> "APK Derle" calismasini ac -> bitmesini bekle (~4-6 dk).
6. Calisma sayfasinin en altinda "Artifacts" -> "harcana-apk" indir -> icinden app-debug.apk cikar.
7. APK'yi telefona at, "bilinmeyen kaynaklara izin ver" deyip kur.

Actions sekmesinde hicbir calisma gorunmuyorsa: dosyalar alt klasorde kalmistir
(adim "COK ONEMLI" notuna bak) ya da repo'da Actions kapalidir (Settings -> Actions -> "Allow all").

Kirmizi (X) ile basarisiz olursa: o calismaya tikla, hangi adimda patladigini gor.
Cogu zaman internet/CDN gecici hatasidir; sag ustten "Re-run jobs" ile tekrar dene.

## YOL 2 — PWABuilder (Android Studio yok, bir web adresi gerekir)

1. `www/` klasörünü ücretsiz bir statik hostinge yükle (GitHub Pages / Netlify / Vercel).
2. https://www.pwabuilder.com -> siteni gir -> Package for stores -> Android.
3. İmzalı `.apk` / `.aab` üretir, indir ve kur.

---

## YOL 3 — Kendi bilgisayarında (Android Studio ile)

Gerekli: Node.js 18+, Android Studio (SDK dahil), Java JDK 17.

    cd harcana
    npm install
    npm run vendor        # kütüphaneleri offline gömer (uzak sunucu bağımlılığını kaldırır)
    npx cap add android
    npx capacitor-assets generate --iconBackgroundColor '#070811' --splashBackgroundColor '#070811'
    npx cap sync
    npx cap open android

Android Studio'da: `android/variables.gradle` icinde targetSdkVersion = 36 ve compileSdkVersion = 36
yap -> Build -> Generate Signed Bundle / APK. Kendi imza anahtarini (keystore) olustur ve KAYBETME.
capacitor.config.json icindeki "appId" (tr.cepac.harcana) sana ait benzersiz bir deger olsun.

---

## Klasor Icerigi

    harcana/
    |- www/                       Uygulama (APK icine gomulur)
    |  |- index.html              Tum uygulama (tek dosya)
    |  |- manifest.webmanifest    PWA manifesti
    |  |- service-worker.js       Offline onbellek
    |  |- icons/                  Premium "H" ikon seti
    |- resources/                 Ikon + splash kaynagi (1024 / 2732)
    |- .github/workflows/         Bulutta APK derleyen is akisi (YOL 1)
    |- capacitor.config.json
    |- package.json
    |- PRIVACY.md                 Gizlilik politikasi sablonu
    |- README.md

---

## Ucretsiz Yapay Zeka Hakkinda
Uygulamadaki "Akilli Finans Analizi" UCRETSIZ AI kullanir:
- Varsayilan: anahtarsiz ucretsiz servis (Pollinations) - hicbir kurulum gerekmez.
- Istersen Ayarlar'a kendi ucretsiz Gemini API anahtarini girersin (daha kaliteli yanit). Anahtar yalnizca senin cihazinda saklanir.
- AI'ya YALNIZCA ozet rakamlar (aylik gelir/gider, tasarruf orani, en cok harcanan kategori) gider; tek tek islemler, isimler veya aciklamalar ASLA gonderilmez.
- Servise ulasilamazsa otomatik olarak cihazda calisan kural tabanli analiz devreye girer.

---

## Google Play'e Yukleme (ozet)
1. play.google.com/console -> tek seferlik 25 USD kayit.
2. Yeni kisisel hesap (13 Kasim 2023 sonrasi) isen: production'dan once 12 test kullanicisi, 14 gun kesintisiz kapali test zorunlu. Kurumsal hesaplar muaf.
3. Hedef API 36 / Android 16 (31 Agustos 2026 sonrasi sart - is akisi bunu otomatik ayarlar).
4. Data safety formunda: veri cihazda tutulur; AI ozelligi yalnizca ozet rakami ucretsiz servise gonderir - bunu beyan et.
5. PRIVACY.md'yi bir web sayfasina koyup linkini gir.
6. .aab yukle (YOL 3 ile uret) -> closed testing -> 14 gun -> production.
