import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/views/shared/custom_icons.dart';

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

  factory ProjectModel.fromMap(Map<String, dynamic> data) {
    final title = _requiredString(data, 'title');
    final description = _requiredString(data, 'description');
    final imagePath = _requiredString(data, 'imageUrl');
    final rawLinks = data['links'];
    if (rawLinks is! List) {
      throw const FormatException('Project field "links" must be a list.');
    }

    final links = <ProjectLink>[];
    for (var index = 0; index < rawLinks.length; index++) {
      final rawLink = rawLinks[index];
      if (rawLink is! Map) {
        throw FormatException('Project link at index $index must be a map.');
      }

      final type = _requiredString(rawLink, 'type');
      final uri = _requiredString(rawLink, 'url');
      links.add(ProjectLink.fromType(type: type, uri: uri));
    }

    return ProjectModel(
      title: title,
      description: description,
      imagePath: imagePath,
      links: links,
    );
  }

  static String _requiredString(Map data, String field) {
    final value = data[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Project field "$field" must be a non-empty string.',
      );
    }
    return value;
  }
}

class ProjectLink {
  final IconData icon;
  final String description;
  final String uri;
  final bool hightlighted;

  ProjectLink({
    required this.icon,
    required this.description,
    required this.uri,
    this.hightlighted = false,
  });

  ProjectLink.fromType({required String type, required this.uri})
    : icon = _getIconByType(type),
      description = _getDescriptionByType(type),
      hightlighted = type == 'launch';

  static String _getDescriptionByType(String type) {
    switch (type) {
      case 'launch':
        return 'Acessar';
      case 'download':
        return 'Baixar';
      case 'source':
        return 'Ver no GitHub';
      default:
        return '';
    }
  }

  static IconData _getIconByType(String type) {
    switch (type) {
      case 'launch':
        return Icons.launch_rounded;
      case 'download':
        return Icons.download;
      case 'source':
        return CustomIcons.github;
      default:
        return Icons.circle;
    }
  }
}
