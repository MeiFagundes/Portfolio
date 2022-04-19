import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/shared/shared.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  ProjectCard(this.project);

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
              print(constraints.maxWidth);
              if (constraints.maxWidth >= 665)
                return desktopLayout;
              else
                return mobileLayout;
            },
          ),
        ),
      ),
    );
  }

  Widget get mobileLayout {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        description,
        SizedBox(height: 15),
        image,
        SizedBox(height: 15),
        links,
      ],
    );
  }

  Widget get desktopLayout {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                Container(
                  constraints: BoxConstraints(maxWidth: 350),
                  child: description,
                ),
                SizedBox(height: 55),
              ],
            ),
            SizedBox(width: 15),
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              child: image,
            )
          ],
        ),
        links,
      ],
    );
  }

  Widget get title => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          project.title,
          style: TextStyles.projectTitle,
          softWrap: true,
        ),
      );

  Widget get description => Text(
        project.description,
        style: TextStyles.projectDescription,
        textAlign: TextAlign.left,
        softWrap: true,
      );

  Widget get links => Wrap(
        spacing: 5,
        runAlignment: WrapAlignment.start,
        children: <Widget>[
          for (final link in project.links)
            link.hightlighted
                ? ElevatedButton.icon(
                    label: Text(link.description),
                    icon: Icon(link.icon),
                    onPressed: () => UrlUtil.openURI(link.uri),
                  )
                : TextButton.icon(
                    label: Text(link.description),
                    icon: Icon(link.icon),
                    onPressed: () => UrlUtil.openURI(link.uri),
                  ),
        ],
      );

  Widget get image => Center(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
          child: Image.network(project.imagePath)));
}
