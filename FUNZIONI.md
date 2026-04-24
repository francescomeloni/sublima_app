# Funzioni / Features - Sublima WebView App

Questo documento descrive tutte le funzionalità (funzioni) disponibili nell'applicazione Sublima WebView.

## 📋 Indice

- [Funzioni Principali](#funzioni-principali)
- [Funzioni WebView](#funzioni-webview)
- [Funzioni di Configurazione](#funzioni-di-configurazione)
- [Funzioni di Storage](#funzioni-di-storage)
- [Funzioni Multi-Piattaforma](#funzioni-multi-piattaforma)
- [Funzioni di Sicurezza](#funzioni-di-sicurezza)

---

## 🎯 Funzioni Principali

### 1. **Mixed Content Support** (HTTPS → HTTP)
- **Descrizione**: Permette comunicazione tra siti HTTPS e dispositivi HTTP locali
- **File**: `lib/screens/webview_screen.dart:136`
- **Utilizzo**: Automatico, abilitato per tutte le piattaforme
- **Beneficio**: Risolve il problema del Mixed Content bloccato dai browser moderni
- **Piattaforme**: Android, iOS, Windows

```dart
mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW
```

### 2. **Splash Screen con Auto-Routing**
- **Descrizione**: Verifica configurazione esistente e naviga automaticamente
- **File**: `lib/main.dart:73-112`
- **Funzionalità**:
  - Controlla se esiste URL salvato
  - Naviga a WebView se configurato
  - Mostra Setup Screen se prima configurazione
- **Durata splash**: 800ms

### 3. **WebView Fullscreen**
- **Descrizione**: Visualizzazione fullscreen del profilo Sublima
- **File**: `lib/screens/webview_screen.dart:12`
- **Caratteristiche**:
  - Interfaccia minimale per massimo spazio contenuto
  - AppBar con pulsanti refresh e menu
  - Progress bar caricamento
  - Gestione errori integrata

---

## 🌐 Funzioni WebView

### 4. **Caricamento Pagine con Progress Indicator**
- **Descrizione**: Mostra progresso caricamento con barra animata
- **File**: `lib/screens/webview_screen.dart:234-240`
- **Funzionalità**:
  - Progress bar lineare in cima alla WebView
  - Percentuale di caricamento in tempo reale
  - Scompare automaticamente al completamento

### 5. **Gestione Navigazione (Back Button)**
- **Descrizione**: Back button nativo gestisce history WebView
- **File**: `lib/screens/webview_screen.dart:195-212`
- **Comportamento**:
  - Se history disponibile → torna indietro nella WebView
  - Se nessuna history → chiude app/schermata
- **Implementazione**: `PopScope` con `canGoBack()`

### 6. **JavaScript Abilitato**
- **Descrizione**: Supporto completo JavaScript per app web moderne
- **File**: `lib/screens/webview_screen.dart:140`
- **Funzionalità**:
  - JavaScript execution
  - DOM manipulation
  - AJAX requests
  - Window.open support

### 7. **DOM Storage (localStorage, sessionStorage)**
- **Descrizione**: Supporto storage locale per sessioni e dati persistenti
- **File**: `lib/screens/webview_screen.dart:142`
- **Storage types**:
  - `localStorage` - persistente
  - `sessionStorage` - per sessione
  - Database storage
  - Cache storage

### 8. **Media Autoplay**
- **Descrizione**: Riproduzione automatica media senza interazione utente
- **File**: `lib/screens/webview_screen.dart:147-148`
- **Supporto**:
  - Video autoplay
  - Audio autoplay
  - Inline media playback

### 9. **Zoom Support**
- **Descrizione**: Pinch-to-zoom per ingrandire/ridurre contenuto
- **File**: `lib/screens/webview_screen.dart:151-153`
- **Controlli**:
  - Built-in zoom controls (nascosti per UI pulita)
  - Gesture support
  - Limiti zoom configurabili

### 10. **Geolocation Support**
- **Descrizione**: Accesso posizione GPS per funzionalità basate su location
- **File**: `lib/screens/webview_screen.dart:156`
- **Funzionalità**:
  - Richiesta permessi automatica
  - Supporto GPS nativo
  - Fallback su network location

### 11. **User Agent Personalizzato**
- **Descrizione**: Identifica l'app come "SublimaWebView" nei log server
- **File**: `lib/screens/webview_screen.dart:159`
- **Valore**: `SublimaWebView/1.0 (Flutter) Mobile`
- **Utilizzo**: Analytics, comportamento server-side specifico

### 12. **Console Message Logging**
- **Descrizione**: Cattura e visualizza messaggi console JavaScript
- **File**: `lib/screens/webview_screen.dart:296-300`
- **Livelli log**:
  - DEBUG
  - LOG
  - INFO
  - WARNING
  - ERROR
- **Output**: Debug console Flutter

### 13. **HTTP Resource Monitoring**
- **Descrizione**: Log di tutte le risorse HTTP caricate (per debug Mixed Content)
- **File**: `lib/screens/webview_screen.dart:289-295`
- **Funzionalità**:
  - Identifica risorse HTTP vs HTTPS
  - Emoji indicator (🔓 per HTTP)
  - Utile per verificare Mixed Content

### 14. **Gestione Permessi**
- **Descrizione**: Gestione automatica permessi (camera, microfono, etc.)
- **File**: `lib/screens/webview_screen.dart:307-312`
- **Comportamento**: GRANT automatico per tutti i permessi richiesti
- **Permessi supportati**:
  - Camera
  - Microphone
  - Geolocation
  - Media devices

### 15. **Server Trust (SSL Certificates)**
- **Descrizione**: Gestione certificati SSL self-signed o non validi
- **File**: `lib/screens/webview_screen.dart:301-306`
- **Comportamento**: PROCEED automatico (utile per ambiente di test)
- **⚠️ Nota**: Disabilitare in produzione per sicurezza

---

## ⚙️ Funzioni di Configurazione

### 16. **Setup Screen (Prima Configurazione)**
- **Descrizione**: Schermata per inserire URL profilo Sublima
- **File**: `lib/screens/setup_screen.dart:9`
- **Funzionalità**:
  - Input field con validazione
  - Normalizzazione URL automatica
  - Salvataggio persistente
  - Navigazione automatica a WebView

### 17. **Validazione URL**
- **Descrizione**: Verifica formato URL prima del salvataggio
- **File**: `lib/screens/setup_screen.dart:154-163`
- **Controlli**:
  - Campo non vuoto
  - Presenza carattere '.'
  - Formato URL valido
- **Auto-fix**: Aggiunge `https://` se mancante

### 18. **Normalizzazione URL**
- **Descrizione**: Aggiunge automaticamente schema HTTPS se mancante
- **File**: `lib/screens/setup_screen.dart:36-39`
- **Esempi**:
  - `profilo.sublima.it` → `https://profilo.sublima.it`
  - `http://test.local` → `http://test.local` (preservato)

### 19. **Reset Configurazione**
- **Descrizione**: Cancella URL salvato e torna al setup
- **File**: `lib/screens/webview_screen.dart:29-60`
- **Funzionalità**:
  - Dialog di conferma
  - Cancellazione storage
  - Navigazione a Setup Screen
  - Prevenzione cancellazione accidentale

---

## 💾 Funzioni di Storage

### 20. **Salvataggio URL Profilo**
- **Descrizione**: Salva URL in storage persistente locale
- **File**: `lib/services/storage_service.dart:35-39`
- **Tecnologia**: SharedPreferences
- **Persistenza**: Sopravvive a chiusura app e reboot

### 21. **Recupero URL Salvato**
- **Descrizione**: Carica URL dal storage locale
- **File**: `lib/services/storage_service.dart:46-57`
- **Funzionalità**:
  - Gestione URL nullo/vuoto
  - Normalizzazione automatica
  - Validazione formato

### 22. **Verifica Configurazione Esistente**
- **Descrizione**: Controlla se esiste URL salvato
- **File**: `lib/services/storage_service.dart:66-69`
- **Utilizzo**: Splash screen per routing automatico
- **Return**: `true` se configurato, `false` altrimenti

### 23. **Cancellazione Storage**
- **Descrizione**: Rimuove URL salvato (per reset)
- **File**: `lib/services/storage_service.dart:60-63`
- **Utilizzo**: Funzione reset configurazione

---

## 🔄 Funzioni Menu

### 24. **Ricarica Pagina**
- **Descrizione**: Reload completo della pagina corrente
- **File**: `lib/screens/webview_screen.dart:76-83`
- **Accesso**: Menu (⋮) → "Ricarica Pagina"
- **Shortcut**: Pulsante refresh in AppBar

### 25. **Vai alla Home**
- **Descrizione**: Torna all'URL profilo iniziale
- **File**: `lib/screens/webview_screen.dart:84-93`
- **Accesso**: Menu (⋮) → "Vai alla Home"
- **Funzionalità**: Carica URL profilo salvato

### 26. **Cancella Cache**
- **Descrizione**: Rimuove tutta la cache WebView
- **File**: `lib/screens/webview_screen.dart:94-105`
- **Accesso**: Menu (⋮) → "Cancella Cache"
- **Feedback**: SnackBar di conferma
- **Scope**: Cancella cache di tutte le WebView

### 27. **Visualizza URL Corrente**
- **Descrizione**: Mostra URL della pagina attualmente caricata
- **File**: `lib/screens/webview_screen.dart:107-115`
- **Accesso**: Menu (⋮) → Sezione "URL Corrente"
- **Funzionalità**: Copia-incolla supportato

### 28. **Menu Contestuale**
- **Descrizione**: Bottom sheet con opzioni rapide
- **File**: `lib/screens/webview_screen.dart:63-129`
- **Contenuto**:
  - Ricarica Pagina
  - Vai alla Home
  - Cancella Cache
  - URL Corrente (info)
  - Reset Configurazione

---

## 🖥️ Funzioni Multi-Piattaforma

### 29. **Android WebView**
- **Descrizione**: WebView nativo Android con Mixed Content
- **File**: `lib/screens/webview_screen.dart`
- **Tecnologia**: `flutter_inappwebview` + Android WebView
- **Configurazione**: `android/app/src/main/AndroidManifest.xml`
- **Features**:
  - Cleartext traffic abilitato
  - Network security config
  - Hardware acceleration

### 30. **iOS WebView**
- **Descrizione**: WebView nativo iOS (WKWebView)
- **File**: `lib/screens/webview_screen.dart`
- **Tecnologia**: `flutter_inappwebview` + WKWebView
- **Configurazione**: `ios/Runner/Info.plist`
- **Features**:
  - NSAppTransportSecurity configurato
  - Arbitrary loads abilitato
  - Local networking support

### 31. **Windows WebView**
- **Descrizione**: WebView2 (Edge Chromium) per Windows
- **File**: `lib/screens/webview_screen.dart`
- **Tecnologia**: `flutter_inappwebview` + WebView2
- **Requisiti**: WebView2 Runtime installato
- **Features**:
  - Mixed Content support
  - Full Chromium engine
  - Native Windows integration

### 32. **Linux Browser Launcher**
- **Descrizione**: Apre browser esterno su Linux
- **File**: `lib/screens/webview_screen.dart:455-461, 609-836`
- **Motivo**: WebView embedded limitato su Linux
- **Funzionalità**:
  - Launch automatico browser di sistema
  - Pulsante "Riapri nel Browser"
  - Informazioni supporto piattaforma
- **⚠️ Nota**: Mixed Content può essere bloccato dal browser

### 33. **Web Platform Message**
- **Descrizione**: Messaggio informativo per piattaforma Web
- **File**: `lib/screens/webview_screen.dart:464-606`
- **Motivo**: InAppWebView non supportato su Web
- **Funzionalità**:
  - Spiegazione limitazioni
  - Link documentazione
  - Istruzioni build native

### 34. **Platform Detection**
- **Descrizione**: Rilevamento automatico piattaforma
- **File**: `lib/screens/webview_screen.dart:186-193`
- **Logica**:
  - Linux → Browser esterno
  - Web → Messaggio informativo
  - Altro → WebView nativo

---

## 🛡️ Funzioni di Sicurezza

### 35. **Network Security Configuration (Android)**
- **File**: `android/app/src/main/res/xml/network_security_config.xml`
- **Funzionalità**:
  - Cleartext traffic abilitato
  - Trust per certificati user/system
  - Supporto domini HTTP

### 36. **App Transport Security (iOS)**
- **File**: `ios/Runner/Info.plist`
- **Configurazione**:
  - NSAllowsArbitraryLoads = true
  - Permette connessioni HTTP
  - Local networking support

### 37. **Gestione Errori HTTP**
- **Descrizione**: Cattura e visualizza errori HTTP (404, 500, etc.)
- **File**: `lib/screens/webview_screen.dart:313-344`
- **Funzionalità**:
  - SnackBar con status code
  - Log dettagliato errori
  - UI overlay opzionale

### 38. **Gestione Errori Caricamento**
- **Descrizione**: Gestisce errori rete/DNS/timeout
- **File**: `lib/screens/webview_screen.dart:345-375`
- **Funzionalità**:
  - SnackBar con descrizione errore
  - Pulsante "Riprova" integrato
  - Error overlay con opzioni
  - Log debug dettagliato

### 39. **Error Overlay UI**
- **Descrizione**: Overlay fullscreen per errori critici
- **File**: `lib/screens/webview_screen.dart:387-453`
- **Funzionalità**:
  - Descrizione errore user-friendly
  - Pulsante "Riprova"
  - Pulsante "Configura di nuovo"
  - Dismissable

---

## 🎨 Funzioni UI/UX

### 40. **Tema Sublima Personalizzato**
- **Descrizione**: Colori brandizzati Sublima (bordeaux/nero)
- **File**: `lib/main.dart:27-67`
- **Colori**:
  - Primary: Bordeaux (#8B0000)
  - Secondary: Nero (#000000)
  - Material 3 theme

### 41. **Logo Splash Screen**
- **Descrizione**: Logo Sublima con animazione splash
- **File**: `lib/main.dart:124-145`
- **Asset**: `assets/images/logosublimapiccolo.png`
- **Stile**: Cerchio bianco con ombra

### 42. **Logo Setup Screen**
- **Descrizione**: Logo Sublima con bordo bordeaux
- **File**: `lib/screens/setup_screen.dart:85-107`
- **Asset**: `assets/images/logosublimapiccolo.png`
- **Stile**: Cerchio con border bordeaux

### 43. **Loading States**
- **Descrizione**: Indicatori caricamento in tutta l'app
- **Implementazioni**:
  - Splash screen: `CircularProgressIndicator` (main.dart:172)
  - Setup screen: Button spinner (setup_screen.dart:179)
  - WebView: `LinearProgressIndicator` (webview_screen.dart:234)

### 44. **SnackBar Feedback**
- **Descrizione**: Messaggi toast per feedback utente
- **Utilizzo**:
  - Cache cancellata (webview_screen.dart:101)
  - Errori HTTP (webview_screen.dart:336)
  - Errori caricamento (webview_screen.dart:362)
  - Errori salvataggio (setup_screen.dart:54)

### 45. **Dialog Conferma Reset**
- **Descrizione**: Dialog di conferma prima di reset configurazione
- **File**: `lib/screens/webview_screen.dart:31-51`
- **Funzionalità**:
  - Titolo e descrizione chiara
  - Pulsanti Annulla/Conferma
  - Stile pulsante Conferma rosso (warning)

### 46. **Bottom Sheet Menu**
- **Descrizione**: Menu slide-up con opzioni
- **File**: `lib/screens/webview_screen.dart:70-128`
- **Design**: Material Design bottom sheet
- **Contenuto**: ListTile per ogni opzione

### 47. **SafeArea Wrapping**
- **Descrizione**: Rispetta notch/barre sistema
- **Utilizzo**:
  - Setup screen (setup_screen.dart:74)
  - Menu bottom sheet (webview_screen.dart:72)
  - Linux launcher (webview_screen.dart:671)

### 48. **Responsive Layout**
- **Descrizione**: Layout adattivo per diverse dimensioni schermo
- **Implementazioni**:
  - ConstrainedBox per error overlay (webview_screen.dart:392)
  - SingleChildScrollView per setup (setup_screen.dart:76)
  - Padding adattivo

---

## 📊 Funzioni Debug & Logging

### 49. **Debug Print Statements**
- **Descrizione**: Log dettagliati per debugging
- **File**: `lib/screens/webview_screen.dart`
- **Log events**:
  - Settings costruzione (133)
  - Load start/stop (262, 281)
  - HTTP resources (293)
  - Console messages (296)
  - HTTP errors (324)
  - Load errors (354)

### 50. **Prefix Log Organizzati**
- **Descrizione**: Prefissi strutturati per filtrare log
- **Formato**: `[WebView]`, `[WebView Console]`
- **Utilizzo**: Facile grep/search nei log
- **Esempio**: `[WebView] ========== LOAD START ==========`

---

## 📝 Funzioni Utility

### 51. **URL Normalization Service**
- **Descrizione**: Normalizza URL con schema HTTPS default
- **File**: `lib/services/storage_service.dart:13-29`
- **Funzionalità**:
  - Trim whitespace
  - Aggiunge https:// se mancante
  - Preserva http:// esistente
  - Gestisce null/empty

### 52. **Form Validation**
- **Descrizione**: Validazione input form setup
- **File**: `lib/screens/setup_screen.dart:154-163`
- **Regole**:
  - Campo obbligatorio
  - Presenza carattere '.'
  - Formato URL base

### 53. **Lifecycle Management**
- **Descrizione**: Gestione corretta lifecycle Flutter
- **Implementazioni**:
  - dispose() controllers (setup_screen.dart:22)
  - mounted checks prima setState
  - async/await pattern corretto

---

## 🔧 Funzioni Configurazione Avanzate

### 54. **WebView Settings Builder**
- **Descrizione**: Costruttore centralizzato settings WebView
- **File**: `lib/screens/webview_screen.dart:132-179`
- **Benefici**:
  - Configurazione consistente
  - Facile manutenzione
  - Log settings applicati

### 55. **URL Loading Strategy**
- **Descrizione**: Strategia caricamento URL configurabile
- **File**: `lib/screens/webview_screen.dart:285-288`
- **Policy**: ALLOW automatico per tutte le navigazioni
- **Personalizzabile**: Override per filtrare URL

### 56. **Cache Strategy**
- **Descrizione**: Configurazione cache WebView
- **File**: `lib/screens/webview_screen.dart:144, 164`
- **Impostazioni**:
  - Cache abilitata
  - ClearCache = false (persistente tra sessioni)
  - Cache manuale con menu

### 57. **Transparent Background Fix**
- **Descrizione**: Fix schermata bianca su Android
- **File**: `lib/screens/webview_screen.dart:170`
- **Workaround**: `transparentBackground: false`
- **Versione**: flutter_inappwebview 6.0.0

### 58. **Scroll Configuration**
- **Descrizione**: Configurazione scroll WebView
- **File**: `lib/screens/webview_screen.dart:166-173`
- **Impostazioni**:
  - Overscroll abilitato
  - Scrollbar verticali/orizzontali visibili
  - Scroll abilitato in tutte le direzioni

---

## 📈 Statistiche Codebase

- **Totale Funzioni**: 58+
- **Linee di Codice**: ~2400 (senza commenti)
- **File Dart**: 4
- **Screens**: 3 (Splash, Setup, WebView)
- **Services**: 1 (Storage)
- **Piattaforme**: 5 (Android, iOS, Windows, Linux, Web)

---

## 🎓 Come Usare Questo Documento

### Per Sviluppatori
1. Usa i riferimenti file:linea per navigare velocemente al codice
2. Consulta le funzioni per capire architettura
3. Estendi funzionalità esistenti seguendo pattern

### Per Product Managers
1. Usa come reference completa feature set
2. Identifica gap o nuove funzionalità da aggiungere
3. Comunica capabilities a stakeholder

### Per QA/Testing
1. Usa come checklist per test coverage
2. Verifica ogni funzione su tutte le piattaforme
3. Crea test case basati su funzioni

### Per Documentazione
1. Base per user manual
2. Reference per FAQ
3. Training material per nuovi utenti

---

## 🚀 Prossimi Sviluppi Suggeriti

Funzionalità che potrebbero essere aggiunte:

1. **Bookmarks/Favorites** - Salvataggio URL frequenti
2. **Multiple Profiles** - Supporto multi-account
3. **Offline Mode** - Cache pagine per uso offline
4. **Dark Mode** - Tema scuro UI
5. **Download Manager** - Gestione download file
6. **Screenshot Capture** - Cattura screenshot pagina
7. **Print Support** - Stampa pagine WebView
8. **Share URL** - Condivisione URL via sistema
9. **Biometric Lock** - Protezione app con fingerprint/face
10. **Analytics** - Tracking utilizzo app

---

## 📞 Supporto

Per domande su specifiche funzioni:
- **Email**: support@sublima.it
- **Documentazione**: README.md
- **Guida Rapida**: QUICKSTART.md

---

**Documento creato**: 2026-04-24
**Versione App**: 1.0.0
**Ultimo aggiornamento**: 2026-04-24
