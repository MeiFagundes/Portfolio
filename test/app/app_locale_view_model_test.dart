import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/app/app_locale_view_model.dart';
import 'package:meifagundesdotcom/data/services/locale_preference_store.dart';

void main() {
  test('Invalid initial language code is cleared', () {
    final model = AppLocaleViewModel(
      store: _FakeLocalePreferenceStore(),
      initialLanguageCode: 'fr',
    );
    addTearDown(model.dispose);

    expect(model.selectedLanguageCode, isNull);
  });

  test('Browser language resolver chooses the first supported base code', () {
    expect(AppLocaleViewModel.resolveLanguageCode(['pt-BR', 'en-US']), 'pt');
    expect(AppLocaleViewModel.resolveLanguageCode(['fr-FR', 'en-US']), 'en');
    expect(AppLocaleViewModel.resolveLanguageCode(['fr', 'es']), 'pt');
  });

  test(
    'Selection updates immediately and persists the selected code',
    () async {
      final store = _FakeLocalePreferenceStore();
      final model = AppLocaleViewModel(store: store, initialLanguageCode: 'pt');
      addTearDown(model.dispose);
      var notifications = 0;
      model.addListener(() => notifications++);

      final save = model.selectLanguage('en');
      expect(model.selectedLanguageCode, 'en');
      expect(notifications, 1);
      await save;

      expect(store.writes, ['en']);
      await model.selectLanguage('invalid');
      expect(model.selectedLanguageCode, 'en');
      expect(store.writes, ['en']);
    },
  );

  test('Rapid selections persist in order so the latest choice wins', () async {
    final firstWrite = Completer<void>();
    final store = _FakeLocalePreferenceStore(
      onWrite: (code) {
        if (code == 'en') return firstWrite.future;
        return Future<void>.value();
      },
    );
    final model = AppLocaleViewModel(store: store);
    addTearDown(model.dispose);

    final englishSave = model.selectLanguage('en');
    final portugueseSave = model.selectLanguage('pt');
    expect(model.selectedLanguageCode, 'pt');
    await Future<void>.delayed(Duration.zero);
    expect(store.writes, ['en']);

    firstWrite.complete();
    await Future.wait([englishSave, portugueseSave]);
    expect(store.writes, ['en', 'pt']);
    expect(store.writes.last, model.selectedLanguageCode);
  });

  test('Preference write failure is nonfatal', () async {
    final store = _FakeLocalePreferenceStore(
      onWrite: (_) async {
        throw StateError('storage unavailable');
      },
    );
    final model = AppLocaleViewModel(store: store);
    addTearDown(model.dispose);

    await expectLater(model.selectLanguage('en'), completes);
    expect(model.selectedLanguageCode, 'en');
  });

  test('Disposed model ignores subsequent selections', () async {
    final store = _FakeLocalePreferenceStore();
    final model = AppLocaleViewModel(store: store, initialLanguageCode: 'pt');
    var notifications = 0;
    model.addListener(() => notifications++);
    model.dispose();

    await model.selectLanguage('en');

    expect(model.selectedLanguageCode, 'pt');
    expect(notifications, 0);
    expect(store.writes, isEmpty);
  });
}

class _FakeLocalePreferenceStore implements LocalePreferenceStore {
  _FakeLocalePreferenceStore({this.onWrite});

  final Future<void> Function(String languageCode)? onWrite;
  final List<String> writes = [];

  @override
  Future<String?> readLanguageCode() async => null;

  @override
  Future<void> writeLanguageCode(String languageCode) {
    writes.add(languageCode);
    return onWrite?.call(languageCode) ?? Future<void>.value();
  }
}
