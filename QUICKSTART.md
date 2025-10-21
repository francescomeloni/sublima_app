# Sublima WebView - Quick Start

## Setup Veloce (Linux)

```bash
cd /home/vete/W/sublima_webview

# 1. Rendi eseguibile lo script di setup
chmod +x setup.sh

# 2. Esegui setup
./setup.sh

# 3. Se Flutter non è installato, segui INSTALL_FLUTTER.md
```

## Comandi Essenziali

### Sviluppo

```bash
# Verifica ambiente
flutter doctor -v

# Installa/aggiorna dipendenze
flutter pub get

# Lista dispositivi disponibili
flutter devices

# Run su dispositivo (seleziona automaticamente)
flutter run

# Run su dispositivo specifico
flutter run -d <device-id>

# Run con hot-reload (premi 'r' per reload, 'R' per restart)
flutter run

# Test veloce su Chrome (NO Mixed Content, solo UI)
flutter run -d chrome
```

### Build Release

```bash
# Android APK (distribuzione diretta)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Android App Bundle (Google Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab

# iOS (richiede Mac + Xcode + Apple Developer Account)
flutter build ipa --release
# Output: build/ios/ipa/sublima_webview.ipa

# Windows
flutter build windows --release
# Output: build/windows/runner/Release/
```

### Debug & Troubleshooting

```bash
# Pulisci cache build
flutter clean

# Reinstalla dipendenze
flutter pub get

# Analizza codice (lint, errori)
flutter analyze

# Verifica dipendenze obsolete
flutter pub outdated

# Aggiorna dipendenze
flutter pub upgrade
```

## Workflow Tipico

### Prima volta

1. **Installa Flutter** (vedi `INSTALL_FLUTTER.md`)
2. **Setup progetto**:
   ```bash
   cd /home/vete/W/sublima_webview
   flutter pub get
   ```
3. **Verifica ambiente**:
   ```bash
   flutter doctor -v
   ```
4. **Avvia emulatore** o collega dispositivo
5. **Run app**:
   ```bash
   flutter run
   ```

### Sviluppo iterativo

1. **Modifica codice** in `lib/`
2. **Hot reload**: App in esecuzione → premi `r` nel terminale
3. **Test**: Verifica modifiche su dispositivo
4. **Repeat**

### Build finale

```bash
# Android
flutter build apk --release --split-per-abi

# Distribuisci APK trovato in:
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (32-bit)
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (64-bit)
# build/app/outputs/flutter-apk/app-x86_64-release.apk (emulatori)
```

## Struttura File Chiave

```
sublima_webview/
├── lib/
│   ├── main.dart                    # ← ENTRY POINT
│   ├── screens/
│   │   ├── setup_screen.dart        # ← Setup URL profilo
│   │   └── webview_screen.dart      # ← WebView principale
│   └── services/
│       └── storage_service.dart     # ← Storage URL
├── pubspec.yaml                     # ← Dipendenze e config
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml      # ← Config Android (Mixed Content)
│       └── res/xml/network_security_config.xml
├── ios/
│   └── Runner/
│       └── Info.plist               # ← Config iOS (Mixed Content)
└── README.md                        # ← Documentazione completa
```

## Personalizzazioni Comuni

### Cambia nome app

**File:** `pubspec.yaml`
```yaml
name: sublima_webview  # ← Nome pacchetto (non modificare dopo build)
description: La tua descrizione
```

**File:** `android/app/src/main/AndroidManifest.xml`
```xml
android:label="Il Tuo Nome App"  # ← Nome visualizzato Android
```

**File:** `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Il Tuo Nome App</string>  # ← Nome visualizzato iOS
```

### Cambia icona app

1. Prepara icona 1024x1024 PNG
2. Usa tool online: https://icon.kitchen
3. Sostituisci file generati in:
   - `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Modifica colore tema

**File:** `lib/main.dart`
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue.shade700,  // ← Cambia colore principale
  brightness: Brightness.light,
),
```

## Emulatori

### Android (AVD Manager)

```bash
# Lista emulatori
flutter emulators

# Avvia emulatore
flutter emulators --launch <emulator-id>

# Oppure da Android Studio:
# Tools → Device Manager → Crea/Avvia emulatore
```

### iOS (solo macOS)

```bash
# Apri simulatore
open -a Simulator

# Lista simulatori
xcrun simctl list devices

# Avvia specifico simulatore
xcrun simctl boot "<simulator-name>"
```

## Testare Mixed Content

### ✅ Android/iOS/Windows Build

Mixed Content **FUNZIONA** su build native (APK/IPA/EXE)

### ❌ Chrome/Web

Mixed Content **NON FUNZIONA** su `flutter run -d chrome` (limitazione browser)

### Test su dispositivo reale

1. **Build APK**:
   ```bash
   flutter build apk --release
   ```

2. **Installa su dispositivo**:
   ```bash
   # Trova APK
   ls build/app/outputs/flutter-apk/
   
   # Installa via ADB
   adb install build/app/outputs/flutter-apk/app-release.apk
   
   # Oppure trasferisci APK e installa manualmente
   ```

3. **Testa comunicazione HTTPS → HTTP**:
   - Apri app
   - Configura URL Sublima Cloud (HTTPS)
   - Verifica che comunicazione con ZERO Esterno (HTTP) funzioni

## Risorse

- 📘 **README.md** - Documentazione completa
- 🛠️ **INSTALL_FLUTTER.md** - Guida installazione Flutter
- 🌐 **Flutter Docs**: https://docs.flutter.dev
- 📦 **flutter_inappwebview**: https://pub.dev/packages/flutter_inappwebview

## Supporto

Per assistenza tecnica: support@sublima.it
