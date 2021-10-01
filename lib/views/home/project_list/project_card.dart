import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/utils/application_util.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  ProjectCard(this.project);

  @override
  Widget build(BuildContext context) {
    final isMobileDevice = ApplicationUtil.isMobileDevice(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        constraints: BoxConstraints(
            maxWidth: 850, maxHeight: isMobileDevice ? 580 : 265),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Flex(
              direction: isMobileDevice ? Axis.vertical : Axis.horizontal,
              children: [
                Expanded(
                  flex: 55,
                  child: Column(
                    mainAxisAlignment: isMobileDevice
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.start,
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
                      isMobileDevice
                          ? Text(
                              project.description,
                              style: TextStyles.projectDescription,
                              textAlign: TextAlign.left,
                              softWrap: true,
                            )
                          : Expanded(
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
                Spacer(flex: isMobileDevice ? 1 : 3),
                Expanded(
                  flex: isMobileDevice ? 55 : 45,
                  child: Image.network(project.imagePath),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
