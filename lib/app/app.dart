import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../ui/core/app_theme.dart';
import '../ui/home/home_view.dart';
import '../ui/home/home_view_model.dart';
import 'dependencies.dart';
import 'app_locale_view_model.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, required this.dependencies, this.locale});
  final AppDependencies dependencies;
  final Locale? locale;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late HomeViewModel _viewModel;
  late AppLocaleViewModel _localeViewModel;

  @override
  void initState() {
    super.initState();
    _createViewModel();
  }

  void _createViewModel() {
    _localeViewModel = AppLocaleViewModel(
      store: widget.dependencies.localePreferenceStore,
      initialLanguageCode: widget.dependencies.initialLanguageCode,
    );
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
      _localeViewModel.dispose();
      _createViewModel();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _localeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _localeViewModel,
    builder: (context, child) => MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildAppTheme(),
      locale:
          widget.locale ??
          (_localeViewModel.selectedLanguageCode == null
              ? null
              : Locale(_localeViewModel.selectedLanguageCode!)),
      localeListResolutionCallback: (locales, supportedLocales) => Locale(
        AppLocaleViewModel.resolveLanguageCode(
          locales?.map((locale) => locale.languageCode).toList() ?? const [],
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Home(
        viewModel: _viewModel,
        onSelectLanguage: _localeViewModel.selectLanguage,
      ),
    ),
  );
}
