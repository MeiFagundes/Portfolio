import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/l10n/generated/app_localizations.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/ui/core/shared.dart';
import 'package:meifagundesdotcom/ui/home/widgets/project_link_presentation.dart';

import 'technology_tags.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final Future<bool> Function(String) onOpenLink;

  const ProjectCard(this.project, {super.key, required this.onOpenLink});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusSizes.level1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 665 &&
                  MediaQuery.textScalerOf(context).scale(1) <= 1.2) {
                return desktopLayout(context);
              } else {
                return mobileLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget mobileLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textContent(context),
        const SizedBox(height: 15),
        image,
        const SizedBox(height: 15),
        links(context),
      ],
    );
  }

  Widget desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textContent(context),
              const SizedBox(height: 15),
              links(context),
            ],
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(width: 260, child: image),
      ],
    );
  }

  Widget textContent(BuildContext context) {
    final description = project.descriptionForLanguage(
      Localizations.localeOf(context).languageCode,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        Text(description.concept, style: TextStyles.projectDescription),
        const SizedBox(height: 10),
        Text(description.implementation, style: TextStyles.projectDescription),
        if (project.technologies.isNotEmpty) ...[
          const SizedBox(height: 12),
          TechnologyTags(technologies: project.technologies),
        ],
      ],
    );
  }

  Widget get title => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(project.title, style: TextStyles.projectTitle, softWrap: true),
  );

  Widget links(BuildContext context) => Wrap(
    spacing: 5,
    runSpacing: 5,
    runAlignment: WrapAlignment.start,
    children: <Widget>[
      for (final link in project.links)
        link.type.isHighlighted
            ? ElevatedButton.icon(
                label: Text(
                  link.type.label(AppLocalizations.of(context)),
                  style: const TextStyle(color: Colors.white),
                ),
                icon: Icon(link.type.icon, color: Colors.white),
                onPressed: () => _open(context, link.uri),
              )
            : TextButton.icon(
                label: Text(link.type.label(AppLocalizations.of(context))),
                icon: Icon(link.type.icon, color: Colors.pinkAccent),
                onPressed: () => _open(context, link.uri),
              ),
    ],
  );

  Future<void> _open(BuildContext context, String uri) async {
    if (!await onOpenLink(uri) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).linkOpenError)),
      );
    }
  }

  Widget get image => Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
      child: Image.network(
        project.imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox(
          height: 150,
          child: Center(child: Icon(Icons.broken_image_outlined)),
        ),
      ),
    ),
  );
}
