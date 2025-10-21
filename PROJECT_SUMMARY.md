# Sublima WebView - Progetto Completo

## 📁 Struttura Creata

```
/home/vete/W/sublima_webview/
│
├── lib/                                    # Codice Dart/Flutter
│   ├── main.dart                           # Entry point + splash screen
│   ├── screens/
│   │   ├── setup_screen.dart               # Schermata configurazione URL
│   │   └── webview_screen.dart             # WebView principale fullscreen
│   └── services/
│       └── storage_service.dart            # Gestione storage persistente
│
├── android/                                # Configurazione Android
│   └── app/src/main/
│       ├── AndroidManifest.xml             # Manifest con Mixed Content abilitato
│       └── res/xml/
│           └── network_security_config.xml # Policy rete (HTTP permesso)
│
├── ios/                                    # Configurazione iOS
│   └── Runner/
│       └── Info.plist                      # Plist con NSAppTransportSecurity
│
├── assets/                                 # Risorse app (icone, immagini)
│
├── pubspec.yaml                            # Dipendenze Flutter
├── .gitignore                              # Git ignore rules
│
├── README.md                               # Documentazione completa
├── QUICKSTART.md                           # Guida rapida comandi
├── INSTALL_FLUTTER.md                      # Guida installazione Flutter
└── setup.sh                                # Script setup automatico
```

## ✅ Caratteristiche Implementate

### 🔒 Mixed Content (HTTPS → HTTP)
- ✅ Android: `usesCleartextTraffic="true"` + `network_security_config.xml`
- ✅ iOS: `NSAppTransportSecurity` con `NSAllowsArbitraryLoads`
- ✅ Permette comunicazione Sublima Cloud (HTTPS) → ZERO Esterno (HTTP)

### 📱 UI Fullscreen
- ✅ Splash screen con verifica configurazione
- ✅ Setup screen con input URL e validazione
- ✅ WebView screen fullscreen con toolbar minimale
- ✅ Progress bar caricamento
- ✅ Gestione errori con snackbar
- ✅ Menu opzioni (reload, home, cache, reset)

### 💾 Storage Persistente
- ✅ Salvataggio URL profilo con `shared_preferences`
- ✅ Verifica configurazione esistente all'avvio
- ✅ Reset configurazione da menu

### 🌐 WebView Avanzato
- ✅ JavaScript abilitato
- ✅ DOM Storage (localStorage, sessionStorage)
- ✅ Cache abilitata
- ✅ Gestione history (back button funzionale)
- ✅ User agent personalizzato
- ✅ Supporto zoom
- ✅ Media autoplay
- ✅ Geolocation support

### 🔧 Developer Experience
- ✅ Codice commentato e documentato
- ✅ Validazione form URL
- ✅ Error handling completo
- ✅ Hot-reload friendly
- ✅ Script setup automatico

## 🚀 Come Iniziare

### Opzione 1: Setup Automatico (Raccomandato)

```bash
cd /home/vete/W/sublima_webview
./setup.sh
```

### Opzione 2: Setup Manuale

```bash
cd /home/vete/W/sublima_webview

# 1. Verifica Flutter installato
flutter --version
# Se non installato, segui INSTALL_FLUTTER.md

# 2. Installa dipendenze
flutter pub get

# 3. Verifica ambiente
flutter doctor -v

# 4. Lista dispositivi disponibili
flutter devices

# 5. Run su dispositivo
flutter run
```

## 📦 Build Release

### Android APK

```bash
flutter build apk --release --split-per-abi
```

**Output:**
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (~20 MB)
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (~18 MB)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (~22 MB)

### Android App Bundle (Google Play)

```bash
flutter build appbundle --release
```

**Output:** `build/app/outputs/bundle/release/app-release.aab`

### iOS (richiede Mac + Xcode)

```bash
flutter build ipa --release
```

**Output:** `build/ios/ipa/sublima_webview.ipa`

### Windows

```bash
flutter build windows --release
```

**Output:** `build/windows/runner/Release/` (cartella con eseguibile + DLL)

## 🎨 Personalizzazioni

### Nome App

**Android:** `android/app/src/main/AndroidManifest.xml`
```xml
android:label="Sublima WebView"
```

**iOS:** `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Sublima WebView</string>
```

### Colore Tema

