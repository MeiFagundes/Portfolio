enum ProjectLinkType { launch, download, source, unknown }

class ProjectModel {
  final String title;
  final Map<String, ProjectDescription> descriptions;
  final List<String> technologies;
  final String imagePath;
  final List<ProjectLink> links;

  ProjectModel({
    required this.title,
    required Map<String, ProjectDescription> descriptions,
    required List<String> technologies,
    required this.imagePath,
    required List<ProjectLink> links,
  }) : descriptions = Map.unmodifiable(descriptions),
       technologies = List.unmodifiable(technologies),
       links = List.unmodifiable(links);

  ProjectDescription descriptionForLanguage(String languageCode) {
    final normalized = languageCode.toLowerCase().split(RegExp('[-_]')).first;
    return descriptions[normalized] ?? descriptions['pt']!;
  }
}

class ProjectDescription {
  final String concept;
  final String implementation;

  const ProjectDescription({
    required this.concept,
    required this.implementation,
  });
}

class ProjectLink {
  final ProjectLinkType type;
  final String uri;

  const ProjectLink({required this.type, required this.uri});
}
