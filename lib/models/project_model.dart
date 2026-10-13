enum ProjectLinkType { launch, download, source, unknown }

class ProjectModel {
  final String title;
  final String description;
  final String imagePath;
  final List<ProjectLink> links;

  ProjectModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required List<ProjectLink> links,
  }) : links = List.unmodifiable(links);
}

class ProjectLink {
  final ProjectLinkType type;
  final String uri;

  const ProjectLink({required this.type, required this.uri});
}
