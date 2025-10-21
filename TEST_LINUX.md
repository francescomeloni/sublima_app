# Come Testare Sublima WebView su Linux

## ⚡ Opzione 1: Test Veloce con Chrome (RACCOMANDATO per inizio)

### Requisiti
- Google Chrome o Chromium installato
- Flutter installato

### Setup Rapido Flutter

```bash
# 1. Scarica Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# 2. Estrai
tar xf flutter_linux_3.16.0-stable.tar.xz

# 3. Aggiungi al PATH (temporaneo, solo questa sessione)
export PATH="$PATH:$HOME/flutter/bin"

# 4. Verifica
flutter --version

# 5. Abilita web support
flutter config --enable-web

# 6. Vai al progetto
cd /home/vete/W/sublima_webview

# 7. Installa dipendenze
flutter pub get

# 8. Run su Chrome
flutter run -d chrome
```

**Cosa vedrai:**
- ✅ UI completa (splash, setup, webview)
- ✅ Navigazione funzionante
- ❌ Mixed Content NON funziona (Chrome blocca HTTP da HTTPS)

### Per rendere PATH permanente:

```bash
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

---

## 📱 Opzione 2: Test su Android Reale (RACCOMANDATO per Mixed Content)

### Requisiti
- Dispositivo Android con USB debugging
- ADB installato

### Setup

```bash
# 1. Installa ADB
sudo apt update
sudo apt install android-tools-adb android-tools-fastboot

# 2. Sul dispositivo Android:
# - Settings → About Phone → Tap 7 volte su "Build Number"
# - Settings → Developer Options → Abilita "USB Debugging"

# 3. Collega dispositivo via USB

# 4. Verifica connessione
adb devices
# Dovresti vedere il tuo dispositivo

# 5. Autorizza sul dispositivo (popup che appare)

# 6. Build APK
cd /home/vete/W/sublima_webview
flutter build apk --release

# 7. Installa APK
adb install build/app/outputs/flutter-apk/app-release.apk

# 8. Apri app sul dispositivo
# L'app "Sublima WebView" apparirà nel drawer
```

**Cosa vedrai:**
- ✅ UI completa
- ✅ Mixed Content FUNZIONA (HTTPS → HTTP)
- ✅ Test reale Sublima Cloud → ZERO Esterno

---

## 🖥️ Opzione 3: Emulatore Android (completo ma lento)

### Requisiti
- Android Studio installato
- 8+ GB RAM raccomandati

### Setup Android Studio

```bash
# 1. Scarica Android Studio
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.26/android-studio-2023.1.1.26-linux.tar.gz

# 2. Estrai
sudo tar -xzf android-studio-*-linux.tar.gz -C /opt

# 3. Avvia
/opt/android-studio/bin/studio.sh

# 4. Segui wizard setup:
#    - Installa Android SDK
#    - Installa Android SDK Command-line Tools
#    - Installa Android Emulator

# 5. Crea AVD (Android Virtual Device):
#    Tools → Device Manager → Create Virtual Device
#    - Seleziona Pixel 5
#    - API Level 33 (Android 13)
#    - Download system image
#    - Finish

# 6. Avvia emulatore da Android Studio
#    Oppure da terminale:
flutter emulators --launch <emulator-id>

# 7. Run app
cd /home/vete/W/sublima_webview
flutter run
```

---

## 🚀 Opzione 4: Linux Desktop (nativo, veloce)

Flutter supporta Linux desktop nativamente!

### Setup

```bash
# 1. Installa dipendenze Linux
sudo apt update
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev

# 2. Abilita Linux desktop
flutter config --enable-linux-desktop

# 3. Verifica dispositivi
flutter devices
# Dovresti vedere "Linux (desktop)"

