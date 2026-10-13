import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key, required this.onSelectLanguage});

  final Future<void> Function(String) onSelectLanguage;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Semantics(
        label: strings.languageSelectorLabel,
        child: DropdownButton<String>(
          value: Localizations.localeOf(context).languageCode,
          borderRadius: BorderRadius.circular(16),
          hint: Text(strings.languageSelectorLabel),
          icon: const Icon(Icons.translate),
          items: [
            DropdownMenuItem(
              value: 'pt',
              child: Text(strings.portugueseLanguage),
            ),
            DropdownMenuItem(value: 'en', child: Text(strings.englishLanguage)),
          ],
          onChanged: (language) {
            if (language != null) unawaited(onSelectLanguage(language));
          },
        ),
      ),
    );
  }
}
