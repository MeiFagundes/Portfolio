import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/repositories/projects_repository.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_card.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class ProjectListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Projetos Pessoais',
                style: TextStyles.title,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final project in ProjectsRepository.getProjects())
                  ProjectCard(project),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
