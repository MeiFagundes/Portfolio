import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalePreferenceStore {
  Future<String?> readLanguageCode();

  Future<void> writeLanguageCode(String languageCode);
}

class SharedPreferencesLocalePreferenceStore implements LocalePreferenceStore {
  SharedPreferencesLocalePreferenceStore(this._preferences);

  static const String _languageCodeKey = 'portfolio_language';

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> readLanguageCode() =>
      _preferences.getString(_languageCodeKey);

  @override
  Future<void> writeLanguageCode(String languageCode) =>
      _preferences.setString(_languageCodeKey, languageCode);
}
