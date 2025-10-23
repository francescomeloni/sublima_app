import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';
import 'screens/webview_screen.dart';
import 'services/storage_service.dart';

/// Entry point dell'applicazione Sublima WebView
void main() async {
  // Inizializza binding Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Forza orientamento portrait su mobile (opzionale, commenta se non necessario)
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // Avvia app
  runApp(const SublimaWebViewApp());
}

/// Widget root dell'applicazione
class SublimaWebViewApp extends StatelessWidget {
  const SublimaWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Colori ufficiali Sublima
    const Color sublimaBordeaux = Color(0xFF8B0000); // Bordeaux scuro
    const Color sublimaBlack = Color(0xFF000000); // Nero

    return MaterialApp(
      title: 'Sublima',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: sublimaBordeaux,
          brightness: Brightness.light,
          primary: sublimaBordeaux,
          secondary: sublimaBlack,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: sublimaBordeaux,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: sublimaBordeaux,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: sublimaBordeaux, width: 2),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// Splash screen che verifica se esiste configurazione salvata
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConfiguration();
  }

  /// Controlla se esiste URL salvato e naviga alla schermata appropriata
  Future<void> _checkConfiguration() async {
    // Simula splash screen (opzionale, rimuovi se non necessario)
    await Future.delayed(const Duration(milliseconds: 800));

    final profileUrl = await StorageService().getProfileUrl();

    if (!mounted) return;

    if (profileUrl != null && profileUrl.isNotEmpty) {
      // URL già configurato → vai direttamente alla WebView
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WebViewScreen(profileUrl: profileUrl),
        ),
      );
    } else {
      // Prima configurazione → mostra setup screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SetupScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color sublimaBordeaux = Color(0xFF8B0000);

    return Scaffold(
      backgroundColor: sublimaBordeaux,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Sublima
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logosublimapiccolo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Titolo
            const Text(
              'SUBLIMA',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ERP Cloud',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
