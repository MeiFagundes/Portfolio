import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/app/dependencies.dart';

import '../fakes.dart';

void main() {
  test('startup reads a saved preference through the injected store', () async {
    final store = FakeLocalePreferenceStore()..languageCode = 'en';
    final dependencies = await createAppDependencies(
      localePreferenceStore: store,
    );
    expect(dependencies.initialLanguageCode, 'en');
    expect(dependencies.localePreferenceStore, same(store));
  });

  test('storage read failures do not fail app initialization', () async {
    final store = FakeLocalePreferenceStore()..failRead = true;
    final dependencies = await createAppDependencies(
      localePreferenceStore: store,
    );
    expect(dependencies.initialLanguageCode, isNull);
  });
}
