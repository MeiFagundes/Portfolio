import 'package:meifagundesdotcom/data/services/project_service.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

abstract interface class ProjectRepository {
  Future<List<ProjectModel>> loadProjects();
}

class FirestoreProjectRepository implements ProjectRepository {
  final ProjectService _service;

  FirestoreProjectRepository(this._service);

  @override
  Future<List<ProjectModel>> loadProjects() async {
    final documents = await _service.loadProjects();
    final projects = documents
        .map(_projectFromDocument)
        .toList(growable: false);
    return List.unmodifiable(projects);
  }

  ProjectModel _projectFromDocument(Map<String, dynamic> document) {
    final rawLinks = document['links'];
    if (rawLinks is! List) {
      throw const FormatException('Project field "links" must be a list.');
    }

    final links = <ProjectLink>[];
    for (var index = 0; index < rawLinks.length; index++) {
      final rawLink = rawLinks[index];
      if (rawLink is! Map) {
        throw FormatException('Project link at index $index must be a map.');
      }

      final rawType = _requiredString(rawLink, 'type');
      final uri = _requiredString(rawLink, 'url');
      links.add(ProjectLink(type: _linkType(rawType), uri: uri));
    }

    return ProjectModel(
      title: _requiredString(document, 'title'),
      description: _requiredString(document, 'description'),
      imagePath: _requiredString(document, 'imageUrl'),
      links: links,
    );
  }

  String _requiredString(Map document, String field) {
    final value = document[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Project field "$field" must be a non-empty string.',
      );
    }
    return value;
  }

  ProjectLinkType _linkType(String type) => switch (type) {
    'launch' => ProjectLinkType.launch,
    'download' => ProjectLinkType.download,
    'source' => ProjectLinkType.source,
    _ => ProjectLinkType.unknown,
  };
}
