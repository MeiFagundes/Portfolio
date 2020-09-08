import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/views/home/project_item.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class ProjectListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              'Projetos pessoais',
              style: TextStyles.title,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: ProjectModel.projects
                  .map((project) => ProjectItem(project))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
