; Inno Setup Script per Sublima WebView
; Questo script crea un installer Windows che include WebView2 Runtime

[Setup]
AppName=Sublima WebView
AppVersion=1.0.1
AppPublisher=Sublima ERP
AppPublisherURL=https://sublima.it
AppSupportURL=https://sublima.it/support
AppUpdatesURL=https://sublima.it/downloads
DefaultDirName={localappdata}\Sublima
DefaultGroupName=Sublima WebView
OutputDir=Output
OutputBaseFilename=SublimaWebView-Setup-1.0.1
SourceDir=.
Compression=lzma2
SolidCompression=yes
MinVersion=10.0.17763
PrivilegesRequired=admin
WizardStyle=modern
UninstallDisplayIcon={app}\sublima_webview.exe
SetupIconFile=assets\images\logosublimapiccolo.ico

; Lingue disponibili
[Languages]
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

; File da installare
[Files]
; Applicazione Flutter (corretto percorso senza x64 se build standard)
; NOTA: Verifica se il percorso corretto è build\windows\runner\Release\ o build\windows\x64\runner\Release\
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Cartella data (assets Flutter)
Source: "build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; Icona (copiata nella root dell'app) - opzionale se esiste
Source: "assets\images\logosublimapiccolo.ico"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

; Cartelle da creare
[Dirs]
Name: "{app}\data"

; Icone nel menu Start
[Icons]
Name: "{group}\Sublima WebView"; Filename: "{app}\sublima_webview.exe"; Comment: "Client WebView per Sublima ERP"; IconFilename: "{app}\logosublimapiccolo.ico"
Name: "{commondesktop}\Sublima WebView"; Filename: "{app}\sublima_webview.exe"; Comment: "Client WebView per Sublima ERP"; Tasks: desktopicon; IconFilename: "{app}\logosublimapiccolo.ico"

; Task personalizzati (opzionali)
[Tasks]
Name: "desktopicon"; Description: "Crea icona sul Desktop"; GroupDescription: "Icone aggiuntive:"

; Comandi da eseguire
[Run]
; Scarica e installa WebView2 Runtime da internet
Filename: "https://go.microsoft.com/fwlink/p/?LinkId=2124703"; Parameters: ""; StatusMsg: "Installazione WebView2 Runtime..."; Flags: shellexec waituntilterminated skipifdoesntexist
; Avvia l'applicazione dopo l'installazione
Filename: "{app}\sublima_webview.exe"; Description: "Avvia Sublima WebView"; Flags: nowait postinstall skipifsilent

; Configurazione disinstallazione
[UninstallDelete]
Type: filesandordirs; Name: "{app}"

; Sezione per messaggi personalizzati (opzionale)
[CustomMessages]
italian.WelcomeLabel1=Benvenuto in Sublima WebView Setup
italian.WelcomeLabel2=Questo installer installerà Sublima WebView e tutte le dipendenze necessarie (WebView2 Runtime).%n%nFare clic su Avanti per continuare.
italian.FinishedLabel=L'installazione di Sublima WebView è stata completata.%n%nFare clic su Fine per uscire da Setup.

english.WelcomeLabel1=Welcome to Sublima WebView Setup
english.WelcomeLabel2=This installer will install Sublima WebView and all required dependencies (WebView2 Runtime).%n%nClick Next to continue.
english.FinishedLabel=Sublima WebView installation has been completed.%n%nClick Finish to exit Setup.

; Controlli pre-installazione
[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  AppPath: String;
  PinScript: String;
begin
  if CurStep = ssPostInstall then
  begin
    if IsTaskSelected('taskbaricon') then
    begin
      AppPath := ExpandConstant('{app}\sublima_webview.exe');
      // Pinnare sulla taskbar usando PowerShell
      PinScript := 'powershell -Command "$app = [Windows.UI.Shell.ShellLink]::new(''' + AppPath + '''); $app.SaveAsync()''"';
    end;
  end;
end;

function InitializeUninstall(): Boolean;
begin
  Result := True;
end;
