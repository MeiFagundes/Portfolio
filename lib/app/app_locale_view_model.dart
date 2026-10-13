import 'package:flutter/foundation.dart';

import '../data/services/locale_preference_store.dart';

class AppLocaleViewModel extends ChangeNotifier {
  AppLocaleViewModel({required this.store, String? initialLanguageCode})
    : _selectedLanguageCode = _validLanguageCode(initialLanguageCode);

  static const List<String> supportedLanguageCodes = ['pt', 'en'];

  final LocalePreferenceStore store;
  String? _selectedLanguageCode;
  Future<void> _pendingWrites = Future<void>.value();
  bool _disposed = false;

  String? get selectedLanguageCode => _selectedLanguageCode;

  static String resolveLanguageCode(List<String> languageCodes) {
    for (final languageCode in languageCodes) {
      final baseCode = languageCode.split(RegExp('[-_]')).first.toLowerCase();
      if (supportedLanguageCodes.contains(baseCode)) return baseCode;
    }
    return 'pt';
  }

  Future<void> selectLanguage(String languageCode) {
    if (_disposed || !supportedLanguageCodes.contains(languageCode)) {
      return Future<void>.value();
    }

    if (_selectedLanguageCode != languageCode) {
      _selectedLanguageCode = languageCode;
      notifyListeners();
    }

    _pendingWrites = _pendingWrites.then((_) async {
      try {
        await store.writeLanguageCode(languageCode);
      } catch (_) {
        // A preference write is best-effort; the in-memory selection remains.
      }
    });
    return _pendingWrites;
  }

  static String? _validLanguageCode(String? languageCode) {
    if (languageCode == null ||
        !supportedLanguageCodes.contains(languageCode)) {
      return null;
    }
    return languageCode;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
