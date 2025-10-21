# Sublima WebView - Build Windows Dettagliato

## Prerequisiti Windows

### 1. Installa Flutter SDK

1. **Scarica Flutter per Windows:**
   - Vai a: https://docs.flutter.dev/get-started/install/windows
   - Scarica ZIP (es. `flutter_windows_3.16.0-stable.zip`)

2. **Estrai Flutter:**
   - Crea cartella: `C:\src\`
   - Estrai ZIP in: `C:\src\flutter\`

3. **Aggiungi al PATH:**
   - Cerca "Variabili d'ambiente" nel menu Start
   - Modifica "Path" nelle variabili utente
   - Aggiungi: `C:\src\flutter\bin`
   - Clicca OK

4. **Verifica installazione:**
   ```powershell
   flutter --version
   flutter doctor
   ```

### 2. Installa Visual Studio 2022

1. **Scarica Visual Studio 2022:**
   - Community Edition (gratuita): https://visualstudio.microsoft.com/downloads/

2. **Durante installazione, seleziona:**
   - ✅ **Desktop development with C++**
   - ✅ **Windows 10 SDK** (o Windows 11 SDK)

3. **Componenti individuali richiesti:**
   - MSVC v143 - VS 2022 C++ x64/x86 build tools
   - Windows 10/11 SDK (10.0.19041.0 o successivo)
   - C++ CMake tools for Windows

4. **Verifica installazione:**
   ```powershell
   flutter doctor
   ```
   Dovrebbe mostrare "Visual Studio" con checkmark verde.

### 3. Abilita Windows Desktop Support

```powershell
flutter config --enable-windows-desktop
```

### 4. Installa Git (se mancante)

```powershell
# Scarica da: https://git-scm.com/download/win
# Oppure con Chocolatey:
choco install git
```

## Setup Progetto

### 1. Clona/Copia Progetto

```powershell
# Se hai il progetto già pronto
cd C:\Users\TuoNome\Desktop
git clone /path/to/sublima_webview

# Oppure copia manualmente la cartella sublima_webview
```

### 2. Installa Dipendenze

```powershell
cd sublima_webview
flutter pub get
```

### 3. Verifica Windows Support

```powershell
flutter devices
```

Dovresti vedere:
```
Windows (desktop) • windows • windows-x64 • Microsoft Windows
```

## Build Debug (Test)

### 1. Run in Debug Mode

```powershell
flutter run -d windows
```

Questo:
- Compila l'app in modalità debug
- Apre finestra Windows con l'app
- Abilita hot-reload (premi `r` per ricaricare)

### 2. Test Funzionalità

1. Inserisci URL profilo Sublima
2. Verifica WebView carica correttamente
3. Testa navigazione, reload, menu

## Build Release (Produzione)

### 1. Build Completo

```powershell
flutter build windows --release
```

**Output:** `build\windows\runner\Release\`

### 2. File Generati

```
build\windows\runner\Release\
├── sublima_webview.exe         # Eseguibile principale
├── flutter_windows.dll          # DLL Flutter runtime
├── data\                        # Asset app
│   ├── icudtl.dat
│   └── flutter_assets\
└── (altre DLL necessarie)
```

### 3. Distribuzione

**Opzione A: Cartella Portatile**

1. Copia intera cartella `build\windows\runner\Release\`
2. Rinomina in `SublimaWebView\`
3. Distribuisci cartella completa (tutti i file necessari inclusi)
4. Utente esegue `sublima_webview.exe`

**Opzione B: Installer con MSIX**

```powershell
# Aggiungi configurazione MSIX a pubspec.yaml
flutter pub add msix

# Configura MSIX
# Vedi: https://pub.dev/packages/msix

# Build MSIX
flutter pub run msix:create
```

Output: `build\windows\runner\Release\sublima_webview.msix`

**Opzione C: Installer con Inno Setup**

1. Scarica Inno Setup: https://jrsoftware.org/isinfo.php
2. Crea script installer (vedi esempio sotto)
3. Compila installer

## Esempio Script Inno Setup

Crea file `installer.iss`:

```iss
[Setup]
AppName=Sublima WebView
AppVersion=1.0.0
DefaultDirName={pf}\SublimaWebView
DefaultGroupName=Sublima
OutputDir=.\installer_output
OutputBaseFilename=SublimaWebView_Setup
Compression=lzma2
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\Sublima WebView"; Filename: "{app}\sublima_webview.exe"
Name: "{commondesktop}\Sublima WebView"; Filename: "{app}\sublima_webview.exe"

[Run]
Filename: "{app}\sublima_webview.exe"; Description: "Avvia Sublima WebView"; Flags: postinstall nowait skipifsilent
```

Compila con Inno Setup Compiler.

## Dimensioni Build

- **Debug build:** ~150-200 MB
- **Release build:** ~50-70 MB
- **Compressed installer:** ~20-30 MB (con MSIX/Inno Setup)

## Troubleshooting Windows

### Errore: "Visual Studio not found"

**Soluzione:**
1. Installa Visual Studio 2022 con "Desktop development with C++"
2. Run: `flutter doctor`
3. Verifica checkmark verde su Visual Studio

### Errore: "CMake not found"

**Soluzione:**
```powershell
# Installa CMake
choco install cmake

