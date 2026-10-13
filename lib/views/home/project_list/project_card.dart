import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/shared/shared.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard(this.project, {super.key});

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
        title,
        description,
        const SizedBox(height: 15),
        image,
        const SizedBox(height: 15),
        links(context),
      ],
    );
  }

  Widget desktopLayout(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, description, const SizedBox(height: 55)],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: image,
            ),
          ],
        ),
        links(context),
      ],
    );
  }

  Widget get title => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(project.title, style: TextStyles.projectTitle, softWrap: true),
  );

  Widget get description => Text(
    project.description,
    style: TextStyles.projectDescription,
    textAlign: TextAlign.left,
    softWrap: true,
  );

  Widget links(BuildContext context) => Wrap(
    spacing: 5,
    runAlignment: WrapAlignment.start,
    children: <Widget>[
      for (final link in project.links)
        link.hightlighted
            ? ElevatedButton.icon(
                label: Text(
                  link.description,
                  style: const TextStyle(color: Colors.white),
                ),
                icon: Icon(link.icon, color: Colors.white),
                onPressed: () => UrlUtil.openWithFeedback(context, link.uri),
              )
            : TextButton.icon(
                label: Text(link.description),
                icon: Icon(link.icon, color: Colors.pinkAccent),
                onPressed: () => UrlUtil.openWithFeedback(context, link.uri),
              ),
    ],
  );

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
