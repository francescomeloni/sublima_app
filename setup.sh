#!/bin/bash

# Script di setup rapido per Sublima WebView
# Esegui con: bash setup.sh

set -e  # Exit on error

echo "========================================="
echo "  Sublima WebView - Setup Rapido"
echo "========================================="
echo ""

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verifica Flutter installato
echo "📋 Verifico installazione Flutter..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ Flutter non trovato!${NC}"
    echo ""
    echo "Installa Flutter seguendo la guida in INSTALL_FLUTTER.md"
    echo "Oppure esegui:"
    echo ""
    echo "  cd ~"
    echo "  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz"
    echo "  tar xf flutter_linux_3.16.0-stable.tar.xz"
    echo "  echo 'export PATH=\"\$PATH:\$HOME/flutter/bin\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Flutter trovato${NC}"
flutter --version
echo ""

# Flutter doctor
echo "🔍 Controllo ambiente di sviluppo..."
flutter doctor
echo ""

# Installa dipendenze
echo "📦 Installo dipendenze Flutter..."
flutter pub get
echo -e "${GREEN}✓ Dipendenze installate${NC}"
echo ""

# Verifica dispositivi disponibili
echo "📱 Dispositivi disponibili:"
flutter devices
echo ""

# Analizza codice
echo "🔬 Analizzo codice..."
flutter analyze
echo ""

echo "========================================="
echo -e "${GREEN}✓ Setup completato!${NC}"
echo "========================================="
echo ""
echo "Prossimi passi:"
echo ""
echo "1. Avvia emulatore Android/iOS o collega dispositivo"
echo ""
echo "2. Run app in debug:"
echo -e "   ${YELLOW}flutter run${NC}"
echo ""
echo "3. Build release:"
echo -e "   ${YELLOW}flutter build apk --release${NC}              # Android APK"
echo -e "   ${YELLOW}flutter build appbundle --release${NC}        # Android Bundle (Play Store)"
echo -e "   ${YELLOW}flutter build ipa --release${NC}              # iOS (solo macOS)"
echo -e "   ${YELLOW}flutter build windows --release${NC}          # Windows"
echo ""
echo "4. Test veloce con Chrome (NO Mixed Content):"
echo -e "   ${YELLOW}flutter run -d chrome${NC}"
echo ""
echo "Per maggiori dettagli, vedi README.md e INSTALL_FLUTTER.md"
echo ""