# Oppure scarica da: https://cmake.org/download/
```

### Errore: "Windows SDK not found"

**Soluzione:**
1. Apri Visual Studio Installer
2. Modify → Individual Components
3. Installa "Windows 10 SDK" o "Windows 11 SDK"

### Build fallisce con errori C++

**Soluzione:**
```powershell
# Pulisci build
flutter clean

# Reinstalla dipendenze
flutter pub get

# Riprova build
flutter build windows --release
```

### App non si avvia (missing DLL)

**Soluzione:**
Assicurati di distribuire **intera cartella** `build\windows\runner\Release\`, non solo `.exe`.

### WebView2 Runtime mancante

**Soluzione:**
Installa WebView2 Runtime (già presente su Windows 11, potrebbe mancare su Windows 10):
- Scarica: https://developer.microsoft.com/microsoft-edge/webview2/
- Includi nel tuo installer o chiedi all'utente di installarlo

## Ottimizzazioni

### Riduci Dimensioni Build

```powershell
# Build con stripping simboli
flutter build windows --release --split-debug-info=./debug-info

# Output più piccolo: ~40-50 MB invece di ~50-70 MB
```

### Icona App Personalizzata

1. Crea icona `.ico` (256x256 o multi-size)
2. Salva come `windows\runner\resources\app_icon.ico`
3. Rebuild:
   ```powershell
   flutter clean
   flutter build windows --release
   ```

### Splash Screen Windows

Non nativo in Flutter Windows, ma puoi:
1. Creare splash screen custom in `main.dart`
2. Oppure usare package: `flutter_native_splash`

## Performance

### Modalità Release vs Debug

| Modalità | Dimensione | Performance | Hot Reload |
|----------|-----------|-------------|------------|
| Debug    | ~150 MB   | Lenta       | ✅ Sì      |
| Release  | ~50 MB    | Veloce      | ❌ No      |

**Per distribuzione: SEMPRE usare `--release`**

### Ottimizzazioni Runtime

Flutter Windows usa:
- **WebView2** (Edge Chromium) per WebView
- **Skia** per rendering UI
- **Dart VM** (AOT compiled in release)

Performance è comparabile a app native C++/C#.

## Distribuzione

### Metodo Semplice (ZIP)

```powershell
# 1. Build release
flutter build windows --release

# 2. Naviga alla cartella
cd build\windows\runner\Release

# 3. Comprimi cartella
# Tasto destro → Invia a → Cartella compressa

# 4. Rinomina in SublimaWebView-v1.0.0.zip

# 5. Distribuisci ZIP via email/download/USB
```

**Istruzioni utente:**
1. Estrai ZIP in cartella a scelta
2. Esegui `sublima_webview.exe`

### Metodo Professionale (Installer)

**Con MSIX (Microsoft Store style):**
```powershell
flutter pub add msix
flutter pub run msix:create
```

**Con Inno Setup (installer classico):**
1. Scrivi script `.iss` (vedi esempio sopra)
2. Compila con Inno Setup
3. Distribuisci `SublimaWebView_Setup.exe`

## Firma Codice (Opzionale)

Per evitare warning "Publisher unknown":

1. **Certificato Code Signing:**
   - Acquista da CA (es. DigiCert, Sectigo): ~€200-400/anno
   - Oppure self-signed (ma warning persiste)

2. **Firma eseguibile:**
   ```powershell
   signtool sign /f certificato.pfx /p password sublima_webview.exe
   ```

3. **Firma installer:**
   - MSIX: firmato automaticamente se configurato
   - Inno Setup: firma il `.exe` finale con `signtool`

## Aggiornamenti

### Versioning

**File:** `pubspec.yaml`
```yaml
version: 1.0.0+1  # Versione app + build number
```

Incrementa per ogni release:
- `1.0.0` → `1.0.1` (bug fix)
- `1.0.0` → `1.1.0` (nuove feature)
- `1.0.0` → `2.0.0` (breaking changes)

### Auto-update (Avanzato)

Opzioni:
1. **Manuale**: Utente scarica nuova versione
2. **Sparkle for Windows**: Framework auto-update
3. **Custom**: Check update API + download installer

## Checklist Pre-Distribuzione

- [ ] ✅ Build release: `flutter build windows --release`
- [ ] ✅ Test su Windows 10 e Windows 11
- [ ] ✅ Verifica icona app corretta
- [ ] ✅ Test Mixed Content (HTTPS → HTTP)
- [ ] ✅ Verifica dimensione build (~50-70 MB)
- [ ] ✅ Test installazione da zero su macchina pulita
- [ ] ✅ Verifica WebView2 Runtime installato/incluso
- [ ] ✅ Crea documentazione utente
- [ ] ✅ Prepara changelog versione
- [ ] ✅ (Opzionale) Firma codice eseguibile

## Risorse

- **Flutter Windows:** https://docs.flutter.dev/desktop#windows
- **WebView2:** https://developer.microsoft.com/microsoft-edge/webview2/
- **MSIX Package:** https://pub.dev/packages/msix
- **Inno Setup:** https://jrsoftware.org/isinfo.php
- **Visual Studio:** https://visualstudio.microsoft.com/

## Supporto

Per assistenza tecnica: support@sublima.it
