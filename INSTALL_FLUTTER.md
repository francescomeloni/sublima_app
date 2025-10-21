# Sublima WebView - Guida Installazione Flutter

## 1. Installa Flutter SDK

### Linux (Ubuntu/Debian)

```bash
# Scarica Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# Estrai
tar xf flutter_linux_3.16.0-stable.tar.xz

# Aggiungi al PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verifica installazione
flutter doctor
```

### Windows

1. Scarica Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Estrai in `C:\src\flutter`
3. Aggiungi `C:\src\flutter\bin` al PATH di sistema
4. Apri PowerShell e verifica: `flutter doctor`

### macOS

```bash
# Con Homebrew
brew install --cask flutter

# Oppure manualmente
cd ~
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.16.0-stable.zip
unzip flutter_macos_3.16.0-stable.zip
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

flutter doctor
```

## 2. Installa Dipendenze Piattaforma

### Android

1. **Android Studio**: https://developer.android.com/studio
2. Durante installazione, includi:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
3. Apri Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK
4. Installa:
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android Emulator
5. Accetta licenze:
   ```bash
   flutter doctor --android-licenses
   ```

### iOS (solo macOS)

1. **Xcode**: Installa da App Store
2. Apri Xcode → Preferences → Locations → Command Line Tools (seleziona versione)
3. Accetta licenza:
   ```bash
   sudo xcodebuild -license
   ```
4. Installa CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

### Windows Desktop

1. **Visual Studio 2022**: https://visualstudio.microsoft.com/downloads/
2. Durante installazione, seleziona:
   - Desktop development with C++
   - Windows 10/11 SDK
3. Abilita sviluppo Windows in Flutter:
   ```bash
   flutter config --enable-windows-desktop
   ```

## 3. Configura Progetto Sublima WebView

```bash
cd /home/vete/W/sublima_webview

# Installa dipendenze
flutter pub get

# Verifica configurazione
flutter doctor -v
```

## 4. Run su Dispositivo

### Emulatore Android

```bash
# Lista emulatori disponibili
flutter emulators

# Avvia emulatore
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

### Dispositivo Android Fisico

1. Abilita "Opzioni Sviluppatore" su Android:
   - Settings → About Phone → Tap 7 volte su "Build Number"
2. Abilita "USB Debugging" in Developer Options
3. Collega dispositivo via USB
4. Verifica:
   ```bash
   flutter devices
   ```
5. Run:
   ```bash
   flutter run
   ```

### iOS Simulator (macOS)

```bash
# Apri simulatore
open -a Simulator

# Run app
flutter run
```

### Windows Desktop

```bash
flutter run -d windows
```

## 5. Build Release

### Android APK

```bash
# Build standard
flutter build apk --release

# Build ottimizzato per architettura (più piccolo)
flutter build apk --release --split-per-abi

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS + Apple Developer Account)

```bash
# Build IPA
flutter build ipa --release

# Output: build/ios/ipa/sublima_webview.ipa
```

### Windows

```bash
flutter build windows --release

# Output: build/windows/runner/Release/
```

## 6. Troubleshooting

### "flutter: command not found"

Aggiungi Flutter al PATH:
```bash
# Linux/macOS
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Windows: aggiungi manualmente C:\src\flutter\bin al PATH di sistema
```

### Android SDK non trovato

```bash
# Imposta ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Aggiungi a ~/.bashrc per rendere permanente
```

### Errori di licenza Android

```bash
flutter doctor --android-licenses
# Accetta tutte le licenze
```

### iOS: "Could not find CocoaPods"

```bash
sudo gem install cocoapods
pod setup
```

### Windows: WebView2 mancante

Installa: https://developer.microsoft.com/microsoft-edge/webview2/

## 7. Test Rapido con Chrome

Se non hai emulatori pronti, puoi testare velocemente con Chrome:

```bash
flutter run -d chrome
```

**Nota:** Chrome NON supporta Mixed Content, quindi ZERO Esterno non funzionerà. È solo per test UI.

## 8. Verifica Finale

```bash
cd /home/vete/W/sublima_webview
flutter doctor -v
flutter pub get
flutter analyze
flutter run
```

## Risorse

- Flutter Docs: https://docs.flutter.dev
- Flutter Cookbook: https://docs.flutter.dev/cookbook
- flutter_inappwebview: https://pub.dev/packages/flutter_inappwebview
- Dart Lang: https://dart.dev
