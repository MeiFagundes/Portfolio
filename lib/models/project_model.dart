import 'package:flutter/cupertino.dart';

class ProjectModel {
  String title;
  String description;
  String imagePath;
  List<ProjectLink> links;

  ProjectModel({this.title, this.description, this.imagePath, this.links});
}

class ProjectLink {
  IconData icon;
  String description;
  String uri;

  ProjectLink({this.icon, this.description, this.uri});
}
