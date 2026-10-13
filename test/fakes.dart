import 'package:meifagundesdotcom/app/dependencies.dart';
import 'package:meifagundesdotcom/data/repositories/project_repository.dart';
import 'package:meifagundesdotcom/data/services/link_launcher.dart';
import 'package:meifagundesdotcom/data/services/locale_preference_store.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

class FakeProjectRepository implements ProjectRepository {
  FakeProjectRepository(this.loader);
  final Future<List<ProjectModel>> Function() loader;
  int calls = 0;

  @override
  Future<List<ProjectModel>> loadProjects() {
    calls++;
    return loader();
  }
}

class FakeLinkLauncher implements LinkLauncher {
  bool result = true;
  String? lastUri;

  @override
  Future<bool> open(String uri) async {
    lastUri = uri;
    return result;
  }
}

AppDependencies fakeDependencies(
  FakeProjectRepository repository, [
  FakeLinkLauncher? links,
  FakeLocalePreferenceStore? preferences,
  String? initialLanguageCode,
]) => AppDependencies(
  projectRepository: repository,
  linkLauncher: links ?? FakeLinkLauncher(),
  localePreferenceStore: preferences ?? FakeLocalePreferenceStore(),
  initialLanguageCode: initialLanguageCode,
);

ProjectModel sampleProject({String title = 'Projeto'}) => ProjectModel(
  title: title,
  descriptions: const {
    'pt': ProjectDescription(
      concept: 'Descrição preservada',
      implementation: 'Implementação técnica',
    ),
    'en': ProjectDescription(
      concept: 'Project concept',
      implementation: 'Technical implementation',
    ),
  },
  technologies: const ['Dart', 'Flutter'],
  imagePath: 'https://example.com/image.png',
  links: [
    const ProjectLink(type: ProjectLinkType.source, uri: 'https://example.com'),
  ],
);

class FakeLocalePreferenceStore implements LocalePreferenceStore {
  String? languageCode;
  bool failRead = false;
  bool failWrite = false;

  @override
  Future<String?> readLanguageCode() async {
    if (failRead) throw StateError('storage unavailable');
    return languageCode;
  }

  @override
  Future<void> writeLanguageCode(String value) async {
    if (failWrite) throw StateError('storage unavailable');
    languageCode = value;
  }
}
