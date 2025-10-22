import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as wf;
import 'package:url_launcher/url_launcher.dart';
import '../services/storage_service.dart';
import 'setup_screen.dart';

/// Schermata principale con WebView fullscreen
/// 
/// Carica il profilo Sublima con Mixed Content abilitato
/// per permettere comunicazione HTTPS → HTTP verso ZERO Esterno
class WebViewScreen extends StatefulWidget {
  final String profileUrl;

  const WebViewScreen({Key? key, required this.profileUrl}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _isLoading = true;
  String _currentUrl = '';

  /// Reset configurazione e torna al setup
  Future<void> _resetConfiguration() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Configurazione'),
        content: const Text(
          'Vuoi tornare alla schermata di setup?\n\n'
          'L\'URL del profilo verrà eliminato e dovrai configurarlo nuovamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Conferma'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageService().clearProfileUrl();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SetupScreen()),
      );
    }
  }

  /// Mostra menu opzioni
  Future<void> _showMenu() async {
    if (kIsWeb) {
      // Su web mostra solo reset
      _resetConfiguration();
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Ricarica Pagina'),
              onTap: () {
                Navigator.pop(context);
                _webViewController?.reload();
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Vai alla Home'),
              onTap: () {
                Navigator.pop(context);
                _webViewController?.loadUrl(
                  urlRequest: URLRequest(url: WebUri(widget.profileUrl)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Cancella Cache'),
              onTap: () async {
                Navigator.pop(context);
                await _webViewController?.clearCache();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cancellata')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('URL Corrente'),
              subtitle: Text(
                _currentUrl.isEmpty ? widget.profileUrl : _currentUrl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.orange.shade700),
              title: const Text('Reset Configurazione'),
              onTap: () {
                Navigator.pop(context);
                _resetConfiguration();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color sublimaBordeaux = Color(0xFF8B0000);
    
    // Su Linux usa browser esterno invece di WebView
    if (Theme.of(context).platform == TargetPlatform.linux) {
      return _buildLinuxBrowserLauncher();
    }
    
    // Su Web mostra messaggio (InAppWebView non supportato)
    if (kIsWeb) {
      return _buildUnsupportedPlatformMessage();
    }

    return WillPopScope(
      onWillPop: () async {
        if (_webViewController != null) {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sublima'),
          backgroundColor: sublimaBordeaux,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _webViewController?.reload(),
              tooltip: 'Ricarica',
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showMenu,
              tooltip: 'Menu',
            ),
          ],
        ),
        body: Column(
          children: [
            if (_isLoading)
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B0000)),
              ),
            
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.profileUrl),
                ),
                initialSettings: InAppWebViewSettings(
                  // Mixed Content - fondamentale per HTTPS -> HTTP
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  
                  // Sicurezza e permessi
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  domStorageEnabled: true,
                  databaseEnabled: true,
                  cacheEnabled: true,
                  
                  // Media
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  
                  // Zoom
                  supportZoom: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  
                  // Geolocation
                  geolocationEnabled: true,
                  
                  // User Agent - identifica l'app
                  userAgent: 'SublimaWebView/1.0 (Flutter) Mobile',
                  
                  // Navigazione
                  useShouldOverrideUrlLoading: true,
                  useOnLoadResource: false,
                  clearCache: false,
                  supportMultipleWindows: false,
                  disableVerticalScroll: false,
                  disableHorizontalScroll: false,
                  
                  // Windows specific: Allow insecure content (HTTP da HTTPS)
                  // Queste opzioni potrebbero non essere disponibili su tutte le piattaforme
                  // ma non causano errori se ignorate
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                ),
                
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true;
                    _progress = 0;
                    if (url != null) {
                      _currentUrl = url.toString();
                    }
                  });
                },
                
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                
                onLoadStop: (controller, url) async {
                  setState(() {
                    _isLoading = false;
                    if (url != null) {
                      _currentUrl = url.toString();
                    }
                  });
                },
                
                onLoadError: (controller, url, code, message) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Errore caricamento: $message'),
                      backgroundColor: Colors.red.shade700,
                      action: SnackBarAction(
                        label: 'Riprova',
                        textColor: Colors.white,
                        onPressed: () => controller.reload(),
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                },
                
                onLoadHttpError: (controller, url, statusCode, description) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Errore HTTP $statusCode: $description'),
                      backgroundColor: Colors.orange.shade700,
                    ),
                  );
                },
                
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
                
                onConsoleMessage: (controller, consoleMessage) {
                  // Debug console - utile per diagnostica
                  // print('[Console] ${consoleMessage.messageLevel.name}: ${consoleMessage.message}');
                },
                
                // Gestione errori SSL/TLS - importante per certificati self-signed o HTTP
                onReceivedServerTrustAuthRequest: (controller, challenge) async {
                  // ATTENZIONE: In produzione valutare se accettare tutti i certificati
                  // Per ora permettiamo tutto per supportare Mixed Content
                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Schermata Linux - WebView embedded (supporto base, Mixed Content limitato)
  Widget _buildLinuxBrowserLauncher() {
    return _LinuxWebViewWidget(
      profileUrl: widget.profileUrl,
      onResetConfiguration: _resetConfiguration,
    );
  }

  /// Messaggio per piattaforme non supportate (Web)
  Widget _buildUnsupportedPlatformMessage() {
    return _buildWebPlatformMessage();
  }

  /// Widget per messaggio piattaforma Web
  Widget _buildWebPlatformMessage() {
    const platformName = 'Web';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sublima'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _resetConfiguration,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.web,
                  size: 80,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Piattaforma $platformName',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'InAppWebView non è disponibile su $platformName.\n\nPer testare completamente l\'app con Mixed Content,\nusa la versione Android, iOS o Windows.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.link, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        const Text(
                          'URL Configurato:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      widget.profileUrl,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _resetConfiguration,
                icon: const Icon(Icons.settings),
                label: const Text('Cambia Configurazione'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green.shade700, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Build per Android o Windows',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'flutter build apk --release\nflutter build windows --release',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget separato per Linux - apre browser esterno
/// webview_flutter non ha supporto completo per Linux embedded WebView
class _LinuxWebViewWidget extends StatefulWidget {
  final String profileUrl;
  final VoidCallback onResetConfiguration;

  const _LinuxWebViewWidget({
    required this.profileUrl,
    required this.onResetConfiguration,
  });

  @override
  State<_LinuxWebViewWidget> createState() => _LinuxWebViewWidgetState();
}

class _LinuxWebViewWidgetState extends State<_LinuxWebViewWidget> {
  bool _browserLaunched = false;

  @override
  void initState() {
    super.initState();
    // Apri automaticamente nel browser esterno
    _launchInBrowser();
  }

  Future<void> _launchInBrowser() async {
    final url = widget.profileUrl.startsWith('http') 
      ? widget.profileUrl 
      : 'https://${widget.profileUrl}';
    
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        setState(() {
          _browserLaunched = true;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossibile aprire il browser'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color sublimaBordeaux = Color(0xFF8B0000);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sublima'),
        backgroundColor: sublimaBordeaux,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onResetConfiguration,
            tooltip: 'Configurazione',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.desktop_windows,
                  size: 80,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Piattaforma Linux',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _browserLaunched
                    ? 'Browser esterno aperto con successo!'
                    : 'Apertura browser in corso...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Su Linux, Sublima WebView usa il browser di sistema.\n\n'
                'WebView embedded non è completamente supportato su Linux.\n'
                'Per WebView completo con Mixed Content, usa Android o Windows.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.link, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        const Text(
                          'URL Configurato:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      widget.profileUrl,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _launchInBrowser,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Riapri nel Browser'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: sublimaBordeaux,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: widget.onResetConfiguration,
                icon: const Icon(Icons.settings),
                label: const Text('Cambia Configurazione'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  foregroundColor: Colors.orange.shade700,
                  side: BorderSide(color: Colors.orange.shade700),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green.shade700, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Build per piattaforme con WebView completo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'flutter build apk --release\nflutter build windows --release',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
