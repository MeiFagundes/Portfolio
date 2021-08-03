import 'package:flutter/cupertino.dart';

class ProjectModel {
  String title;
  String description;
  String imagePath;
  List<ProjectLink> links;

  ProjectModel(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.links});
}

class ProjectLink {
  IconData icon;
  String description;
  String uri;

  ProjectLink(
      {required this.icon, required this.description, required this.uri});
}
