import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/data/repositories/project_repository.dart';
import 'package:meifagundesdotcom/data/services/project_service.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

void main() {
  group('FirestoreProjectRepository', () {
    test('maps project fields and known and unknown link types', () async {
      final repository = FirestoreProjectRepository(
        FakeProjectService([
          _document(
            title: 'Project',
            links: [
              {'type': 'launch', 'url': 'https://example.com'},
              {'type': 'download', 'url': 'https://example.com/download'},
              {'type': 'source', 'url': 'https://example.com/source'},
              {'type': 'preview', 'url': 'https://example.com/preview'},
            ],
          ),
        ]),
      );

      final projects = await repository.loadProjects();

      expect(projects, hasLength(1));
      expect(projects.single.title, 'Project');
      expect(projects.single.description, 'Description for Project');
      expect(projects.single.imagePath, 'images/project.png');
      expect(projects.single.links.map((link) => link.type), [
        ProjectLinkType.launch,
        ProjectLinkType.download,
        ProjectLinkType.source,
        ProjectLinkType.unknown,
      ]);
      expect(projects.single.links.last.uri, 'https://example.com/preview');
    });

    test(
      'preserves service order and returns an immutable project list',
      () async {
        final repository = FirestoreProjectRepository(
          FakeProjectService([
            _document(title: 'Second'),
            _document(title: 'First'),
          ]),
        );

        final projects = await repository.loadProjects();

        expect(projects.map((project) => project.title), ['Second', 'First']);
        expect(() => projects.add(_model('Third')), throwsUnsupportedError);
      },
    );

    test('copies links into an immutable model list', () {
      final links = <ProjectLink>[
        const ProjectLink(
          type: ProjectLinkType.launch,
          uri: 'https://example.com',
        ),
      ];
      final project = ProjectModel(
        title: 'Project',
        description: 'Description',
        imagePath: 'image.png',
        links: links,
      );
      links.clear();

      expect(project.links, hasLength(1));
      expect(() => project.links.clear(), throwsUnsupportedError);
    });

    test('rejects malformed project fields and links', () async {
      final malformedDocuments = <Map<String, dynamic>>[
        _document()..['title'] = '',
        _document()..['links'] = null,
        _document()..['links'] = ['not a link map'],
        _document()
          ..['links'] = [
            {'type': 'launch', 'url': ''},
          ],
      ];

      for (final document in malformedDocuments) {
        final repository = FirestoreProjectRepository(
          FakeProjectService([document]),
        );
        await expectLater(repository.loadProjects(), throwsFormatException);
      }
    });

    test('propagates service failures', () async {
      final error = StateError('service unavailable');
      final repository = FirestoreProjectRepository(
        FakeProjectService.failure(error),
      );

      await expectLater(repository.loadProjects(), throwsA(same(error)));
    });
  });
}

Map<String, dynamic> _document({
  String title = 'Project',
  List<dynamic> links = const [],
}) => {
  'title': title,
  'description': 'Description for $title',
  'imageUrl': 'images/project.png',
  'links': links,
};

ProjectModel _model(String title) => ProjectModel(
  title: title,
  description: 'Description',
  imagePath: 'image.png',
  links: const [],
);

class FakeProjectService implements ProjectService {
  FakeProjectService(this.documents) : error = null;

  FakeProjectService.failure(this.error) : documents = const [];

  final List<Map<String, dynamic>> documents;
  final Object? error;

  @override
  Future<List<Map<String, dynamic>>> loadProjects() {
    final error = this.error;
    if (error != null) return Future.error(error);
    return Future.value(documents);
  }
}
