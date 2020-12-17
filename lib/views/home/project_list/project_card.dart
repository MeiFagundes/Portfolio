import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  ProjectCard(this.project);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        constraints: BoxConstraints(maxWidth: 850, maxHeight: 265),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          project.title,
                          style: TextStyles.projectTitle,
                          softWrap: true,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          project.description,
                          style: TextStyles.projectDescription,
                          textAlign: TextAlign.left,
                          softWrap: true,
                        ),
                      ),
                      Wrap(
                        spacing: 15,
                        runAlignment: WrapAlignment.start,
                        children: <Widget>[
                          for (final link in project.links)
                            IconButton(
                              tooltip: link.description,
                              onPressed: () => UrlUtil.openURI(link.uri),
                              icon: Icon(link.icon),
                              splashRadius: 30,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 3),
                Expanded(
                  flex: 45,
                  child: Image.asset(project.imagePath),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
