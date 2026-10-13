import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/project_repository.dart';
import '../data/services/http_project_service.dart';
import '../data/services/link_launcher.dart';
import '../data/services/locale_preference_store.dart';

class AppDependencies {
  const AppDependencies({
    required this.projectRepository,
    required this.linkLauncher,
    required this.localePreferenceStore,
    this.initialLanguageCode,
  });

  final ProjectRepository projectRepository;
  final LinkLauncher linkLauncher;
  final LocalePreferenceStore localePreferenceStore;
  final String? initialLanguageCode;
}

/// The composition root is the only place that resolves plugin singletons.
Future<AppDependencies> createAppDependencies({
  LocalePreferenceStore? localePreferenceStore,
}) async {
  final store =
      localePreferenceStore ??
      SharedPreferencesLocalePreferenceStore(SharedPreferencesAsync());
  String? initialLanguageCode;
  try {
    initialLanguageCode = await store.readLanguageCode();
  } catch (_) {
    // Browser storage may be unavailable; language preferences are optional.
  }
  return AppDependencies(
    projectRepository: DefaultProjectRepository(
      HttpProjectService(
        client: http.Client(),
        endpoint: Uri.parse(
          const String.fromEnvironment(
            'PORTFOLIO_CONTENT_URL',
            defaultValue:
                'https://meifagundesdotcom-content.web.app/v2/projects.json',
          ),
        ),
      ),
    ),
    linkLauncher: const UrlLauncherService(),
    localePreferenceStore: store,
    initialLanguageCode: initialLanguageCode,
  );
}
