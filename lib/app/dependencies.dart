import 'package:http/http.dart' as http;

import '../data/repositories/project_repository.dart';
import '../data/services/http_project_service.dart';
import '../data/services/link_launcher.dart';

class AppDependencies {
  const AppDependencies({
    required this.projectRepository,
    required this.linkLauncher,
  });

  final ProjectRepository projectRepository;
  final LinkLauncher linkLauncher;
}

/// The composition root is the only place that resolves plugin singletons.
Future<AppDependencies> createAppDependencies() async => AppDependencies(
  projectRepository: DefaultProjectRepository(
    HttpProjectService(
      client: http.Client(),
      endpoint: Uri.parse(
        const String.fromEnvironment(
          'PORTFOLIO_CONTENT_URL',
          defaultValue:
              'https://meifagundesdotcom-content.web.app/v1/projects.json',
        ),
      ),
    ),
  ),
  linkLauncher: const UrlLauncherService(),
);
