import 'dart:convert';

import 'package:http/http.dart' as http;

import 'project_service.dart';

class HttpProjectService implements ProjectService {
  HttpProjectService({
    required this.client,
    required this.endpoint,
    this.timeout = const Duration(seconds: 10),
  });

  final http.Client client;
  final Uri endpoint;
  final Duration timeout;

  @override
  Future<List<Map<String, dynamic>>> loadProjects() async {
    final response = await client
        .get(endpoint, headers: const {'Accept': 'application/json'})
        .timeout(timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'Project content request failed with HTTP ${response.statusCode}.',
        endpoint,
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Project content must be a JSON object.');
    }
    if (decoded['schemaVersion'] != 1) {
      throw FormatException(
        'Unsupported project content schema version "${decoded['schemaVersion']}".',
      );
    }
    final rawProjects = decoded['projects'];
    if (rawProjects is! List) {
      throw const FormatException('Project content "projects" must be a list.');
    }

    return List.unmodifiable(
      rawProjects.map((project) {
        if (project is! Map<String, dynamic>) {
          throw const FormatException('Each project must be a JSON object.');
        }
        return Map<String, dynamic>.unmodifiable(project);
      }),
    );
  }
}
