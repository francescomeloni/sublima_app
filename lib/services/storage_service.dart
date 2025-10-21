import 'package:shared_preferences/shared_preferences.dart';

/// Servizio per gestire il salvataggio persistente dell'URL del profilo Sublima
class StorageService {
  static const String _keyProfileUrl = 'sublima_profile_url';

  /// Salva l'URL del profilo Sublima
  /// 
  /// Parametri:
  /// - [url]: URL completo del profilo (es. https://cloud.sublima.it/profilo/s1087)
  Future<void> saveProfileUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileUrl, url);
  }

  /// Recupera l'URL salvato
  /// 
  /// Ritorna:
  /// - String con URL se configurato
  /// - null se non ancora configurato
  Future<String?> getProfileUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileUrl);
  }

  /// Cancella configurazione salvata (per reset)
  Future<void> clearProfileUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfileUrl);
  }

  /// Verifica se esiste una configurazione salvata
  Future<bool> hasProfileUrl() async {
    final url = await getProfileUrl();
    return url != null && url.isNotEmpty;
  }
}
