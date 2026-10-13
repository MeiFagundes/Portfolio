import 'package:flutter/foundation.dart';

import '../../data/repositories/project_repository.dart';
import '../../data/services/link_launcher.dart';
import '../../models/project_model.dart';

enum ProjectLoadStatus { initial, loading, ready, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this._repository, required this._linkLauncher});

  final ProjectRepository _repository;
  final LinkLauncher _linkLauncher;
  ProjectLoadStatus _status = ProjectLoadStatus.initial;
  List<ProjectModel> _projects = const [];
  Future<void>? _pendingLoad;
  bool _disposed = false;

  ProjectLoadStatus get status => _status;
  List<ProjectModel> get projects => _projects;

  /// Rebuilds and repeated events share the in-flight or completed load.
  Future<void> loadProjects() {
    if (_disposed) return Future.value();
    if (_pendingLoad != null) return _pendingLoad!;
    if (_status == ProjectLoadStatus.ready) return Future.value();
    final future = _loadProjects();
    _pendingLoad = future;
    return future;
  }

  Future<void> retry() => loadProjects();

  Future<void> _loadProjects() async {
    _status = ProjectLoadStatus.loading;
    notifyListeners();
    try {
      final projects = await Future<List<ProjectModel>>.sync(
        _repository.loadProjects,
      );
      if (_disposed) return;
      _projects = List.unmodifiable(projects);
      _status = ProjectLoadStatus.ready;
    } catch (_) {
      if (_disposed) return;
      _status = ProjectLoadStatus.error;
    } finally {
      _pendingLoad = null;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> openLink(String uri) => _linkLauncher.open(uri);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
