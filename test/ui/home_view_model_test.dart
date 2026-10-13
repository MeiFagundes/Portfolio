import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/ui/home/home_view_model.dart';

import '../fakes.dart';

void main() {
  test(
    'Shares in-flight load, caches successful data and keeps it immutable',
    () async {
      final pending = Completer<List<ProjectModel>>();
      final repository = FakeProjectRepository(() => pending.future);
      final model = HomeViewModel(
        repository: repository,
        linkLauncher: FakeLinkLauncher(),
      );
      addTearDown(model.dispose);
      final first = model.loadProjects();
      final second = model.loadProjects();
      expect(identical(first, second), isTrue);
      expect(model.status, ProjectLoadStatus.loading);
      final projects = [sampleProject()];
      pending.complete(projects);
      await first;
      projects.clear();
      expect(model.status, ProjectLoadStatus.ready);
      expect(model.projects, hasLength(1));
      expect(() => model.projects.clear(), throwsUnsupportedError);
      await model.loadProjects();
      expect(repository.calls, 1);
    },
  );

  test(
    'Synchronous failures and failed retries are handled, then recover',
    () async {
      var fail = true;
      final repository = FakeProjectRepository(() {
        if (fail) throw StateError('offline');
        return Future.value([]);
      });
      final model = HomeViewModel(
        repository: repository,
        linkLauncher: FakeLinkLauncher(),
      );
      addTearDown(model.dispose);
      await model.loadProjects();
      expect(model.status, ProjectLoadStatus.error);
      await model.retry();
      expect(model.status, ProjectLoadStatus.error);
      fail = false;
      await model.retry();
      expect(repository.calls, 3);
      expect(model.status, ProjectLoadStatus.ready);
      expect(model.projects, isEmpty);
    },
  );

  test('Disposing while loading prevents late state notifications', () async {
    final pending = Completer<List<ProjectModel>>();
    final model = HomeViewModel(
      repository: FakeProjectRepository(() => pending.future),
      linkLauncher: FakeLinkLauncher(),
    );
    var notifications = 0;
    model.addListener(() => notifications++);
    final load = model.loadProjects();
    model.dispose();
    pending.completeError(StateError('offline'));
    await load;
    expect(notifications, 1);
    await model.loadProjects();
  });

  test('Link action delegates the exact destination and result', () async {
    final launcher = FakeLinkLauncher()..result = false;
    final model = HomeViewModel(
      repository: FakeProjectRepository(() async => []),
      linkLauncher: launcher,
    );
    addTearDown(model.dispose);
    expect(await model.openLink('mailto:example@example.com'), isFalse);
    expect(launcher.lastUri, 'mailto:example@example.com');
  });
}
