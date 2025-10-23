import 'package:shared_preferences/shared_preferences.dart';

/// Servizio per gestire il salvataggio persistente dell'URL del profilo Sublima
class StorageService {
  static const String _keyProfileUrl = 'sublima_profile_url';

  /// Normalizza l'URL assicurando la presenza dello schema (https:// come default).
  ///
  /// Parametri:
  /// - [url]: URL da normalizzare
  ///
  /// Ritorna: URL con schema oppure stringa originale se vuota/nulla.
  String _normalizeUrl(String? url) {
    if (url == null) {
      return '';
    }

    final trimmedUrl = url.trim();
    if (trimmedUrl.isEmpty) {
      return '';
    }

    if (!trimmedUrl.startsWith('http://') &&
        !trimmedUrl.startsWith('https://')) {
      return 'https://$trimmedUrl';
    }

    return trimmedUrl;
  }

  /// Salva l'URL del profilo Sublima
  ///
  /// Parametri:
  /// - [url]: URL completo del profilo (es. https://cloud.sublima.it/profilo/s1087)
  Future<void> saveProfileUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedUrl = _normalizeUrl(url);
    await prefs.setString(_keyProfileUrl, normalizedUrl);
  }

  /// Recupera l'URL salvato
  ///
  /// Ritorna:
  /// - String con URL se configurato
  /// - null se non ancora configurato
  Future<String?> getProfileUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUrl = prefs.getString(_keyProfileUrl);
    if (storedUrl == null || storedUrl.isEmpty) {
      return null;
    }
    final normalizedUrl = _normalizeUrl(storedUrl);
    if (normalizedUrl.isEmpty) {
      return null;
    }
    return normalizedUrl;
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