**File:** `lib/main.dart` (linea ~23)
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue.shade700,  // Cambia qui
  brightness: Brightness.light,
),
```

### Icona App

1. Prepara icona 1024x1024 PNG
2. Usa: https://icon.kitchen o https://appicon.co
3. Sostituisci file in:
   - `android/app/src/main/res/mipmap-*/`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### URL Default

**File:** `lib/screens/setup_screen.dart` (linea ~70)
```dart
hintText: 'es. cloud.sublima.it/profilo/s1087',
```

## 🧪 Testing

### Test su Chrome (solo UI, NO Mixed Content)

```bash
flutter run -d chrome
```

**Nota:** Chrome blocca Mixed Content, quindi ZERO Esterno non funzionerà.

### Test su Emulatore Android

```bash
# Lista emulatori
flutter emulators

# Avvia emulatore
flutter emulators --launch Pixel_5_API_33

# Run app
flutter run
```

### Test su Dispositivo Reale Android

1. Abilita Developer Options sul dispositivo
2. Abilita USB Debugging
3. Collega via USB
4. Verifica: `flutter devices`
5. Run: `flutter run`

### Verifica Mixed Content

1. Build APK release
2. Installa su dispositivo
3. Configura URL Sublima Cloud (HTTPS)
4. Verifica che stampe ZERO Esterno (HTTP) funzionino

## 📚 Documentazione

- **README.md** - Guida completa con troubleshooting
- **QUICKSTART.md** - Comandi essenziali e workflow
- **INSTALL_FLUTTER.md** - Guida installazione Flutter dettagliata
- **MD_files/WEBVIEW_ANALYSIS.md** - Analisi opzioni e architettura

## 🔍 Prossimi Passi Suggeriti

### Immediati (Setup Iniziale)

1. ✅ Installa Flutter SDK (vedi `INSTALL_FLUTTER.md`)
2. ✅ Run setup script: `./setup.sh`
3. ✅ Test su emulatore: `flutter run`
4. ✅ Build APK test: `flutter build apk --release`

### Short-term (Personalizzazione)

1. 🎨 Personalizza colori tema
2. 🖼️ Crea/sostituisci icona app
3. 📝 Aggiorna nome app in manifest
4. 🧪 Test approfondito su dispositivi reali
5. 📊 Test comunicazione con ZERO Esterno

### Long-term (Produzione)

1. 📱 Setup firma codice Android (keystore)
2. 🍎 Setup certificati iOS (Apple Developer)
3. 🏪 Pubblicazione Google Play Store (opzionale)
4. 🍎 Pubblicazione Apple App Store (opzionale)
5. 📦 Sistema distribuzione diretta APK (più semplice)
6. 🔄 Pipeline CI/CD per build automatiche

## ⚙️ Configurazioni Avanzate (Opzionali)

### Firma APK Android (per distribuzione)

```bash
# Genera keystore
keytool -genkey -v -keystore ~/sublima-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias sublima

# Configura in android/app/build.gradle
# Vedi: https://docs.flutter.dev/deployment/android#signing-the-app
```

### App Store / Play Store

- **Google Play**: Account developer $25 una tantum
- **Apple App Store**: Account developer $99/anno + Mac + Xcode

### Analytics (opzionale)

Aggiungi Firebase Analytics:
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.15.0
  firebase_analytics: ^10.4.5
```

## 🐛 Troubleshooting Comuni

### Flutter non trovato

```bash
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Android build fallisce

```bash
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build apk --release
```

### iOS build fallisce (macOS)

```bash
cd ios
pod install
cd ..
flutter clean
flutter build ios --release
```

### WebView non carica pagina

Verifica:
1. ✅ Connessione Internet attiva
2. ✅ URL corretto (include https://)
3. ✅ Mixed Content configurato correttamente
4. ✅ Permessi Internet in AndroidManifest.xml

### Mixed Content ancora bloccato

**Android:** Verifica `android:usesCleartextTraffic="true"` in AndroidManifest.xml

**iOS:** Verifica `NSAllowsArbitraryLoads` in Info.plist

## 📞 Supporto

- **Email**: support@sublima.it
- **Documentazione Flutter**: https://docs.flutter.dev
- **Plugin WebView**: https://pub.dev/packages/flutter_inappwebview

## 📄 Licenza

Proprietario - Sublima ERP © 2025

---

**Progetto creato il:** 21 ottobre 2025
**Versione:** 1.0.0
**Framework:** Flutter 3.x + Dart 3.x
**Piattaforme supportate:** Android, iOS, Windows
