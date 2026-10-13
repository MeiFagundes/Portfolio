import 'package:meifagundesdotcom/data/services/project_service.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

abstract interface class ProjectRepository {
  Future<List<ProjectModel>> loadProjects();
}

class DefaultProjectRepository implements ProjectRepository {
  final ProjectService _service;

  DefaultProjectRepository(this._service);

  @override
  Future<List<ProjectModel>> loadProjects() async {
    final documents = await _service.loadProjects();
    final ids = <String>{};
    for (final document in documents) {
      final id = _requiredString(document, 'id');
      if (!ids.add(id)) throw FormatException('Duplicate project id "$id".');
      final priority = document['priority'];
      if (priority is! int) {
        throw FormatException('Project "$id" priority must be an integer.');
      }
    }
    final orderedDocuments = List<Map<String, dynamic>>.of(documents);
    orderedDocuments.sort((a, b) {
      final priority = (a['priority'] as int).compareTo(b['priority'] as int);
      return priority != 0
          ? priority
          : (a['id'] as String).compareTo(b['id'] as String);
    });
    final projects = orderedDocuments.map(_projectFromDocument).toList();
    return List.unmodifiable(projects);
  }

  ProjectModel _projectFromDocument(Map<String, dynamic> document) {
    final rawDescriptions = document['descriptions'];
    if (rawDescriptions is! Map ||
        rawDescriptions.length != 2 ||
        !rawDescriptions.containsKey('pt') ||
        !rawDescriptions.containsKey('en')) {
      throw const FormatException(
        'Project field "descriptions" must contain Portuguese and English.',
      );
    }
    final descriptions = <String, ProjectDescription>{};
    for (final language in const ['pt', 'en']) {
      final rawDescription = rawDescriptions[language];
      if (rawDescription is! Map ||
          rawDescription.length != 2 ||
          !rawDescription.containsKey('concept') ||
          !rawDescription.containsKey('implementation')) {
        throw FormatException(
          'Project description "$language" must contain concept and implementation.',
        );
      }
      descriptions[language] = ProjectDescription(
        concept: _requiredString(rawDescription, 'concept'),
        implementation: _requiredString(rawDescription, 'implementation'),
      );
    }

    final rawTechnologies = document['technologies'];
    if (rawTechnologies is! List) {
      throw const FormatException(
        'Project field "technologies" must be a list.',
      );
    }
    final technologies = <String>[];
    final normalizedTechnologies = <String>{};
    for (final rawTechnology in rawTechnologies) {
      final technology = _requiredStringValue(rawTechnology, 'technology');
      if (!normalizedTechnologies.add(technology.trim().toLowerCase())) {
        throw FormatException(
          'Project has duplicate technology "$technology".',
        );
      }
      technologies.add(technology);
    }

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
      final type = _linkType(rawType);
      if (type == ProjectLinkType.unknown) {
        throw FormatException('Unsupported project link type "$rawType".');
      }
      _requiredUri(uri, 'link URL');
      links.add(ProjectLink(type: type, uri: uri));
    }

    final imageUrl = _requiredString(document, 'imageUrl');
    _requiredUri(imageUrl, 'imageUrl');

    return ProjectModel(
      title: _requiredString(document, 'title'),
      descriptions: descriptions,
      technologies: technologies,
      imagePath: imageUrl,
      links: links,
    );
  }

  void _requiredUri(String value, String field) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      throw FormatException('Project field "$field" must be an HTTP(S) URL.');
    }
  }

  String _requiredString(Map document, String field) {
    return _requiredStringValue(document[field], field);
  }

  String _requiredStringValue(Object? value, String field) {
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
