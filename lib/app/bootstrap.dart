import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../ui/core/app_theme.dart';
import 'app.dart';
import 'bootstrap_view_model.dart';
import 'dependencies.dart';
import 'app_locale_view_model.dart';

class PortfolioBootstrap extends StatefulWidget {
  const PortfolioBootstrap({super.key, required this.initialize, this.locale});
  final Future<AppDependencies> Function() initialize;
  final Locale? locale;

  @override
  State<PortfolioBootstrap> createState() => _PortfolioBootstrapState();
}

class _PortfolioBootstrapState extends State<PortfolioBootstrap> {
  late BootstrapViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BootstrapViewModel(initialize: widget.initialize)
      ..initialize();
  }

  void _createViewModel() {
    _viewModel = BootstrapViewModel(initialize: widget.initialize)
      ..initialize();
  }

  @override
  void didUpdateWidget(covariant PortfolioBootstrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialize != widget.initialize) {
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
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) {
      if (_viewModel.status == BootstrapStatus.ready) {
        return PortfolioApp(
          dependencies: _viewModel.dependencies!,
          locale: widget.locale,
        );
      }
      return MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        theme: buildAppTheme(),
        locale: widget.locale,
        localeListResolutionCallback: (locales, supportedLocales) => Locale(
          AppLocaleViewModel.resolveLanguageCode(
            locales?.map((locale) => locale.languageCode).toList() ?? const [],
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final strings = AppLocalizations.of(context);
            return Scaffold(
              body: Center(
                child: _viewModel.status == BootstrapStatus.error
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(strings.portfolioLoadError),
                          TextButton(
                            onPressed: _viewModel.initialize,
                            child: Text(strings.retry),
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              ),
            );
          },
        ),
      );
    },
  );
}