# 4. Run
cd /home/vete/W/sublima_webview
flutter run -d linux
```

**Nota:** Linux desktop usa WebKitGTK, che potrebbe avere limitazioni Mixed Content simili a Chrome.

---

## ⚡ Quick Start Immediato (Senza Installare Nulla)

Se non vuoi installare Flutter ora, puoi testare APK pre-compilato:

### Opzione A: Build su Macchina con Flutter

Se hai accesso a un PC con Flutter già installato (Windows/Mac/Linux):

```bash
cd /home/vete/W/sublima_webview
flutter build apk --release
# Copia APK generato su Android
```

### Opzione B: Usa Container Docker

```bash
# Pull immagine Flutter
docker pull cirrusci/flutter

# Build APK in container
docker run --rm -v $(pwd):/app -w /app cirrusci/flutter \
  sh -c "flutter pub get && flutter build apk --release"

# APK in build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎯 Raccomandazione per Te

### Se vuoi testare SUBITO (5 minuti):

```bash
# Installa Flutter base
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz
export PATH="$PATH:$HOME/flutter/bin"

# Test veloce Chrome
cd /home/vete/W/sublima_webview
flutter config --enable-web
flutter pub get
flutter run -d chrome
```

### Se vuoi testare Mixed Content REALE:

1. **Build APK** (richiede Flutter installato):
   ```bash
   cd /home/vete/W/sublima_webview
   flutter build apk --release
   ```

2. **Installa su Android**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

### Se vuoi sviluppare attivamente:

Installa Android Studio completo + emulatore (vedi Opzione 3).

---

## 🐛 Troubleshooting

### "flutter: command not found"

```bash
export PATH="$PATH:$HOME/flutter/bin"
# Oppure aggiungi a ~/.bashrc per permanenza
```

### "No devices found"

```bash
# Per web
flutter config --enable-web
flutter devices  # Dovresti vedere "Chrome"

# Per Linux desktop
flutter config --enable-linux-desktop
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
flutter devices  # Dovresti vedere "Linux"
```

### "Android licenses not accepted"

```bash
flutter doctor --android-licenses
# Accetta tutte le licenze premendo 'y'
```

### Build APK fallisce

```bash
flutter clean
flutter pub get
flutter build apk --release --verbose
```

---

## 📊 Confronto Opzioni

| Opzione | Tempo Setup | Mixed Content | Performance | Raccomandato Per |
|---------|-------------|---------------|-------------|------------------|
| **Chrome** | 5 min | ❌ | ⭐⭐⭐⭐⭐ | Test UI rapido |
| **Linux Desktop** | 10 min | ⚠️ | ⭐⭐⭐⭐⭐ | Sviluppo locale |
| **Android Reale** | 15 min | ✅ | ⭐⭐⭐⭐⭐ | Test completo |
| **Emulatore** | 30+ min | ✅ | ⭐⭐⭐ | Sviluppo senza device |
| **Docker** | 10 min | N/A | ⭐⭐⭐ | Build APK senza setup |

---

## ✅ Checklist

- [ ] Flutter installato: `flutter --version`
- [ ] Dipendenze progetto: `flutter pub get`
- [ ] Dispositivo disponibile: `flutter devices`
- [ ] Run test: `flutter run -d <device>`
- [ ] (Opzionale) Build APK: `flutter build apk --release`

---

## 🆘 Aiuto Rapido

**Voglio vedere l'app ORA (UI soltanto):**
```bash
cd ~ && wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz && tar xf flutter_linux_3.16.0-stable.tar.xz && export PATH="$PATH:$HOME/flutter/bin" && cd /home/vete/W/sublima_webview && flutter config --enable-web && flutter pub get && flutter run -d chrome
```

**Voglio testare Mixed Content su Android:**
```bash
# 1. Installa Flutter (comandi sopra)
# 2. Build APK
flutter build apk --release
# 3. Trasferisci build/app/outputs/flutter-apk/app-release.apk su Android
# 4. Installa APK manualmente sul dispositivo
```

---

Vedi anche:
- `INSTALL_FLUTTER.md` - Guida completa installazione Flutter
- `README.md` - Documentazione progetto completa
