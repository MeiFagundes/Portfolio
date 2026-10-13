import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/app/bootstrap_view_model.dart';
import 'package:meifagundesdotcom/app/dependencies.dart';

import '../fakes.dart';

void main() {
  test(
    'Initialization shares a pending request and is idempotent when ready',
    () async {
      final pending = Completer<AppDependencies>();
      var calls = 0;
      final model = BootstrapViewModel(
        initialize: () {
          calls++;
          return pending.future;
        },
      );
      addTearDown(model.dispose);
      final first = model.initialize();
      expect(model.initialize(), same(first));
      final dependencies = fakeDependencies(
        FakeProjectRepository(() async => []),
      );
      pending.complete(dependencies);
      await first;
      expect(model.status, BootstrapStatus.ready);
      expect(model.dependencies, same(dependencies));
      await model.initialize();
      expect(calls, 1);
    },
  );

  test(
    'Synchronous initialization failure can be retried successfully',
    () async {
      var fail = true;
      final dependencies = fakeDependencies(
        FakeProjectRepository(() async => []),
      );
      final model = BootstrapViewModel(
        initialize: () {
          if (fail) throw StateError('offline');
          return Future.value(dependencies);
        },
      );
      addTearDown(model.dispose);
      await model.initialize();
      expect(model.status, BootstrapStatus.error);
      fail = false;
      await model.initialize();
      expect(model.status, BootstrapStatus.ready);
    },
  );
}
