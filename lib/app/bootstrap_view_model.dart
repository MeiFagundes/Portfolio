import 'package:flutter/foundation.dart';

import 'dependencies.dart';

enum BootstrapStatus { loading, ready, error }

class BootstrapViewModel extends ChangeNotifier {
  BootstrapViewModel({required this._initialize});

  final Future<AppDependencies> Function() _initialize;
  BootstrapStatus _status = BootstrapStatus.loading;
  AppDependencies? _dependencies;
  Future<void>? _pending;
  bool _disposed = false;

  BootstrapStatus get status => _status;
  AppDependencies? get dependencies => _dependencies;

  Future<void> initialize() {
    if (_disposed || _status == BootstrapStatus.ready) return Future.value();
    return _pending ??= _load();
  }

  Future<void> _load() async {
    _status = BootstrapStatus.loading;
    notifyListeners();
    try {
      final dependencies = await Future<AppDependencies>.sync(_initialize);
      if (_disposed) return;
      _dependencies = dependencies;
      _status = BootstrapStatus.ready;
    } catch (_) {
      if (_disposed) return;
      _status = BootstrapStatus.error;
    } finally {
      _pending = null;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
