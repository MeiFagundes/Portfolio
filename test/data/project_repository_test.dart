import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/data/repositories/project_repository.dart';
import 'package:meifagundesdotcom/data/services/project_service.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

void main() {
  group('DefaultProjectRepository', () {
    test('maps project fields and known link types', () async {
      final repository = DefaultProjectRepository(
        FakeProjectService([
          _document(
            title: 'Project',
            links: [
              {'type': 'launch', 'url': 'https://example.com'},
              {'type': 'download', 'url': 'https://example.com/download'},
              {'type': 'source', 'url': 'https://example.com/source'},
            ],
          ),
        ]),
      );

      final projects = await repository.loadProjects();

      expect(projects, hasLength(1));
      expect(projects.single.title, 'Project');
      expect(
        projects.single.descriptions['pt']!.concept,
        'Portuguese concept for Project',
      );
      expect(
        projects.single.descriptionForLanguage('en-US').implementation,
        'English implementation for Project',
      );
      expect(
        projects.single.descriptionForLanguage('es').concept,
        'Portuguese concept for Project',
      );
      expect(projects.single.technologies, ['Dart', 'Flutter']);
      expect(projects.single.imagePath, 'https://example.com/image.png');
      expect(projects.single.links.map((link) => link.type), [
        ProjectLinkType.launch,
        ProjectLinkType.download,
        ProjectLinkType.source,
      ]);
    });

    test('sorts by priority and ID and returns an immutable list', () async {
      final repository = DefaultProjectRepository(
        FakeProjectService([
          _document(title: 'Second', id: 'second', priority: 2),
          _document(title: 'First', id: 'first', priority: 1),
          _document(title: 'Tie B', id: 'b', priority: 3),
          _document(title: 'Tie A', id: 'a', priority: 3),
        ]),
      );

      final projects = await repository.loadProjects();

      expect(projects.map((project) => project.title), [
        'First',
        'Second',
        'Tie A',
        'Tie B',
      ]);
      expect(() => projects.add(_model('Third')), throwsUnsupportedError);
    });

    test('copies model collections into immutable values', () {
      final links = <ProjectLink>[
        const ProjectLink(
          type: ProjectLinkType.launch,
          uri: 'https://example.com',
        ),
      ];
      final technologies = <String>['Dart'];
      final descriptions = <String, ProjectDescription>{
        'pt': const ProjectDescription(concept: 'C', implementation: 'I'),
        'en': const ProjectDescription(concept: 'C', implementation: 'I'),
      };
      final project = ProjectModel(
        title: 'Project',
        descriptions: descriptions,
        technologies: technologies,
        imagePath: 'https://example.com/image.png',
        links: links,
      );
      links.clear();
      technologies.clear();
      descriptions.clear();

      expect(project.links, hasLength(1));
      expect(project.technologies, ['Dart']);
      expect(project.descriptions, hasLength(2));
      expect(() => project.links.clear(), throwsUnsupportedError);
      expect(() => project.technologies.clear(), throwsUnsupportedError);
      expect(() => project.descriptions.clear(), throwsUnsupportedError);
    });

    test(
      'rejects malformed project fields, links, IDs, and priorities',
      () async {
        final malformedDocuments = <List<Map<String, dynamic>>>[
          [_document()..['title'] = ''],
          [
            _document()..['descriptions'] = {'pt': {}},
          ],
          [
            _document()
              ..['descriptions'] = {
                'pt': {'concept': 'Concept', 'implementation': ' '},
                'en': {
                  'concept': 'Concept',
                  'implementation': 'Implementation',
                },
              },
          ],
          [
            _document()..['technologies'] = ['Dart', ' dart '],
          ],
          [
            _document()..['technologies'] = ['  '],
          ],
          [_document()..['technologies'] = null],
          [_document()..['links'] = null],
          [
            _document()..['links'] = ['not a link map'],
          ],
          [
            _document()
              ..['links'] = [
                {'type': 'launch', 'url': 'javascript:alert(1)'},
              ],
          ],
          [
            _document()
              ..['links'] = [
                {'type': 'preview', 'url': 'https://example.com'},
              ],
          ],
          [_document(), _document()],
          [_document()..['priority'] = 'zero'],
        ];

        for (final documents in malformedDocuments) {
          final repository = DefaultProjectRepository(
            FakeProjectService(documents),
          );
          await expectLater(repository.loadProjects(), throwsFormatException);
        }
      },
    );

    test('propagates service failures', () async {
      final error = StateError('service unavailable');
      final repository = DefaultProjectRepository(
        FakeProjectService.failure(error),
      );

      await expectLater(repository.loadProjects(), throwsA(same(error)));
    });
  });
}

Map<String, dynamic> _document({
  String id = 'Project-id',
  int priority = 0,
  String title = 'Project',
  List<dynamic> links = const [],
}) => {
  'id': id,
  'priority': priority,
  'title': title,
  'descriptions': {
    'pt': {
      'concept': 'Portuguese concept for $title',
      'implementation': 'Portuguese implementation for $title',
    },
    'en': {
      'concept': 'English concept for $title',
      'implementation': 'English implementation for $title',
    },
  },
  'technologies': ['Dart', 'Flutter'],
  'imageUrl': 'https://example.com/image.png',
  'links': links,
};

ProjectModel _model(String title) => ProjectModel(
  title: title,
  descriptions: const {
    'pt': ProjectDescription(concept: 'Concept', implementation: 'Build'),
    'en': ProjectDescription(concept: 'Concept', implementation: 'Build'),
  },
  technologies: const [],
  imagePath: 'https://example.com/image.png',
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
