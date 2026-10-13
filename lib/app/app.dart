import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../ui/core/app_theme.dart';
import '../ui/home/home_view.dart';
import '../ui/home/home_view_model.dart';
import 'dependencies.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, required this.dependencies, this.locale});
  final AppDependencies dependencies;
  final Locale? locale;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _createViewModel();
  }

  void _createViewModel() {
    _viewModel = HomeViewModel(
      repository: widget.dependencies.projectRepository,
      linkLauncher: widget.dependencies.linkLauncher,
    )..loadProjects();
  }

  @override
  void didUpdateWidget(covariant PortfolioApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dependencies != widget.dependencies) {
      _viewModel.dispose();
      _createViewModel();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    theme: buildAppTheme(),
    locale: widget.locale,
    localeListResolutionCallback: (locales, supportedLocales) => Locale(
      _resolveLanguageCode(
        locales?.map((locale) => locale.languageCode).toList() ?? const [],
      ),
    ),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Home(viewModel: _viewModel),
  );

  static String _resolveLanguageCode(List<String> languageCodes) {
    for (final languageCode in languageCodes) {
      final baseCode = languageCode.split(RegExp('[-_]')).first.toLowerCase();
      if (const ['pt', 'en'].contains(baseCode)) return baseCode;
    }
    return 'pt';
  }
}
