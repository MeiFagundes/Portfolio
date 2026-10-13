import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../data/repositories/project_repository.dart';
import '../data/services/firestore_project_service.dart';
import '../data/services/link_launcher.dart';
import '../firebase_options.dart';

class AppDependencies {
  const AppDependencies({
    required this.projectRepository,
    required this.linkLauncher,
  });

  final ProjectRepository projectRepository;
  final LinkLauncher linkLauncher;
}

/// The composition root is the only place that resolves plugin singletons.
Future<AppDependencies> createAppDependencies() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return AppDependencies(
    projectRepository: FirestoreProjectRepository(
      FirestoreProjectService(firestore: FirebaseFirestore.instance),
    ),
    linkLauncher: const UrlLauncherService(),
  );
}
