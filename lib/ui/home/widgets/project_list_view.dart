import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/text_styles.dart';
import '../home_view_model.dart';
import 'project_card.dart';

/// Rendering only: data loading and retries belong to the home view model.
class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key, required this.viewModel});
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final Widget content;
    switch (viewModel.status) {
      case ProjectLoadStatus.initial:
      case ProjectLoadStatus.loading:
        content = const Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        );
      case ProjectLoadStatus.error:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(strings.projectsLoadError),
            TextButton(onPressed: viewModel.retry, child: Text(strings.retry)),
          ],
        );
      case ProjectLoadStatus.ready:
        content = viewModel.projects.isEmpty
            ? Text(strings.noProjects)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (final project in viewModel.projects)
                    ProjectCard(project, onOpenLink: viewModel.openLink),
                ],
              );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(strings.personalProjects, style: TextStyles.title),
          ),
          content,
        ],
      ),
    );
  }
}
