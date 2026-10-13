import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/ui/home/home_view_model.dart';
import 'package:meifagundesdotcom/l10n/generated/app_localizations.dart';
import 'package:meifagundesdotcom/app/portfolio_content.dart';
import 'package:meifagundesdotcom/ui/home/widgets/profile.dart';
import 'package:meifagundesdotcom/ui/home/widgets/project_list_view.dart';
import 'package:meifagundesdotcom/ui/core/padding_sizes.dart';

import 'widgets/language_selector.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
    required this.viewModel,
    required this.onSelectLanguage,
  });
  final HomeViewModel viewModel;
  final Future<void> Function(String) onSelectLanguage;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth >= 1160 &&
                      constraints.maxHeight >= 700 &&
                      MediaQuery.textScalerOf(context).scale(1) <= 1.2
                  ? desktopLayout(context)
                  : mobileLayout(context);
            },
          ),
        ),
      ),
    );
  }

  Widget mobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  LanguageSelector(onSelectLanguage: onSelectLanguage),
                  Profile(onOpenLink: viewModel.openLink),
                  const Divider(),
                  projectList,
                  sourceButton(context),
                  versionNumber(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget desktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1500),
        child: Row(
          children: [
            SizedBox(width: PaddingSizes.homePadding),
            Expanded(
              flex: 5,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 700),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LanguageSelector(onSelectLanguage: onSelectLanguage),
                      Profile(onOpenLink: viewModel.openLink),
                      sourceButton(context),
                      versionNumber(context),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: PaddingSizes.homePadding),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(child: projectList),
            ),
          ],
        ),
      ),
    );
  }

  Widget sourceButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context).builtWith,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            letterSpacing: 0.7,
          ),
        ),
        const FlutterLogo(size: 58, style: FlutterLogoStyle.horizontal),
      ],
    );
  }

  Widget versionNumber(BuildContext context) {
    return Text(
      AppLocalizations.of(context).appVersion(PortfolioContent.version),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget get projectList => ProjectListView(viewModel: viewModel);
}
