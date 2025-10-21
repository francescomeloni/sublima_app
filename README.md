# Sublima WebView

WebView client nativo per Sublima ERP con supporto Mixed Content (HTTPS → HTTP).

## Problema Risolto

I browser moderni bloccano richieste HTTP da pagine HTTPS (Mixed Content), impedendo la comunicazione tra:
- **Sublima Cloud** (HTTPS) → **ZERO Esterno** (HTTP su rete locale)

Questa app nativa bypassa questa restrizione permettendo la comunicazione completa.

## Caratteristiche

- ✅ **Mixed Content abilitato** - Comunicazione HTTPS → HTTP senza blocchi
- ✅ **UI Fullscreen** - Utilizzo completo dello schermo disponibile
- ✅ **Setup semplice** - Configurazione con solo URL profilo Sublima
- ✅ **Multi-piattaforma** - Android, iOS, Windows
- ✅ **Storage persistente** - URL salvato localmente
- ✅ **Navigazione fluida** - Supporto history, reload, gestione errori

## Prerequisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.0.0
- **Android:** Android Studio + SDK (API 21+)
- **iOS:** Xcode + CocoaPods (macOS richiesto)
- **Windows:** Visual Studio 2022 con C++ Desktop Development

## Installazione

### 1. Verifica installazione Flutter

```bash
flutter doctor -v
```

### 2. Clona/apri il progetto

```bash
cd /home/vete/W/sublima_webview
```

### 3. Installa dipendenze

```bash
flutter pub get
```

### 4. Verifica dispositivi disponibili

```bash
flutter devices
```

## Sviluppo

### Run su dispositivo/emulatore

```bash
# Android
flutter run -d <android-device-id>

# iOS (solo macOS)
flutter run -d <ios-device-id>

# Windows
flutter run -d windows

# Chrome (per debug veloce)
flutter run -d chrome
```

### Hot Reload

Durante l'esecuzione, premi `r` per hot reload o `R` per hot restart.

## Build Release

### Android

```bash
# APK per distribuzione diretta
flutter build apk --release

# APK ottimizzato per architettura (più piccolo)
flutter build apk --release --split-per-abi

# App Bundle per Google Play Store
flutter build appbundle --release
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
# Build per dispositivo (richiede certificati Apple)
flutter build ios --release

# Genera IPA per distribuzione TestFlight/App Store
flutter build ipa --release
```

**Note:** Richiede Mac + Xcode + Apple Developer Account ($99/anno)

### Windows

```bash
# Build eseguibile Windows
flutter build windows --release
```

**Output:** `build/windows/runner/Release/`

## Configurazione App

### Prima configurazione

1. Avvia app
2. Inserisci URL profilo Sublima (es. `cloud.sublima.it/profilo/s1087`)
3. Tap "Continua"

L'URL viene salvato e usato per accessi futuri.

### Reset configurazione

1. Apri menu (⋮) nella WebView
2. Tap "Reset Configurazione"
3. Conferma

Tornerai alla schermata di setup.

## Struttura Progetto

```
sublima_webview/
├── lib/
│   ├── main.dart                  # Entry point + splash screen
│   ├── screens/
│   │   ├── setup_screen.dart      # UI configurazione URL
│   │   └── webview_screen.dart    # WebView fullscreen
│   └── services/
│       └── storage_service.dart   # Gestione storage persistente
├── android/                       # Configurazione Android
├── ios/                           # Configurazione iOS
├── windows/                       # Configurazione Windows
├── assets/                        # Risorse (icone, immagini)
└── pubspec.yaml                   # Dipendenze Flutter
```

## Dipendenze

- **flutter_inappwebview** (^6.0.0) - WebView con controllo completo Mixed Content
- **shared_preferences** (^2.2.0) - Storage locale per URL profilo
- **url_launcher** (^6.1.0) - Apertura link esterni (opzionale)

## Troubleshooting

### Android: "Cleartext HTTP traffic not permitted"

Verifica che `android/app/src/main/AndroidManifest.xml` contenga:
```xml
android:usesCleartextTraffic="true"
```

### iOS: Mixed Content bloccato

Verifica che `ios/Runner/Info.plist` contenga:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Windows: WebView non funziona

Installa [WebView2 Runtime](https://developer.microsoft.com/microsoft-edge/webview2/)

### Build Android fallisce

```bash
# Pulisci build cache
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter build apk --release
```

## Licenza

Proprietario - Sublima ERP

## Supporto

Per assistenza: [support@sublima.it](mailto:support@sublima.it)
