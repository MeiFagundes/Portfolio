import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:meifagundesdotcom/data/services/http_project_service.dart';

void main() {
  final endpoint = Uri.parse('https://content.example.test/v1/projects.json');

  group('HttpProjectService', () {
    test('loads project objects from schema version 1', () async {
      final service = HttpProjectService(
        client: MockClient((request) async {
          expect(request.url, endpoint);
          expect(request.headers['accept'], 'application/json');
          return http.Response(
            jsonEncode({
              'schemaVersion': 1,
              'projects': [
                {'id': 'sample', 'priority': 0},
              ],
            }),
            200,
          );
        }),
        endpoint: endpoint,
      );

      expect(await service.loadProjects(), [
        {'id': 'sample', 'priority': 0},
      ]);
    });

    test('accepts an empty project list', () async {
      final service = _service(
        endpoint,
        MockClient(
          (_) async => http.Response('{"schemaVersion":1,"projects":[]}', 200),
        ),
      );

      expect(await service.loadProjects(), isEmpty);
    });

    test('rejects an unsupported schema or malformed envelope', () async {
      for (final body in [
        '{"schemaVersion":2,"projects":[]}',
        '{"schemaVersion":1,"projects":{}}',
        '{"schemaVersion":1,"projects":[null]}',
        'not json',
      ]) {
        final service = _service(
          endpoint,
          MockClient((_) async => http.Response(body, 200)),
        );
        await expectLater(service.loadProjects(), throwsFormatException);
      }
    });

    test('reports non-success HTTP responses', () async {
      final service = _service(
        endpoint,
        MockClient((_) async => http.Response('unavailable', 503)),
      );

      await expectLater(
        service.loadProjects(),
        throwsA(isA<http.ClientException>()),
      );
    });

    test('applies the configured timeout', () async {
      final pendingResponse = Completer<http.Response>();
      final service = HttpProjectService(
        client: MockClient((_) => pendingResponse.future),
        endpoint: endpoint,
        timeout: const Duration(milliseconds: 1),
      );

      await expectLater(
        service.loadProjects(),
        throwsA(isA<TimeoutException>()),
      );
      pendingResponse.complete(http.Response('{}', 200));
    });
  });
}

HttpProjectService _service(Uri endpoint, http.Client client) =>
    HttpProjectService(client: client, endpoint: endpoint);
